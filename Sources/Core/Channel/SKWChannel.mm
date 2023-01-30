//
//  SKWChannel.mm
//  SkyWay
//
//  Created by sandabu on 2022/02/04.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#import "SKWChannel.h"
#import "SKWChannel+Internal.h"
#import "NSString+StdString.h"
#import "SKWMember+Internal.h"
#import "SKWLocalPerson+Internal.h"
#import "SKWPublication+Internal.h"
#import "SKWSubscription+Internal.h"
#import "SKWErrorFactory.h"

#import "NSString+StdString.h"

using NativeChannelInit = skyway::model::Channel::Init;
using NativeMemberInit = skyway::model::Member::Init;
using NativeChannelQuery = skyway::model::Channel::Query;
using NativeChannelEventListener = skyway::core::interface::Channel::EventListener;

using NativeMemberInterface = skyway::core::interface::Member;
using NativeRemoteMemberInterface = skyway::core::interface::RemoteMember;
using NativePublicationInterface = skyway::core::interface::Publication;
using NativeSubscriptionInterface = skyway::core::interface::Subscription;

class ChannelEventListener: public NativeChannelEventListener {
public:
    ChannelEventListener(SKWChannel* channel)
        : channel_(channel) {}
    void OnClosed() override {
        if([channel_.delegate respondsToSelector:@selector(channelDidClose:)]) {
            [channel_.delegate channelDidClose:channel_];
        }
    }
    void OnMetadataUpdated(const std::string& nativeMetadata) override {
        if([channel_.delegate respondsToSelector:@selector(channel:didUpdateMetadata:)]) {
            NSString* metadata = [NSString stringForStdString:nativeMetadata];
            [channel_.delegate channel:channel_ didUpdateMetadata:metadata];
        }
    }
    void OnMemberListChanged() override {
        if([channel_.delegate respondsToSelector:@selector(channelMemberListDidChange:)]) {
            [channel_.delegate channelMemberListDidChange:channel_];
        }
    }

    void OnMemberJoined(NativeMemberInterface* nativeMember) override {
        id member = [channel_.repository registerMemberIfNeeded:nativeMember];
        if([channel_.delegate respondsToSelector:@selector(channel:memberDidJoin:)]) {
            [channel_.delegate channel:channel_ memberDidJoin:member];
        }
    }
    void OnMemberLeft(NativeMemberInterface* nativeMember) override {
        id member = [channel_.repository findMemberByMemberID:nativeMember->Id()];
        if([channel_.delegate respondsToSelector:@selector(channel:memberDidLeave:)]) {
            [channel_.delegate channel:channel_ memberDidLeave:member];
        }
    }
    void OnMemberMetadataUpdated(NativeMemberInterface* nativeMember, const std::string& nativeMetadata) override {
        if([channel_.delegate respondsToSelector:@selector(channel:member:metadataDidUpdate:)]) {
            NSString* metadata = [NSString stringForStdString:nativeMetadata];
            id member = [channel_.repository findMemberByMemberID:nativeMember->Id()];
            [channel_.delegate channel:channel_ member:member metadataDidUpdate:metadata];
        }
    }
    
    void OnPublicationListChanged() override {
        if([channel_.delegate respondsToSelector:@selector(channelPublicationListDidChange:)]) {
            [channel_.delegate channelPublicationListDidChange:channel_];
        }
    }

    void OnStreamPublished(NativePublicationInterface* nativePublication) override {
        id publication = [channel_.repository registerPublicationIfNeeded:nativePublication];
        if([channel_.delegate respondsToSelector:@selector(channel:didPublishStreamOfPublication:)]) {
            [channel_.delegate channel:channel_ didPublishStreamOfPublication:publication];
        }
    }
    void OnStreamUnpublished(NativePublicationInterface* nativePublication) override {
        id publication = [channel_.repository findPublicationByPublicationID:nativePublication->Id()];
        if([channel_.delegate respondsToSelector:@selector(channel:didUnpublishStreamOfPublication:)]) {
            [channel_.delegate channel:channel_ didUnpublishStreamOfPublication:publication];
        }
    }
    
