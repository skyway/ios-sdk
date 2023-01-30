//
//  SKWErrorFactory+SFUBot.mm
//  SkyWayRoom
//
//  Created by Naoto Takahashi on 2023/01/25.
//  Copyright © 2023 NTT Communications. All rights reserved.
//

#import "SKWErrorFactory+SFUBot.h"

@implementation SKWErrorFactory(SFUBot)
+(NSError* _Nonnull)pluginCreateBotError {
    return [[NSError alloc] initWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:SKWSFUBotPluginCreateBotError userInfo:nil];
}

+(NSError* _Nonnull)sfuBotMemberStartForwardingError {
    return [[NSError alloc] initWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:SKWSFUBotSFUBotMemberStartForwardingError userInfo:nil];
}

@end
