//
//  SKWStream+Internal.h
//  SkyWay
//
//  Created by sandabu on 2022/03/23.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWStream_Internal_h
#define SKWStream_Internal_h

#import "SKWStream.h"

#import <skyway/core/interface/stream.hpp>

using NativeStream = skyway::core::interface::Stream;

@interface SKWStream()

@property(nonatomic, readonly) std::shared_ptr<NativeStream>native;

-(id _Nonnull)initWithSharedNative:(std::shared_ptr<NativeStream>)native;

@end

#endif /* SKWStream_Internal_h */
