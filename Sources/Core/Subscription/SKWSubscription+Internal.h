//
//  SKWSubscription+Internal.h
//  SkyWay
//
//  Created by sandabu on 2022/04/05.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWSubscription_Internal_h
#define SKWSubscription_Internal_h

#import "SKWSubscription.h"

#import "ChannelStateRepository.h"

#import <skyway/core/interface/publication.hpp>

@interface SKWSubscription ()

@property(nonatomic, readonly) std::shared_ptr<skyway::core::interface::Subscription> native;
@property(nonatomic, readonly, weak) ChannelStateRepository* _Nullable repository;

- (id _Nonnull)initWithNative:(std::shared_ptr<skyway::core::interface::Subscription>)native
                   repository:(ChannelStateRepository* _Nonnull)repository;
- (void)setStreamFromNativeStream:
    (std::shared_ptr<skyway::core::interface::RemoteStream>)nativeStream;
- (void)dispose;

@end

#endif /* SKWSubscription_Internal_h */
