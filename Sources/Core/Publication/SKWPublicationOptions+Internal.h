//
//  SKWPublicationOptions+Internal.h
//  SkyWay
//
//  Created by sandabu on 2022/04/01.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWPublicationOptions_Internal_h
#define SKWPublicationOptions_Internal_h

#import "SKWPublicationOptions.h"

#import <skyway/core/channel/member/local_person.hpp>

using NativePublicationOptions = skyway::core::channel::member::LocalPerson::PublicationOptions;

@interface SKWPublicationOptions ()

- (NativePublicationOptions)nativePublicationOptions;

@end

#endif /* SKWPublicationOptions_Internal_h */
