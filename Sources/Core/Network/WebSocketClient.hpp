//
//  WebSocketClient.hpp
//  SkyWayRoom
//
//  Created by sandabu on 2022/07/05.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef WebSocketClient_hpp
#define WebSocketClient_hpp

#include "skyway/network/interface/websocket_client.hpp"

using WebSocketClientInterface = skyway::network::interface::WebSocketClient;

namespace skyway {
namespace network {

class WebSocketClient : public WebSocketClientInterface {
public:
    WebSocketClient();
    ~WebSocketClient();
    // WebSocketClientInterface
    void RegisterListener(WebSocketClientInterface::Listener* listener) override;
    std::future<bool> Connect(const std::string& url, const std::string& sub_protocol) override;
    std::future<bool> Connect(const std::string& url, const std::vector<std::string>& sub_protocols, const std::unordered_map<std::string, std::string>& headers) override;
    std::future<bool> Send(const std::string& message) override;
    std::future<bool> Close(const int code, const std::string& reason) override;
    std::future<bool> Destroy() override;
private:
    class Impl;
    std::unique_ptr<Impl> impl_;
    std::mutex disposer_mtx_;
    std::unique_ptr<std::thread> disposer_thread_;
    std::condition_variable disposer_cv_;
};

class WebSocketClientFactory : public interface::WebSocketClientFactory {
public:
    std::shared_ptr<interface::WebSocketClient> Create() override;
};

}  // namespace network
}  // namespace skyway

#endif /* WebSocketClient_hpp */
