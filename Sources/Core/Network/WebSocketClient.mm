//
//  WebSocketClient.mm
//  SkyWayRoom
//
//  Created by sandabu on 2022/07/05.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#import <SocketRocket/SocketRocket.h>
#include <unordered_set>

#include "./WebSocketClient.hpp"

#include "NSString+StdString.h"
#include "skyway/global/interface/logger.hpp"
#include "skyway/network/util.hpp"

@interface WebSocketDelegator : NSObject <SRWebSocketDelegate> {
    std::promise<bool> openPromise_;
    std::promise<bool> closePromise_;
    skyway::network::WebSocketClient::Listener* listener_;
    std::mutex listener_related_mtx_;
    std::unordered_set<std::unique_ptr<std::thread>> listener_threads_;
    bool selfClosing_;
}

@property(nonatomic) SRWebSocket* socket;

- (void)registerListener:(skyway::network::WebSocketClient::Listener*)listener;
- (std::future<bool>)connectWithUrl:(NSURL*)url
                       subprotocols:(NSArray<NSString*>* _Nonnull)subprotocols
                            headers:(NSDictionary<NSString*, NSString*>* _Nonnull)headers;
- (std::future<bool>)sendMessage:(NSString*)message;
- (std::future<bool>)closeWithCode:(int)code reason:(NSString* _Nullable)reason;
- (std::future<bool>)destroy;
- (void)webSocketDidOpen:(SRWebSocket*)webSocket;
- (void)webSocket:(SRWebSocket*)webSocket didFailWithError:(NSError*)error;
- (void)webSocket:(SRWebSocket*)webSocket didReceiveMessageWithString:(NSString*)string;
- (void)webSocket:(SRWebSocket*)webSocket
    didCloseWithCode:(NSInteger)code
              reason:(NSString*)reason
            wasClean:(BOOL)wasClean;
@end

@implementation WebSocketDelegator

- (id)init {
    if (self = [super init]) {
        listener_    = nullptr;
        selfClosing_ = false;
    }
    return self;
}

- (void)registerListener:(skyway::network::WebSocketClient::Listener*)listener {
    std::lock_guard<std::mutex> lg(listener_related_mtx_);
    listener_ = listener;
}

- (std::future<bool>)connectWithUrl:(NSURL*)url
                       subprotocols:(NSArray<NSString*>* _Nonnull)subprotocols
                            headers:(NSDictionary<NSString*, NSString*>* _Nonnull)headers {
    @synchronized(self) {
        openPromise_ = std::promise<bool>();
        if (_socket) {
            if (_socket.readyState == SR_OPEN) {
                openPromise_.set_value(true);
                return openPromise_.get_future();
            } else {
                // Workaround to avoid `webSocketDidOpen` is called twice
                // in the bad network environment.
                _socket.delegate = nil;
                _socket          = nil;
            }
        }
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
        [headers enumerateKeysAndObjectsUsingBlock:^(
                     NSString* _Nonnull key, NSString* _Nonnull obj, BOOL* _Nonnull stop) {
          [request setValue:obj forHTTPHeaderField:key];
        }];
        _socket          = [[SRWebSocket alloc] initWithURLRequest:request protocols:subprotocols];
        _socket.delegate = self;
        // Sub thread is created and set because default thread is main and it will be blocked
        // below.
        dispatch_queue_t dispatchQueue =
            dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        [_socket setDelegateDispatchQueue:dispatchQueue];
        [_socket open];
        return openPromise_.get_future();
    }
}

- (std::future<bool>)sendMessage:(NSString*)message {
    @synchronized(self) {
        std::promise<bool> promise;
        if (!_socket || _socket.readyState != SR_OPEN) {
            SKW_ERROR("Sending message failed because webSocket is not open.");
            promise.set_value(false);
            return promise.get_future();
        }

        NSError* error;
        BOOL result = [_socket sendString:message error:&error];
        if (error) {
            std::string errorStdString = [NSString stdStringForString:[error localizedDescription]];
            SKW_ERROR(errorStdString);
            promise.set_value(false);
            return promise.get_future();
        }
        promise.set_value(result);
        return promise.get_future();
    }
}

- (std::future<bool>)closeWithCode:(int)code reason:(NSString* _Nullable)reason {
    @synchronized(self) {
        selfClosing_  = true;
        closePromise_ = std::promise<bool>();
        if (_socket && _socket.readyState == SR_OPEN) {
            [_socket closeWithCode:code reason:reason];
        } else {
            SKW_DEBUG("Socket has already closed or not connected.");
            closePromise_.set_value(true);
            selfClosing_ = false;
        }
        return closePromise_.get_future();
    }
}

- (std::future<bool>)destroy {
    return std::async(std::launch::async, [=] {
        {
            std::lock_guard<std::mutex> lg(listener_related_mtx_);
            for (const auto& t : listener_threads_) {
                if (t && t->joinable()) {
                    t->join();
                }
            }
            listener_threads_.clear();
            listener_ = nullptr;
            // Unlock here becasue onClose will get lock guard with listener_threads_mtx_
        }
        auto close_res = [self closeWithCode:1000 reason:@""];
        return close_res.get();
    });
}

