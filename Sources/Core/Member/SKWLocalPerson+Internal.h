//
//  SKWLocalPerson+Internal.h
//  SkyWay
//
//  Created by sandabu on 2022/04/07.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWLocalPerson_Internal_h
#define SKWLocalPerson_Internal_h

#import "ChannelStateRepository.h"
#import "SKWLocalPerson.h"

#import <skyway/core/channel/member/local_person.hpp>

@interface SKWLocalPerson ()

- (id _Nonnull)initWithNativePerson:
                   (std::shared_ptr<skyway::core::channel::member::LocalPerson>)native
                         repository:(ChannelStateRepository* _Nonnull)repository;

@end

#endif /* SKWLocalPerson_Internal_h */
