//
//  SKWPlugin+Internal.h
//  SkyWay
//
//  Created by sandabu on 2022/03/30.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWPlugin_Internal_h
#define SKWPlugin_Internal_h

#import "SKWPlugin.h"
#import "ChannelStateRepository.h"
#import <skyway/core/interface/remote_member_plugin.hpp>

using NativePlugin = skyway::core::interface::RemoteMemberPlugin;
using NativeRemoteMember = skyway::core::interface::RemoteMember;

@interface SKWPlugin(){
    // Ownership will be transferred to conotext
    std::unique_ptr<NativePlugin> _uniqueNative;
}

// Raw pointer is valid until context.dispose is called
@property(nonatomic, readonly) NativePlugin* _Nonnull native;

-(id _Nonnull)initWithUniqueNative:(std::unique_ptr<NativePlugin>)uniqueNative;
-(std::unique_ptr<NativePlugin>)uniqueNative;

// Must implement
-(SKWRemoteMember* _Nullable)createRemoteMemberWithNative:(NativeRemoteMember* _Nonnull)native
                                              repository:(ChannelStateRepository* _Nonnull)repository;

@end

#endif /* SKWPlugin_Internal_h */