- (void)webSocketDidOpen:(SRWebSocket*)webSocket {
    @synchronized(self) {
        // Workaround to avoid `openPromise_.set_value`
        // is called twice in the bad network environment.
        try {
            SKW_DEBUG("🔔OnOpen")
            openPromise_.set_value(true);
        } catch (std::future_error& error) {
            SKW_WARN("The promise value has already been set.")
            return;
        }
    }
}

- (void)webSocket:(SRWebSocket*)webSocket didFailWithError:(NSError*)error {
    @synchronized(self) {
        SKW_ERROR(error.description.stdString);
        auto code = (int)[[error.userInfo valueForKey:@"HTTPResponseStatusCode"] integerValue];
        if (selfClosing_) {
            closePromise_.set_value(false);
            selfClosing_ = false;
        }
        std::lock_guard<std::mutex> lg(listener_related_mtx_);
        if (listener_) {
            auto t = std::make_unique<std::thread>([=] { listener_->OnError(code); });
            listener_threads_.emplace(std::move(t));
        }
    }
}

- (void)webSocket:(SRWebSocket*)webSocket didReceiveMessageWithString:(NSString*)string {
    SKW_DEBUG("🔔OnMessage")
    std::string nativeString = [NSString stdStringForString:string];
    std::lock_guard<std::mutex> lg(listener_related_mtx_);
    if (listener_) {
        auto t = std::make_unique<std::thread>([=] { listener_->OnMessage(nativeString); });
        listener_threads_.emplace(std::move(t));
    }
}

- (void)webSocket:(SRWebSocket*)webSocket
    didCloseWithCode:(NSInteger)code
              reason:(NSString*)reason
            wasClean:(BOOL)wasClean {
    @synchronized(self) {
        SKW_DEBUG("WebSocket was closed.");
        if (!wasClean) {
            SKW_WARN([NSString stdStringForString:reason]);
        }
        _socket = nil;
        std::lock_guard<std::mutex> lg(listener_related_mtx_);
        if (listener_) {
            auto t = std::make_unique<std::thread>([=] { listener_->OnClose((int)code); });
            listener_threads_.emplace(std::move(t));
        }
        if (selfClosing_) {
            closePromise_.set_value(true);
            selfClosing_ = false;
        }
    }
}

@end

namespace skyway {
namespace network {

class WebSocketClient::Impl {
public:
    Impl() : delegator_([[WebSocketDelegator alloc] init]) {}
    WebSocketDelegator* delegator_;
};

WebSocketClient::WebSocketClient() : impl_(std::make_unique<WebSocketClient::Impl>()) {}
WebSocketClient::~WebSocketClient() { SKW_TRACE("~WebSocketClient"); }

void WebSocketClient::RegisterListener(WebSocketClientInterface::Listener* listener) {
    [impl_->delegator_ registerListener:listener];
}

std::future<bool> WebSocketClient::Connect(const std::string& native_url,
                                           const std::string& native_sub_protocol) {
    std::vector<std::string> sub_protocols{native_sub_protocol};
    return this->Connect(native_url, sub_protocols, {});
}

std::future<bool> WebSocketClient::Connect(
    const std::string& native_url,
    const std::vector<std::string>& native_sub_protocols,
    const std::unordered_map<std::string, std::string>& headers) {
    NSString* urlString = [NSString stringForStdString:native_url];
    NSURL* url          = [[NSURL alloc] initWithString:urlString];

    NSMutableArray<NSString*>* sub_protocols = [NSMutableArray array];
    for (const auto& native_subprotocol : native_sub_protocols) {
        NSString* subprotocol = [NSString stringForStdString:native_subprotocol];
        [sub_protocols addObject:subprotocol];
    }

    NSMutableDictionary<NSString*, NSString*>* headers_dict = [NSMutableDictionary dictionary];
    for (const auto& pair : headers) {
        NSString* key   = [NSString stringForStdString:pair.first];
        NSString* value = [NSString stringForStdString:pair.second];
        [headers_dict setValue:value forKey:key];
    }

    return [impl_->delegator_ connectWithUrl:url subprotocols:sub_protocols headers:headers_dict];
}

std::future<bool> WebSocketClient::Send(const std::string& native_message) {
    SKW_TRACE("Send message with websocket :%s", native_message);
    NSString* messageString = [NSString stringForStdString:native_message];
    return [impl_->delegator_ sendMessage:messageString];
}

std::future<bool> WebSocketClient::Close(const int code, const std::string& reason) {
    NSString* _reason = nil;
    if (!reason.empty()) {
        _reason = [NSString stringForStdString:reason];
    }
    return [impl_->delegator_ closeWithCode:code reason:_reason];
}

std::future<bool> WebSocketClient::Destroy() { return [impl_->delegator_ destroy]; }

// Factory
std::shared_ptr<interface::WebSocketClient> WebSocketClientFactory::Create() {
    return std::make_shared<WebSocketClient>();
}

}  // namespace network
}  // namespace skyway
