//
//  SKWMember+Internal.h
//  SkyWay
//
//  Created by sandabu on 2022/03/23.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWMember_Internal_h
#define SKWMember_Internal_h

#import "SKWMember.h"

#import "ChannelStateRepository.h"

#import <skyway/core/interface/member.hpp>

using NativeMember = skyway::core::interface::Member;

@class ChannelStateRepository;

@interface SKWMember()

@property(nonatomic, readonly) NativeMember* _Nonnull native;
@property(nonatomic, readonly, weak) ChannelStateRepository* _Nullable repository;

-(id _Nonnull)initWithNative:(NativeMember* _Nonnull)native repository:(ChannelStateRepository* _Nonnull)repository;


-(void)dispose;

@end




#endif /* SKWMember_Internal_h */
