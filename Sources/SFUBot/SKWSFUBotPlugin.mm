//
//  SKWSFUBotPlugin.mm
//  SkyWay
//
//  Created by sandabu on 2022/03/30.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#import "SKWSFUBotPlugin.h"
#import "NSString+StdString.h"
#import "RTCPeerConnectionFactory+Private.h"
#import "SKWChannel+Internal.h"
#import "SKWContext+Internal.h"
#import "SKWErrorFactory+SFUBot.h"
#import "SKWPlugin+Internal.h"
#import "SKWSFUBotMember+Internal.h"

#import <skyway/plugin/sfu_bot_plugin/plugin.hpp>
#import <skyway/plugin/sfu_bot_plugin/sfu_options.hpp>

using NativeSfuPlugin = skyway::plugin::sfu_bot::Plugin;

@implementation SKWSFUBotPluginOptions

- (id)init {
    if (self = [super init]) {
        _domain  = nil;
        _version = 0;
        _secure  = true;
    }

    return self;
}

@end

@implementation SKWSFUBotPlugin

- (id _Nonnull)initWithOptions:(SKWSFUBotPluginOptions* _Nullable)options {
    skyway::plugin::sfu_options::SfuOptionsParams native_options;
    if (options != nil) {
        if (options.domain != nil) {
            native_options.domain = [NSString stdStringForString:options.domain];
        }
        if (options.version != 0) {
            native_options.version = options.version;
        }
        native_options.secure = options.secure;
    }
    auto nativePeerConnectionFactory = SKWContext.pcFactory.nativeFactory;

    return [super initWithUniqueNative:std::make_unique<NativeSfuPlugin>(
                                           skyway::network::interface::HttpClient::Shared(),
                                           nativePeerConnectionFactory,
                                           native_options)];
}

- (void)createBotOnChannel:(SKWChannel* _Nonnull)channel
                completion:(SKWSFUBotPluginCreateBotOnChannelCompletion _Nullable)completion {
    auto nativePlugin  = (NativeSfuPlugin*)self.native;
    auto nativeChannel = channel.native;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      auto nativeBot = nativePlugin->CreateBot(nativeChannel);
      if (completion) {
          if (nativeBot) {
              id bot = [channel.repository registerMemberIfNeeded:nativeBot];
              completion((SKWSFUBotMember*)bot, nil);
          } else {
              completion(nil, [SKWErrorFactory pluginCreateBotError]);
          }
      }
    });
}

// MARK: - SKWPlugin

- (SKWRemoteMember* _Nullable)
    createRemoteMemberWithNative:(std::shared_ptr<skyway::core::interface::RemoteMember>)native
                      repository:(ChannelStateRepository* _Nonnull)repository {
    if (auto nativeBot = std::dynamic_pointer_cast<skyway::plugin::sfu_bot::SfuBot>(native)) {
        return [[SKWSFUBotMember alloc] initWithNativeSFUBot:nativeBot repository:repository];
    }
    return nil;
}

@end
