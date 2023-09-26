//
//  SKWErrorFactory+SFUBot.h
//  SkyWay
//
//  Created by Naoto Takahashi on 2023/01/25.
//  Copyright © 2023 NTT Communications. All rights reserved.
//

#ifndef SKWErrorFactory_SFUBot_h
#define SKWErrorFactory_SFUBot_h

#import <SkyWayCore/SkyWayCore.h>

typedef NS_ENUM(NSUInteger, SKWSFUBotErrorCode) {
    SKWSFUBotPluginCreateBotError             = 300,
    SKWSFUBotSFUBotMemberStartForwardingError = 301,
};

@interface SKWErrorFactory (SFUBot)

+ (NSError* _Nonnull)pluginCreateBotError;
+ (NSError* _Nonnull)sfuBotMemberStartForwardingError;

@end

#endif /* SKWErrorFactory_SFUBot_h */
