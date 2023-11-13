//
//  Type.mm
//  SkyWay
//
//  Created by sandabu on 2022/04/05.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#import "Type+Internal.h"

NativeLogLevel nativeLogLevelForLogLevel(SKWLogLevel level) {
    switch (level) {
        case SKWLogLevelError:
            return NativeLogLevel::kError;
        case SKWLogLevelWarn:
            return NativeLogLevel::kWarn;
        case SKWLogLevelInfo:
            return NativeLogLevel::kInfo;
        case SKWLogLevelDebug:
            return NativeLogLevel::kDebug;
        case SKWLogLevelTrace:
            return NativeLogLevel::kTrace;
        case SKWLogLevelOff:
            return NativeLogLevel::kOff;
    }
}

NativeTurnPolicy nativeTurnPolicyForTurnPolicy(SKWTurnPolicy policy) {
    switch (policy) {
        case SKWTurnPolicyEnable:
            return NativeTurnPolicy::kEnable;
        case SKWTurnPolicyDisable:
            return NativeTurnPolicy::kDisable;
        case SKWTurnPolicyTurnOnly:
            return NativeTurnPolicy::kTurnOnly;
    }
}

SKWLogLevel SKWLogLevelFromNativeLogLevel(NativeLogLevel nativeLogLevel) {
    switch (nativeLogLevel) {
        case NativeLogLevel::kError:
            return SKWLogLevelError;
        case NativeLogLevel::kWarn:
            return SKWLogLevelWarn;
        case NativeLogLevel::kInfo:
            return SKWLogLevelInfo;
        case NativeLogLevel::kDebug:
            return SKWLogLevelDebug;
        case NativeLogLevel::kTrace:
            return SKWLogLevelTrace;
        case NativeLogLevel::kOff:
            return SKWLogLevelOff;
    }
}

SKWSide SKWSideFromNativeSide(NativeSide nativeSide) {
    switch (nativeSide) {
        case skyway::model::Side::kLocal:
            return SKWSideLocal;
        case skyway::model::Side::kRemote:
            return SKWSideRemote;
    }
}

SKWMemberType SKWMemberTypeFromNativeType(NativeMemberType nativeType) {
    switch (nativeType) {
        case skyway::model::MemberType::kPerson:
            return SKWMemberTypePerson;
        case skyway::model::MemberType::kBot:
            return SKWMemberTypeBot;
    }
}

SKWContentType SKWContentTypeFromNativeContentType(NativeContentType nativeType) {
    switch (nativeType) {
        case skyway::model::ContentType::kAudio:
            return SKWContentTypeAudio;
        case skyway::model::ContentType::kVideo:
            return SKWContentTypeVideo;
        case skyway::model::ContentType::kData:
            return SKWContentTypeData;
    }
}

SKWConnectionState SKWConvertConnectionState(skyway::core::ConnectionState state) {
    switch (state) {
        case skyway::core::ConnectionState::kNew:
            return SKWNew;
        case skyway::core::ConnectionState::kConnecting:
            return SKWConnecting;
        case skyway::core::ConnectionState::kConnected:
            return SKWConnected;
        case skyway::core::ConnectionState::kReconnecting:
            return SKWReconnecting;
        case skyway::core::ConnectionState::kDisconnected:
            return SKWDisconnected;
    }
}
