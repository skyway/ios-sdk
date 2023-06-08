//
//  SKWErrorFactory+SFUBot.mm
//  SkyWayRoom
//
//  Created by Naoto Takahashi on 2023/01/25.
//  Copyright © 2023 NTT Communications. All rights reserved.
//

#import "SKWErrorFactory+SFUBot.h"
// A representative class for SFUBotPlugin to get bundle identifier
#import "SKWSFUBotPlugin.h"

@implementation SKWErrorFactory(SFUBot)
+(NSError* _Nonnull)pluginCreateBotError {
    NSBundle *bundle = [NSBundle bundleForClass:SKWSFUBotPlugin.class];
    return [[NSError alloc] initWithDomain:bundle.bundleIdentifier code:SKWSFUBotPluginCreateBotError userInfo:nil];
}

+(NSError* _Nonnull)sfuBotMemberStartForwardingError {
    NSBundle *bundle = [NSBundle bundleForClass:SKWSFUBotPlugin.class];
    return [[NSError alloc] initWithDomain:bundle.bundleIdentifier code:SKWSFUBotSFUBotMemberStartForwardingError userInfo:nil];
}

@end
