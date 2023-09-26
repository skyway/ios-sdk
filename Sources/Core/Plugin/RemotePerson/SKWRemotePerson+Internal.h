//
//  SKWRemotePerson+Internal.h
//  SkyWay
//
//  Created by sandabu on 2022/04/07.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWRemotePerson_Internal_h
#define SKWRemotePerson_Internal_h

#import "ChannelStateRepository.h"
#import "SKWRemotePerson.h"

#import <skyway/plugin/remote_person_plugin/remote_person.hpp>

using NativeRemotePerson = skyway::plugin::remote_person::RemotePerson;

@interface SKWRemotePerson ()
- (id _Nonnull)initWithNativePerson:(NativeRemotePerson* _Nonnull)native
                         repository:(ChannelStateRepository* _Nonnull)repository;
@end

#endif /* SKWRemotePerson_Internal_h */
