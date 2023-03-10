//
//  Type+Internal.h
//  SkyWay
//
//  Created by sandabu on 2022/04/05.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef Type_Internal_h
#define Type_Internal_h

#import "Type.h"

#import <skyway/model/domain.hpp>
#import <skyway/core/context_options.hpp>
#import <skyway/global/interface/logger.hpp>

using NativeLogLevel = skyway::global::interface::Logger::Level;
using NativeSide = skyway::model::Side;
using NativeMemberType = skyway::model::MemberType;
using NativeContentType = skyway::model::ContentType;

using NativeTurnPolicy = skyway::core::TurnPolicy;

NativeLogLevel nativeLogLevelForLogLevel(SKWLogLevel level);
NativeTurnPolicy nativeTurnPolicyForTurnPolicy(SKWTurnPolicy policy);

SKWSide SKWSideFromNativeSide(NativeSide nativeSide);
SKWMemberType SKWMemberTypeFromNativeType(NativeMemberType nativeType);
SKWContentType SKWContentTypeFromNativeContentType(NativeContentType nativeType);


#endif /* Type_Internal_h */
