//
//  SKWSubscriptionOptions+Internal.h
//  SkyWay
//
//  Created by Naoto Takahashi on 2022/09/01.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWSubscriptionOptions_Internal_h
#define SKWSubscriptionOptions_Internal_h

#import "SKWSubscriptionOptions.h"

#import <skyway/core/channel/member/local_person.hpp>

using NativeSubscriptionOptions = skyway::core::channel::member::LocalPerson::SubscriptionOptions;

@interface SKWSubscriptionOptions()

-(NativeSubscriptionOptions)nativeSubscriptionOptions;

@end

#endif /* SKWSubscriptionOptions_Internal_h */
