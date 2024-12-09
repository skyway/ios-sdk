//
//  SKWSFUBotMember.mm
//  SkyWay
//
//  Created by sandabu on 2022/03/24.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#import <SkyWayCore/SkyWayCore.h>

#import "SKWErrorFactory+SFUBot.h"
#import "SKWForwarding+Internal.h"
#import "SKWMember+Internal.h"
#import "SKWPublication+Internal.h"
#import "SKWSFUBotMember+Internal.h"
#import "SKWSFUBotMember.h"

#import "NSString+StdString.h"
#import "skyway/global/util.hpp"

using NativeForwardingConfigure = skyway::plugin::sfu_bot::ForwardingConfigure;

class SFUBotEventListener : public skyway::plugin::sfu_bot::SfuBot::EventListener {
public:
    SFUBotEventListener(SKWSFUBotMember* bot) : bot_(bot), group_(bot.repository.eventGroup) {}
    // MARK: - Member::EventListener
    void OnLeft() override {
        if ([bot_.delegate respondsToSelector:@selector(memberDidLeave:)]) {
            dispatch_group_async(
                group_, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                  [bot_.delegate memberDidLeave:bot_];
                });
        }
    }
    void OnMetadataUpdated(const std::string& nativeMetadata) override {
        NSString* metadata = [NSString stringForStdString:nativeMetadata];
        if ([bot_.delegate respondsToSelector:@selector(member:didUpdateMetadata:)]) {
            dispatch_group_async(
                group_, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                  [bot_.delegate member:bot_ didUpdateMetadata:metadata];
                });
        }
    }
    void OnPublicationListChanged() override {
        if ([bot_.delegate respondsToSelector:@selector(memberPublicationListDidChange:)]) {
            dispatch_group_async(
                group_, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                  [bot_.delegate memberPublicationListDidChange:bot_];
                });
        }
    }

    void OnSubscriptionListChanged() override {
        if ([bot_.delegate respondsToSelector:@selector(memberSubscriptionListDidChange:)]) {
            dispatch_group_async(
                group_, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                  [bot_.delegate memberSubscriptionListDidChange:bot_];
                });
        }
    }

private:
    __weak SKWSFUBotMember* bot_;
    dispatch_group_t group_;
};

@interface SKWSFUBotMember () {
    std::unique_ptr<SFUBotEventListener> listener;
    NSMutableArray<SKWForwarding*>* mutableForwardings;
}
@end

@implementation SKWSFUBotMember

- (id _Nonnull)initWithNativeSFUBot:(std::shared_ptr<skyway::plugin::sfu_bot::SfuBot>)native
                         repository:(ChannelStateRepository* _Nonnull)repository {
    if (self = [super initWithNative:native repository:repository]) {
        listener           = std::make_unique<SFUBotEventListener>(self);
        mutableForwardings = [[NSMutableArray alloc] init];
        native->AddEventListener(listener.get());
    }
    return self;
}

- (void)dealloc {
    SKW_TRACE("~SKWSFUBotMember");
}

- (NSArray<SKWForwarding*>* _Nonnull)forwardings {
    @synchronized(mutableForwardings) {
        NSMutableArray<SKWForwarding*>* forwardings = [[NSMutableArray alloc] init];
        [mutableForwardings enumerateObjectsUsingBlock:^(
                                SKWForwarding* _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
          if (obj.state != SKWForwardingStateStopped) {
              [forwardings addObject:obj];
          }
        }];
        return [forwardings copy];
    }
}

- (void)startForwardingPublication:(SKWPublication* _Nonnull)publication
                     withConfigure:(SKWForwardingConfigure* _Nullable)configure
                        completion:(SKWSFUBotMemberStartForwardingPublicationCompletion _Nullable)
                                       completion {
    auto nativeBot = std::dynamic_pointer_cast<skyway::plugin::sfu_bot::SfuBot>(self.native);
    NativeForwardingConfigure nativeConfigure;
    if (configure) {
        nativeConfigure.max_subscribers = configure.maxSubscribers;
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      auto nativeForwarding = nativeBot->StartForwarding(publication.native, nativeConfigure);
      if (completion) {
          if (nativeForwarding) {
              // Wait for updating on repository
              auto res = skyway::global::util::SpinLockWithTimeout([=] {
                  return [self.repository
                             findPublicationByPublicationID:nativeForwarding->RelayingPublication()
                                                                ->Id()] != nil;
              });
              if (res) {
                  SKWForwarding* forwarding =
                      [[SKWForwarding alloc] initWithNative:nativeForwarding
                                                 repository:self.repository];
                  [self->mutableForwardings addObject:forwarding];
                  completion(forwarding, nil);
              } else {
                  completion(nil, [SKWErrorFactory sfuBotMemberStartForwardingError]);
              }
          } else {
              completion(nil, [SKWErrorFactory sfuBotMemberStartForwardingError]);
          }
      }
    });
}

- (void)dispose {
    self.native->RemoveEventListener(listener.get());
    [mutableForwardings enumerateObjectsUsingBlock:^(
                            SKWForwarding* _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
      [obj dispose];
    }];
}

@end
