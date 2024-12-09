//
//  HttpClient.hpp
//  SkyWayRoom
//
//  Created by sandabu on 2022/07/05.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKYWAY_NETWORK_IOS_HTTP_CLIENT_HPP_
#define SKYWAY_NETWORK_IOS_HTTP_CLIENT_HPP_

#include <future>
#include <json.hpp>

#include "skyway/network/interface/http_client.hpp"

namespace skyway {
namespace network {

using HttpClientInterface = interface::HttpClient;

class HttpClient : public HttpClientInterface {
public:
    std::future<std::optional<HttpClientInterface::Response>> Request(
        const std::string& native_url,
        const std::string& native_method,
        const nlohmann::json& native_header,
        const nlohmann::json& native_body) override;
};

}  // namespace network
}  // namespace skyway

#endif /* SKYWAY_NETWORK_IOS_HTTP_CLIENT_HPP_ */
