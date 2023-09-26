//
//  SKWContext.mm
//  SkyWay
//
//  Created by sandabu on 2022/02/04.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#import <WebRTC/WebRTC.h>

#import "SKWContext+Internal.h"
#import "SKWContextOptions+Internal.h"
#import "SKWErrorFactory.h"
#import "SKWPlugin+Internal.h"
#import "SKWRemotePersonPlugin+Internal.h"
#import "Type+Internal.h"

#import "HttpClient.hpp"
#import "Logger.hpp"
#import "WebSocketClient.hpp"

#import "NSString+StdString.h"
#import "RTCPeerConnectionFactory+Private.h"

#import <skyway/core/context.hpp>
#import <skyway/token/auth_token.hpp>

using NativeContextOptions           = skyway::core::ContextOptions;
using NativeContextEventListener     = skyway::core::Context::EventListener;
using NativeAuthtokenManagerListener = skyway::token::interface::AuthTokenManager::Listener;

class ContextEventListener : public NativeContextEventListener {
public:
    ContextEventListener(dispatch_group_t group) : group_(group) {}
    void OnReconnectStart() override {
        if ([SKWContext.delegate respondsToSelector:@selector(startReconnecting)]) {
            dispatch_group_async(
                group_, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                  [SKWContext.delegate startReconnecting];
                });
        }
    }
    void OnReconnectSuccess() override {
        if ([SKWContext.delegate respondsToSelector:@selector(reconnectingSucceeded)]) {
            dispatch_group_async(
                group_, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                  [SKWContext.delegate reconnectingSucceeded];
                });
        }
    }
    void OnFatalError(const skyway::global::Error& error) override {
        if ([SKWContext.delegate respondsToSelector:@selector(fatalErrorOccurred:)]) {
            dispatch_group_async(
                group_, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                  [SKWContext.delegate
                      fatalErrorOccurred:[SKWErrorFactory fatalErrorRAPIReconnectFailedError]];
                });
        }
    }
    dispatch_group_t group_;
};

class AuthTokenManagerListener : public NativeAuthtokenManagerListener {
public:
    AuthTokenManagerListener(dispatch_group_t group) : group_(group) {}
    virtual void OnTokenRefreshingNeeded() override {
        if ([SKWContext.delegate respondsToSelector:@selector(shouldUpdateToken)]) {
            dispatch_group_async(
                group_, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                  [SKWContext.delegate shouldUpdateToken];
                });
        }
    }
    virtual void OnTokenExpired() override {
        if ([SKWContext.delegate respondsToSelector:@selector(tokenExpired)]) {
            dispatch_group_async(
                group_, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                  [SKWContext.delegate tokenExpired];
                });
        }
    }
    dispatch_group_t group_;
};

@implementation SKWContext

using Context = skyway::core::Context;

static RTCPeerConnectionFactory* _Nullable _pcFactory;
static NSMutableArray<SKWPlugin*>* _plugins = [[NSMutableArray alloc] init];
static id<SKWContextDelegate> _Nullable _delegate;
static std::unique_ptr<NativeContextEventListener> _contextListener;
static std::unique_ptr<NativeAuthtokenManagerListener> _authTokenListener;
static dispatch_group_t eventGroup = dispatch_group_create();

+ (RTCPeerConnectionFactory* _Nullable)pcFactory {
    return _pcFactory;
}

+ (void)setupWithToken:(NSString* _Nonnull)token
               options:(SKWContextOptions* _Nullable)options
            completion:(SKWContextSetupCompletion _Nullable)completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      RTCInitializeSSL();
      if (_pcFactory == nil) {
          _pcFactory = [[RTCPeerConnectionFactory alloc]
              initWithEncoderFactory:[[RTCDefaultVideoEncoderFactory alloc] init]
                      decoderFactory:[[RTCDefaultVideoDecoderFactory alloc] init]];
      }
      NativeContextOptions nativeOptions;
      if (options) {
          nativeOptions = options.nativeOptions;
      }
      _authTokenListener           = std::make_unique<AuthTokenManagerListener>(eventGroup);
      nativeOptions.token.listener = _authTokenListener.get();
      auto nativeFactory           = _pcFactory.nativeFactory;
      // Setting for logger
      auto nativeLogLevel = nativeLogLevelForLogLevel(options.logLevel);

      auto logger = std::make_unique<skyway::global::Logger>(nativeLogLevel);
      // Setting for plugins
      // RemotePerson Plugin
      auto remotePersonPlugin = [[SKWRemotePersonPlugin alloc] initWithVoid];
      [SKWContext registerPlugin:remotePersonPlugin];

      auto http               = std::make_unique<skyway::network::HttpClient>();
      std::string nativeToken = [NSString stdStringForString:token];
      auto ws_factory         = std::make_unique<skyway::network::WebSocketClientFactory>();
      _contextListener        = std::make_unique<ContextEventListener>(eventGroup);
      auto result             = Context::Setup(nativeToken,
                                   std::move(http),
                                   std::move(ws_factory),
                                   std::move(logger),
                                   _contextListener.get(),
                                   nativeOptions);
      if (completion) {
          if (result) {
              completion(nil);
          } else {
              completion([SKWErrorFactory contextSetupError]);
          }
      }
    });
}

+ (bool)updateToken:(NSString* _Nonnull)token {
    auto nativeToken = [NSString stdStringForString:token];
    return Context::UpdateAuthToken(nativeToken);
}

+ (void)_updateRTCConfig:(SKWContextOptionsRTCConfig* _Nonnull)config {
    Context::_UpdateRtcConfig(config.native);
}

+ (void)registerPlugin:(SKWPlugin* _Nonnull)plugin {
    [_plugins addObject:plugin];
    Context::RegisterPlugin(plugin.uniqueNative);
}

+ (NSArray* _Nonnull)plugins {
    return [_plugins copy];
}

+ (id<SKWContextDelegate>)delegate {
    return _delegate;
}

+ (void)setDelegate:(id<SKWContextDelegate>)delegate {
    _delegate = delegate;
}

+ (void)disposeWithCompletion:(SKWContextDisposeCompletion _Nullable)completion {
    dispatch_group_notify(
        eventGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          Context::Dispose();
          // DO NOT remove `_pcFactory` here because some resources still remain (e.g.
          // RTCMediaTrack) and these depend on a rtc thread managed by PeerConnection factory.
          _contextListener.reset();
          _authTokenListener.reset();
          [_plugins removeAllObjects];
          auto result = RTCCleanupSSL();
          if (completion) {
              if (result) {
                  completion(nil);
              } else {
                  completion([SKWErrorFactory contextDisposeError]);
              }
          }
        });
}

@end
