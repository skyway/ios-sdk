//
//  SKWSFUBotPlugin.mm
//  SkyWay
//
//  Created by sandabu on 2022/03/30.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#import "SKWSFUBotPlugin.h"
#import "SKWPlugin+Internal.h"
#import "SKWChannel+Internal.h"
#import "SKWSFUBotMember+Internal.h"
#import "SKWContext+Internal.h"
#import "NSString+StdString.h"
#import "RTCPeerConnectionFactory+Private.h"
#import "SKWErrorFactory+SFUBot.h"

#import <skyway/plugin/sfu_bot_plugin/plugin.hpp>

using NativeSfuPlugin = skyway::plugin::sfu_bot::Plugin;
using NativeSfuBot = skyway::plugin::sfu_bot::SfuBot;

@implementation SKWSFUBotPlugin

-(id _Nonnull)initWithOptions:(SKWSFUBotPluginOptions* _Nullable)options {
    boost::optional<std::string> nativeUrl = boost::none;
    if(options != nil) {
        if(options.apiUrl != nil) {
            nativeUrl = [NSString stdStringForString:options.apiUrl];
        }
    }
    auto nativePeerConnectionFactory = SKWContext.pcFactory.nativeFactory;
    
    return [super initWithUniqueNative:std::make_unique<NativeSfuPlugin>(skyway::network::interface::HttpClient::Shared(), nativePeerConnectionFactory, nativeUrl)];
}

-(void)createBotOnChannel:(SKWChannel* _Nonnull)channel completion:(SKWSFUBotPluginCreateBotOnChannelCompletion _Nullable)completion {
    auto nativePlugin = (NativeSfuPlugin*)self.native;
    auto nativeChannel = channel.native;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        auto nativeBot = nativePlugin->CreateBot(nativeChannel.get());
        if(completion) {
            if(nativeBot) {
                id bot = [channel.repository registerMemberIfNeeded: nativeBot];
                completion((SKWSFUBotMember*)bot, nil);
            }else {
                completion(nil, [SKWErrorFactory pluginCreateBotError]);
            }
        }
    });
}

// MARK: - SKWPlugin

-(SKWRemoteMember* _Nullable)createRemoteMemberWithNative:(NativeRemoteMember* _Nonnull)native
                                              repository:(ChannelStateRepository* _Nonnull)repository{
    
    if(auto nativeBot = dynamic_cast<NativeSfuBot*>(native)) {
        return [[SKWSFUBotMember alloc] initWithNativeSFUBot:nativeBot repository:repository];
    }
    return nil;
}

@end
