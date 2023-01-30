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
        case SKWLogLevelError: return NativeLogLevel::kError;
        case SKWLogLevelWarn: return NativeLogLevel::kWarn;
        case SKWLogLevelInfo: return NativeLogLevel::kInfo;
        case SKWLogLevelDebug: return NativeLogLevel::kDebug;
        case SKWLogLevelTrace: return NativeLogLevel::kTrace;
        case SKWLogLevelOff: return NativeLogLevel::kOff;
    }
}

NativeTurnPolicy nativeTurnPolicyForTurnPolicy(SKWTurnPolicy policy) {
    switch(policy){
        case SKWTurnPolicyEnable: return NativeTurnPolicy::kEnable;
        case SKWTurnPolicyDisable: return NativeTurnPolicy::kDisable;
        case SKWTurnPolicyTurnOnly: return NativeTurnPolicy::kTurnOnly;
    }
}

SKWSide SKWSideFromNativeSide(NativeSide nativeSide){
    switch (nativeSide) {
        case skyway::model::Side::kLocal: return SKWSideLocal;
        case skyway::model::Side::kRemote: return SKWSideRemote;
    }
}

SKWMemberType SKWMemberTypeFromNativeType(NativeMemberType nativeType) {
    switch (nativeType) {
        case skyway::model::MemberType::kPerson: return SKWMemberTypePerson;
        case skyway::model::MemberType::kBot: return SKWMemberTypeBot;
    }
}

SKWContentType SKWContentTypeFromNativeContentType(NativeContentType nativeType){
    switch(nativeType){
        case skyway::model::ContentType::kAudio: return SKWContentTypeAudio;
        case skyway::model::ContentType::kVideo: return SKWContentTypeVideo;
        case skyway::model::ContentType::kData: return SKWContentTypeData;
    }
}
