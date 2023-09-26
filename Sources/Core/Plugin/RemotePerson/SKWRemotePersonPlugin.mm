//
//  SKWRemotePersonPlugin.mm
//  SkyWayCore
//
//  Created by Naoto Takahashi on 2023/01/10.
//  Copyright © 2023 NTT Communications. All rights reserved.
//

#import "SKWRemotePersonPlugin+Internal.h"

#import "RTCPeerConnectionFactory+Private.h"
#import "SKWContext+Internal.h"
#import "SKWPlugin+Internal.h"
#import "SKWRemotePerson+Internal.h"

#import <skyway/plugin/remote_person_plugin/plugin.hpp>
#import <skyway/plugin/remote_person_plugin/remote_person.hpp>

using NativeRemotePersonPlugin = skyway::plugin::remote_person::Plugin;
using NativeRemotePerson       = skyway::plugin::remote_person::RemotePerson;

@implementation SKWRemotePersonPlugin

- (id _Nonnull)initWithVoid {
    auto nativeFactory = SKWContext.pcFactory.nativeFactory;
    return [super initWithUniqueNative:std::make_unique<NativeRemotePersonPlugin>(nativeFactory)];
}

- (SKWRemoteMember* _Nullable)createRemoteMemberWithNative:(NativeRemoteMember* _Nonnull)native
                                                repository:
                                                    (ChannelStateRepository* _Nonnull)repository {
    if (auto nativeRemotePerson = dynamic_cast<NativeRemotePerson*>(native)) {
        return [[SKWRemotePerson alloc] initWithNativePerson:nativeRemotePerson
                                                  repository:repository];
    }
    return nil;
}

@end
