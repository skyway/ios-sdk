//
//  SKWForwarding+Internal.h
//  SkyWay
//
//  Created by sandabu on 2022/03/30.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWForwarding_Internal_h
#define SKWForwarding_Internal_h

#import "ChannelStateRepository.h"
#import "SKWForwarding.h"

#import <skyway/plugin/sfu_bot_plugin/forwarding.hpp>

using NativeForwarding = skyway::plugin::sfu_bot::Forwarding;

@interface SKWForwarding ()

@property(nonatomic, readonly) NativeForwarding* _Nonnull native;
@property(nonatomic, readonly, weak) ChannelStateRepository* _Nullable repository;

- (id _Nonnull)initWithNative:(NativeForwarding* _Nonnull)native
                   repository:(ChannelStateRepository* _Nonnull)repository;
- (void)dispose;

@end

#endif /* SKWForwarding_Internal_h */
