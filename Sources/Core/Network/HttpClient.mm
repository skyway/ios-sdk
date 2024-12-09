//
//  HttpClient.mm
//  SkyWayRoom
//
//  Created by sandabu on 2022/07/05.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#include "./HttpClient.hpp"

#include "NSString+StdString.h"
#include "skyway/global/interface/logger.hpp"
#include "skyway/network/util.hpp"

namespace skyway {
namespace network {

std::future<std::optional<HttpClientInterface::Response>> HttpClient::Request(
    const std::string& native_url,
    const std::string& native_method,
    const nlohmann::json& native_header,
    const nlohmann::json& native_body) {
    __block std::promise<std::optional<HttpClientInterface::Response>> promise;
    NSString* method             = [NSString stringForStdString:native_method];
    NSString* urlString          = [NSString stringForStdString:native_url];
    NSURL* url                   = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:method];
    for (auto const& item : native_header.items()) {
        NSString* key   = [NSString stringForStdString:item.key()];
        NSString* value = [NSString stringForStdString:item.value()];
        [request setValue:value forHTTPHeaderField:key];
    }
    if (!native_body.empty() || native_method != HttpClientInterface::METHOD_GET) {
        [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Accept"];
        NSString* bodyJsonString = [NSString stringForStdString:native_body.dump()];
        NSData* bodyData         = [bodyJsonString dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:bodyData];
    }

    NSURLSessionTask* task = [[NSURLSession sharedSession]
        dataTaskWithRequest:request
          completionHandler:^(NSData* _Nullable _data,
                              NSURLResponse* _Nullable _response,
                              NSError* _Nullable _error) {
            NSData* data                = _data;
            NSHTTPURLResponse* response = (NSHTTPURLResponse*)_response;
            NSError* error              = _error;
            if (error) {
                SKW_WARN("Error response has received. code: %d", error.code);
                promise.set_value(std::nullopt);
                return;
            }
            __block nlohmann::json nativeHeader;
            [response.allHeaderFields enumerateKeysAndObjectsUsingBlock:^(
                                          id _Nonnull key, id _Nonnull obj, BOOL* _Nonnull stop) {
              std::string nativeKey   = [NSString stdStringForString:key];
              std::string nativeValue = [NSString stdStringForString:obj];
              nativeHeader[nativeKey] = nativeValue;
            }];
            nlohmann::json nativeBody;
            if (data && data.length != 0) {
                NSString* dataString = [[NSString alloc] initWithData:data
                                                             encoding:NSUTF8StringEncoding];
                if (dataString) {
                    try {
                        nativeBody = nlohmann::json::parse([dataString stdString]);
                    } catch (const nlohmann::json::exception& e) {
                        // clang-format off
                    nativeBody = {
                        { "body", [dataString stdString] }
                    };
                        // clang-format on
                        SKW_ERROR("Server returns invalid JSON format body: %s", nativeBody);
                        promise.set_value(std::nullopt);
                        return;
                    }
                }
            }
            HttpClientInterface::Response nativeResponse;
            nativeResponse.status = (int)response.statusCode;
            nativeResponse.header = nativeHeader;
            nativeResponse.body   = nativeBody;
            promise.set_value(nativeResponse);
          }];
    [task resume];

    return promise.get_future();
}

}  // namespace network
}  // namespace skyway
