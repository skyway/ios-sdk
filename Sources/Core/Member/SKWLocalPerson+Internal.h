//
//  SKWLocalPerson+Internal.h
//  SkyWay
//
//  Created by sandabu on 2022/04/07.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWLocalPerson_Internal_h
#define SKWLocalPerson_Internal_h

#import "SKWLocalPerson.h"
#import "ChannelStateRepository.h"

#import <skyway/core/channel/member/local_person.hpp>

using NativeLocalPerson = skyway::core::channel::member::LocalPerson;

@interface SKWLocalPerson()

-(id _Nonnull)initWithNativePerson:(NativeLocalPerson* _Nonnull)native repository:(ChannelStateRepository* _Nonnull)repository;

@end

#endif /* SKWLocalPerson_Internal_h */
