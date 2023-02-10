//
//  SKWSFUBotMember.mm
//  SkyWay
//
//  Created by sandabu on 2022/03/24.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#import <SkyWayCore/SkyWayCore.h>

#import "SKWSFUBotMember.h"
#import "SKWSFUBotMember+Internal.h"
#import "SKWMember+Internal.h"
#import "SKWPublication+Internal.h"
#import "SKWForwarding+Internal.h"
#import "SKWErrorFactory+SFUBot.h"

#import "NSString+StdString.h"

using NativeForwardingConfigure = skyway::plugin::sfu_bot::ForwardingConfigure;

class SFUBotEventListener: public NativeSFUBot::EventListener {
public:
    SFUBotEventListener(SKWSFUBotMember* bot)
        : bot_(bot), group_(bot.repository.eventGroup) {}
    // MARK: - Member::EventListener
    void OnLeft() override {
        if([bot_.delegate respondsToSelector:@selector(memberDidLeave:)]) {
            dispatch_group_async(group_, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [bot_.delegate memberDidLeave:bot_];
            });
        }
    }
    void OnMetadataUpdated(const std::string& nativeMetadata) override {
        NSString* metadata = [NSString stringForStdString:nativeMetadata];
        if([bot_.delegate respondsToSelector:@selector(member:didUpdateMetadata:)]) {
            dispatch_group_async(group_, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [bot_.delegate member:bot_ didUpdateMetadata:metadata];
            });
        }
    }
    void OnPublicationListChanged() override {
        if([bot_.delegate respondsToSelector:@selector(memberPublicationListDidChange:)]) {
            dispatch_group_async(group_, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [bot_.delegate memberPublicationListDidChange:bot_];
            });
        }
    }
    
    void OnSubscriptionListChanged() override {
        if([bot_.delegate respondsToSelector:@selector(memberSubscriptionListDidChange:)]) {
            dispatch_group_async(group_, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [bot_.delegate memberSubscriptionListDidChange:bot_];
            });
        }
    }
private:
    SKWSFUBotMember* bot_;
    dispatch_group_t group_;
};

@interface SKWSFUBotMember(){
    std::unique_ptr<SFUBotEventListener> listener;
}
@end

@implementation SKWSFUBotMember

-(id _Nonnull)initWithNativeSFUBot:(NativeSFUBot* _Nonnull)native repository:(ChannelStateRepository* _Nonnull)repository{
    if(self = [super initWithNative:native repository:repository]) {
        listener = std::make_unique<SFUBotEventListener>(self);
        native->AddEventListener(listener.get());
    }
    return self;
}


-(void)startForwardingPublication:(SKWPublication* _Nonnull)publication withConfigure:(SKWForwardingConfigure* _Nullable)configure completion:(SKWSFUBotMemberStartForwardingPublicationCompletion _Nullable)completion {
    auto nativeBot = (NativeSFUBot*)self.native;
    NativeForwardingConfigure nativeConfigure;
    if(configure && configure.maxSubscribers) {
        nativeConfigure.max_subscribers = configure.maxSubscribers;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        auto nativeForwarding = nativeBot->StartForwarding(publication.native, nativeConfigure);
        if(completion) {
            if(nativeForwarding) {
                completion([[SKWForwarding alloc] initWithNative:nativeForwarding repository:self.repository], nil);
            }else {
                completion(nil, [SKWErrorFactory sfuBotMemberStartForwardingError]);
            }
        }
    });
}

@end
