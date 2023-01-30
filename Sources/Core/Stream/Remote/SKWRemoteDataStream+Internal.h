//
//  SKWRemoteDataStream+Internal.h
//  SkyWay
//
//  Created by sandabu on 2022/03/22.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWRemoteDataStream_Internal_h
#define SKWRemoteDataStream_Internal_h

#import "SKWRemoteDataStream.h"

#import <skyway/core/interface/stream.hpp>

#import "RTCAudioTrack+Private.h"

using NativeStream = skyway::core::interface::Stream;

@interface SKWRemoteDataStream()

-(id _Nonnull)initWithSharedNative:(std::shared_ptr<NativeStream>)native;

@end


#endif /* SKWRemoteDataStream_Internal_h */
