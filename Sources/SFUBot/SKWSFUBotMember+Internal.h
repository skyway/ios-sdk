//
//  SKWSFUBotMember+Internal.h
//  SkyWay
//
//  Created by sandabu on 2022/04/07.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWSFUBotMember_Internal_h
#define SKWSFUBotMember_Internal_h

#import "ChannelStateRepository.h"
#import "SKWSFUBotMember.h"

#import <skyway/plugin/sfu_bot_plugin/sfu_bot.hpp>

@interface SKWSFUBotMember ()

- (id _Nonnull)initWithNativeSFUBot:(std::shared_ptr<skyway::plugin::sfu_bot::SfuBot>)native
                         repository:(ChannelStateRepository* _Nonnull)repository;
;

@end

#endif /* SKWSFUBotMember_Internal_h */
