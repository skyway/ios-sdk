//
//  SKWContextOptions.mm
//  AutoSubscribingRoom
//
//  Created by Naoto Takahashi on 2023/02/03.
//  Copyright © 2023 NTT Communications. All rights reserved.
//

#import "SKWContextOptions.h"

#import "Type+Internal.h"

#import <skyway/core/context.hpp>
#import "NSString+StdString.h"

using NativeContextOptions = skyway::core::ContextOptions;

@interface SKWContextOptionsRTCAPI ()
- (skyway::core::ContextOptions::RtcApi)native;
@end

@implementation SKWContextOptionsRTCAPI

- (id)init {
    if (self = [super init]) {
        _secure = true;
    }
    return self;
}

- (NativeContextOptions::RtcApi)native {
    NativeContextOptions::RtcApi native;
    if (_domain) {
        native.domain = [NSString stdStringForString:_domain];
    }
    native.secure = _secure;
    return native;
}

@end

@interface SKWContextOptionsICEParams ()
- (skyway::core::ContextOptions::IceParams)native;
@end

@implementation SKWContextOptionsICEParams

- (id)init {
    if (self = [super init]) {
        _version = 0;
        _secure  = true;
    }
    return self;
}

- (NativeContextOptions::IceParams)native {
    NativeContextOptions::IceParams native;
    if (_domain) {
        native.domain = [NSString stdStringForString:_domain];
    }
    if (_version) {
        native.version = _version;
    }
    native.secure = _secure;
    return native;
}

@end

@interface SKWContextOptionsSignaling ()
- (skyway::core::ContextOptions::Signaling)native;
@end

@implementation SKWContextOptionsSignaling

- (id)init {
    if (self = [super init]) {
        _secure = true;
    }
    return self;
}

- (NativeContextOptions::Signaling)native {
    NativeContextOptions::Signaling native;
    if (_domain) {
        native.domain = [NSString stdStringForString:_domain];
    }
    native.secure = _secure;
    return native;
}

@end

@implementation SKWContextOptionsRTCConfig

- (id)init {
    if (self = [super init]) {
        _policy = SKWTurnPolicyEnable;
    }
    return self;
}

- (NativeContextOptions::RtcConfig)native {
    NativeContextOptions::RtcConfig native;
    native.policy = nativeTurnPolicyForTurnPolicy(_policy);
    return native;
}

@end

@interface SKWContextOptionsToken ()
- (skyway::core::ContextOptions::Token)native;
@end

@implementation SKWContextOptionsToken

- (id)init {
    if (self = [super init]) {
        _remindTimeInSec = 0;
    }
    return self;
}

- (NativeContextOptions::Token)native {
    NativeContextOptions::Token native;
    if (_remindTimeInSec) {
        native.remind_time_sec = _remindTimeInSec;
    }
    return native;
}

@end

@implementation SKWContextOptions

- (id)init {
    if (self = [super init]) {
        _logLevel  = SKWLogLevelError;
        _rtcApi    = [[SKWContextOptionsRTCAPI alloc] init];
        _iceParams = [[SKWContextOptionsICEParams alloc] init];
        _signaling = [[SKWContextOptionsSignaling alloc] init];
        _rtcConfig = [[SKWContextOptionsRTCConfig alloc] init];
        _token     = [[SKWContextOptionsToken alloc] init];
    }
    return self;
}

- (NativeContextOptions)nativeOptions {
    skyway::core::ContextOptions nativeOptions;
    nativeOptions.rtc_api    = _rtcApi.native;
    nativeOptions.ice_params = _iceParams.native;
    nativeOptions.signaling  = _signaling.native;
    nativeOptions.rtc_config = _rtcConfig.native;
    nativeOptions.token      = _token.native;
    return nativeOptions;
}
@end