    void OnPublicationEnabled(NativePublicationInterface* nativePublication) override {
        if([channel_.delegate respondsToSelector:@selector(channel:publicationDidChangeToEnabled:)]) {
            id publication = [channel_.repository findPublicationByPublicationID:nativePublication->Id()];
            [channel_.delegate channel:channel_ publicationDidChangeToEnabled:publication];
        }
    }
    
    void OnPublicationDisabled(NativePublicationInterface* nativePublication) override {
        if([channel_.delegate respondsToSelector:@selector(channel:publicationDidChangeToDisabled:)]) {
            id publication = [channel_.repository findPublicationByPublicationID:nativePublication->Id()];
            [channel_.delegate channel:channel_ publicationDidChangeToDisabled:publication];
        }
    }
    
    void OnPublicationMetadataUpdated(NativePublicationInterface* nativePublication,const std::string& nativeMetadata) override {
        if([channel_.delegate respondsToSelector:@selector(channel:publication:metadataDidUpdate:)]) {
            NSString* metadata = [NSString stringForStdString:nativeMetadata];
            id publication = [channel_.repository findPublicationByPublicationID:nativePublication->Id()];
            [channel_.delegate channel:channel_ publication:publication metadataDidUpdate:metadata];
        }
    }
    
    void OnSubscriptionListChanged() override {
        if([channel_.delegate respondsToSelector:@selector(channelSubscriptionListDidChange:)]) {
            [channel_.delegate channelSubscriptionListDidChange:channel_];
        }
    }
    
    void OnPublicationSubscribed(NativeSubscriptionInterface* nativeSubscription) override {
        id subscription = [channel_.repository registerSubscriptionIfNeeded:nativeSubscription];
        if([channel_.delegate respondsToSelector:@selector(channel:didSubscribePublicationOfSubscription:)]) {
            [channel_.delegate channel:channel_ didSubscribePublicationOfSubscription:subscription];
        }
    }
    void OnPublicationUnsubscribed(NativeSubscriptionInterface* nativeSubscription) override {
        id subscription = [channel_.repository findSubscriptionBySubscriptionID:nativeSubscription->Id()];
        if([channel_.delegate respondsToSelector:@selector(channel:didUnsubscribePublicationOfSubscription:)]) {
            [channel_.delegate channel:channel_ didUnsubscribePublicationOfSubscription:subscription];
        }
    }
private:
    SKWChannel* channel_;
};


@implementation SKWChannelInit
@end

@implementation SKWChannelQuery
@end

@implementation SKWMemberInit
@end


@interface SKWChannel() {
    std::unique_ptr<ChannelEventListener> listener;
}
@end

@implementation SKWChannel

-(id _Nonnull)initWithSharedNative:(std::shared_ptr<NativeChannel>)native {
    if(self = [super init]) {
        _native = native;
        _repository = [[ChannelStateRepository alloc] initWithNative:native.get()];
        self->listener = std::make_unique<ChannelEventListener>(self);
        _native->AddEventListener(self->listener.get());
        
    }
    return self;
}

-(NSString* _Nonnull)id {
    auto nativeId = _native->Id();
    return [NSString stringForStdString:nativeId];
}

-(NSString* _Nullable)name {
    auto name = _native->Name();
    if(name) {
        return [NSString stringForStdString:*name];
    }
    return nil;
}

-(NSString* _Nullable)metadata {
    auto metadata = _native->Metadata();
    if(metadata) {
        return [NSString stringForStdString:*metadata];
    }
    return nil;
}

-(SKWLocalPerson* _Nullable)localPerson {
    __block SKWLocalPerson* person = nil;
    [_repository.members enumerateObjectsUsingBlock:^(SKWMember * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[SKWLocalPerson class]]) {
            person = (SKWLocalPerson*)obj;
            return;
        }
    }];
    return person;
}

-(NSArray<SKWRemoteMember*>* _Nonnull)bots {
    NSMutableArray<SKWRemoteMember*>* bots = [[NSMutableArray alloc] init];
    [_repository.members enumerateObjectsUsingBlock:^(SKWMember * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.type == SKWMemberTypeBot) {
            [bots addObject:(SKWRemoteMember*)obj];
        }
    }];
    return [bots copy];
}

-(NSArray<SKWMember*>* _Nonnull)members {
    return _repository.members;
}

-(NSArray<SKWPublication*>* _Nonnull)publications {
    return _repository.publications;
}

