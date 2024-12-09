//
//  SKWChannel+Internal.h
//  SkyWay
//
//  Created by sandabu on 2022/03/30.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWChannel_Internal_h
#define SKWChannel_Internal_h

#import "SKWChannel.h"

#import "ChannelStateRepository.h"

#import <skyway/core/channel/channel.hpp>

using NativeChannel = skyway::core::channel::Channel;

@interface SKWChannel ()

@property(nonatomic, readonly) ChannelStateRepository* _Nonnull repository;
@property(nonatomic, readonly) std::shared_ptr<NativeChannel> native;

- (id _Nonnull)initWithSharedNative:(std::shared_ptr<NativeChannel>)native;

@end

#endif /* SKWChannel_Internal_h */
