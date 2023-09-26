//
//  SKWPublication+Internal.h
//  SkyWay
//
//  Created by sandabu on 2022/03/30.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWPublication_Internal_h
#define SKWPublication_Internal_h

#import "SKWPublication.h"

#import "ChannelStateRepository.h"

#import <skyway/core/interface/publication.hpp>

using NativePublication = skyway::core::interface::Publication;

@interface SKWPublication ()

@property(nonatomic, readonly) NativePublication* _Nonnull native;
@property(nonatomic, readonly, weak) ChannelStateRepository* _Nullable repository;

- (id _Nonnull)initWithNative:(NativePublication* _Nonnull)native
                   repository:(ChannelStateRepository* _Nonnull)repository;

- (void)setStream:(SKWLocalStream* _Nonnull)stream;
- (void)dispose;

@end

#endif /* SKWPublication_Internal_h */