-(NSArray<SKWSubscription*>* _Nonnull)subscriptions {
    return _repository.subscriptions;
}

-(SKWChannelState)State {
    switch (_native->State()) {
        case skyway::core::interface::ChannelState::kOpened:
            return SKWChannelState::Opened;
        case skyway::core::interface::ChannelState::kClosed:
            return SKWChannelState::Closed;
    }
}

+(void)findWithQuery:(SKWChannelQuery* _Nonnull)query completion:(SKWChannelCompletion _Nullable)completion{
    NativeChannelQuery nativeQuery;
    if(query.name != nil) {
        nativeQuery.name = [NSString stdStringForString:query.name];
    }
    if(query.id != nil) {
        nativeQuery.id = [NSString stdStringForString:query.id];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        auto nativeChannel = NativeChannel::Find(nativeQuery);
        if(completion) {
            if(nativeChannel) {
                completion([[SKWChannel alloc] initWithSharedNative:nativeChannel], nil);
            }else {
                completion(nil, [SKWErrorFactory channelFindError]);
            }
        }
    });

}

+(void)createWithInit:(SKWChannelInit* _Nullable)init completion:(SKWChannelCompletion _Nullable)completion{
    NativeChannelInit nativeInit;
    if(init != nil) {
        if(init.name != nil) {
            nativeInit.name = [NSString stdStringForString:init.name];
        }
        if(init.metadata != nil) {
            nativeInit.metadata = [NSString stdStringForString:init.metadata];
        }
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        auto nativeChannel = NativeChannel::Create(nativeInit);
        if(completion) {
            if(nativeChannel) {
                completion([[SKWChannel alloc] initWithSharedNative:nativeChannel], nil);
            }else {
                completion(nil, [SKWErrorFactory channelCreateError]);
            }
        }
    });
    

}

+(void)findOrCreateWithInit:(SKWChannelInit* _Nonnull)init completion:(SKWChannelCompletion _Nullable)completion {
    NativeChannelInit nativeInit;
    if(init.name != nil) {
        nativeInit.name = [NSString stdStringForString:init.name];
    }
    if(init.metadata != nil) {
        nativeInit.metadata = [NSString stdStringForString:init.metadata];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        auto nativeChannel = NativeChannel::FindOrCreate(nativeInit);
        if(completion) {
            if(nativeChannel) {
                completion([[SKWChannel alloc] initWithSharedNative:nativeChannel], nil);
            }else {
                completion(nil, [SKWErrorFactory channelFindOrCreateError]);
            }
        }
    });
}

-(void)joinWithInit:(SKWMemberInit*)init completion:(SKWChannelJoinCompletion _Nullable)completion{
    NativeMemberInit nativeInit;
    if(init != nil) {
        if(init.name != nil) {
            nativeInit.name = [NSString stdStringForString:init.name];
        }
        if(init.metadata != nil) {
            nativeInit.metadata = [NSString stdStringForString:init.metadata];
        }
        if(init.keepaliveIntervalSec != 0) {
            nativeInit.keepalive_interval_sec = init.keepaliveIntervalSec;
        }
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        auto nativePerson = self.native->Join(nativeInit);
        if(completion) {
            if(nativePerson) {
                id person = (SKWLocalPerson*)[self.repository registerMemberIfNeeded:nativePerson];
                completion(person, nil);
            }else {
                completion(nil, [SKWErrorFactory channelJoinError]);
            }
        }
    });
}

-(void)leaveMember:(SKWMember* _Nonnull)member completion:(SKWChannelLeaveMemberCompletion _Nullable)completion{
    auto nativeMember = member.native;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        auto res = self.native->Leave(nativeMember);
        if(completion) {
            if(res) {
                completion(nil);
            }else {
                completion([SKWErrorFactory channelLeaveError]);
            }
        }
    });
}

-(void)closeWithCompletion:(SKWChannelCloseCompletion _Nullable)completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        auto res = self.native->Close();
        if(completion) {
            if(res) {
                completion(nil);
            }else {
                completion([SKWErrorFactory channelCloseError]);
            }
        }
    });
}

-(void)disposeWithCompletion:(SKWChannelDisposeCompletion _Nullable)completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.native->Dispose();
        [self.repository clear];
        if(completion) {
            completion(nil);
        }
    });
}

@end
