//
//  SKWCodec+Internal.h
//  SkyWay
//
//  Created by sandabu on 2022/04/01.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWCodec_Internal_h
#define SKWCodec_Internal_h

#import "SKWCodec.h"

#import <skyway/model/domain.hpp>

using NativeCodec = skyway::model::Codec;

@interface SKWCodecParameters ()
+ (SKWCodecParameters*)parameterForNativeParameter:(NativeCodec::Parameters)nativeParameters;
- (NativeCodec::Parameters)nativeParameter;
@end

@interface SKWCodec ()

+ (SKWCodec*)codecForNativeCodec:(NativeCodec)nativeCodec;

- (NativeCodec)nativeCodec;

@end

#endif /* SKWCodec_Internal_h */
