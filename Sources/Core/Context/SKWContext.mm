//
//  SKWContext.mm
//  SkyWay
//
//  Created by sandabu on 2022/02/04.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#import <WebRTC/WebRTC.h>

#import "SKWContext+Internal.h"
#import "SKWPlugin+Internal.h"
#import "SKWRemotePersonPlugin+Internal.h"
#import "SKWErrorFactory.h"
#import "Type+Internal.h"
#import "Logger.hpp"
#import "HttpClient.hpp"
#import "WebSocketClient.hpp"

#import "RTCPeerConnectionFactory+Private.h"
#import "NSString+StdString.h"

#import <skyway/token/auth_token.hpp>
#import <skyway/core/context.hpp>

using NativeContextOptions = skyway::core::ContextOptions;

@interface SKWContextOptionsRTCAPI()
-(skyway::core::ContextOptions::RtcApi)native;
@end

@implementation SKWContextOptionsRTCAPI

-(id)init {
    if(self = [super init]) {
        _secure = true;
    }
    return self;
}

-(NativeContextOptions::RtcApi)native {
    NativeContextOptions::RtcApi native;
    if(_domain) {
        native.domain = [NSString stdStringForString:_domain];
    }
    native.secure = _secure;
    return native;
}

@end

@interface SKWContextOptionsICEParams()
-(skyway::core::ContextOptions::IceParams)native;
@end

@implementation SKWContextOptionsICEParams

-(id)init {
    if(self = [super init]) {
        _version = 0;
        _secure = true;
    }
    return self;
}

-(NativeContextOptions::IceParams)native {
    NativeContextOptions::IceParams native;
    if(_domain) {
        native.domain = [NSString stdStringForString:_domain];
    }
    if(_version) {
        native.version = _version;
    }
    native.secure = _secure;
    return native;
}

@end

@interface SKWContextOptionsSignaling()
-(skyway::core::ContextOptions::Signaling)native;
@end

@implementation SKWContextOptionsSignaling

-(id)init {
    if(self = [super init]) {
        _secure = true;
    }
    return self;
}

-(NativeContextOptions::Signaling)native {
    NativeContextOptions::Signaling native;
    if(_domain) {
        native.domain = [NSString stdStringForString:_domain];
    }
    native.secure = _secure;
    return native;
}

@end

@interface SKWContextOptionsRTCConfig()
-(skyway::core::ContextOptions::RtcConfig)native;
@end

@implementation SKWContextOptionsRTCConfig

-(id)init {
    if(self = [super init]) {
        _policy = SKWTurnPolicyEnable;
    }
    return self;
}

-(NativeContextOptions::RtcConfig)native {
    NativeContextOptions::RtcConfig native;
    native.policy = nativeTurnPolicyForTurnPolicy(_policy);
    return native;
}

@end

@implementation SKWContextOptions

-(id)init {
    if(self = [super init]) {
        _logLevel = SKWLogLevelError;
        _rtcApi =    [[SKWContextOptionsRTCAPI alloc] init];
        _iceParams = [[SKWContextOptionsICEParams alloc] init];
        _signaling = [[SKWContextOptionsSignaling alloc] init];
        _rtcConfig = [[SKWContextOptionsRTCConfig alloc] init];
    }
    return self;
}

-(NativeContextOptions)nativeOptions{
    skyway::core::ContextOptions nativeOptions;
    nativeOptions.rtc_api    = _rtcApi.native;
    nativeOptions.ice_params = _iceParams.native;
    nativeOptions.signaling  = _signaling.native;
    nativeOptions.rtc_config = _rtcConfig.native;
    return nativeOptions;
}
@end


@implementation SKWContext

using Context = skyway::core::Context;

static RTCPeerConnectionFactory* _Nullable _pcFactory;
static NSMutableArray<SKWPlugin*>* _plugins = [[NSMutableArray alloc] init];

+(RTCPeerConnectionFactory* _Nullable)pcFactory{
    return _pcFactory;
}

+(void)setupWithToken:(NSString* _Nonnull)token options:(SKWContextOptions* _Nullable)options completion:(SKWContextSetupCompletion _Nullable)completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        RTCInitializeSSL();
        _pcFactory = [[RTCPeerConnectionFactory alloc]
                      initWithEncoderFactory:[[RTCDefaultVideoEncoderFactory alloc] init]
                      decoderFactory:[[RTCDefaultVideoDecoderFactory alloc] init]];
        NativeContextOptions nativeOptions;
        if(options) {
            nativeOptions = options.nativeOptions;
        }
        auto nativeFactory = _pcFactory.nativeFactory;
        // Setting for logger
        auto nativeLogLevel = nativeLogLevelForLogLevel(options.logLevel);
        
        auto logger = std::make_unique<skyway::global::Logger>(nativeLogLevel);
        // Setting for plugins
        // RemotePerson Plugin
        auto remotePersonPlugin = [[SKWRemotePersonPlugin alloc] initWithVoid];
        [SKWContext registerPlugin:remotePersonPlugin];
        
        auto http = std::make_unique<skyway::network::HttpClient>();
        
        std::string nativeToken = [NSString stdStringForString:token];
        auto ws_factory = std::make_unique<skyway::network::WebSocketClientFactory>();
        auto result = Context::Setup(nativeToken, std::move(http), std::move(ws_factory), std::move(logger), nullptr, nativeOptions);
        if(completion) {
            if(result) {
                completion(nil);
            }else {
                completion([SKWErrorFactory contextSetupError]);
            }
        }
    });
}

+(bool)updateToken:(NSString* _Nonnull)token {
    auto nativeToken = [NSString stdStringForString:token];
    return Context::UpdateAuthToken(nativeToken);
}

+(void)registerPlugin:(SKWPlugin* _Nonnull)plugin {
    [_plugins addObject:plugin];
    Context::RegisterPlugin(plugin.uniqueNative);
}

+(NSArray* _Nonnull)plugins {
    return [_plugins copy];
}

+(void)disposeWithCompletion:(SKWChannelDisposeCompletion _Nullable)completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        Context::Dispose();
        _pcFactory = nil;
        [_plugins removeAllObjects];
        auto result = RTCCleanupSSL();
        if(completion) {
            if(result) {
                completion(nil);
            }else {
                completion([SKWErrorFactory contextDisposeError]);
            }
        }
    });
}

@end
