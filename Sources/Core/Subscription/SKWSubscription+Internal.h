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

using NativeSubscription = skyway::core::interface::Subscription;

@interface SKWSubscription()

@property(nonatomic, readonly) NativeSubscription* _Nonnull native;
@property(nonatomic, readonly, weak) ChannelStateRepository* _Nullable repository;

-(id _Nonnull)initWithNative:(NativeSubscription* _Nonnull)native repository:(ChannelStateRepository* _Nonnull)repository;
-(void)dispose;

@end


#endif /* SKWSubscription_Internal_h */
