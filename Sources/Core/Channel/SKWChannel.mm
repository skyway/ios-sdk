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

#import "skyway/global/interface/logger.hpp"

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
    ChannelEventListener(SKWChannel* channel, dispatch_group_t group)
        : channel_(channel), group_(group) {}
    void OnClosed() override {
        __strong SKWChannel* strongChannel = channel_;
        if(!strongChannel) {
            return;
        }
        if([strongChannel.delegate respondsToSelector:@selector(channelDidClose:)]) {
            dispatch_group_async(group_, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [strongChannel.delegate channelDidClose:strongChannel];
            });
        }
    }
    void OnMetadataUpdated(const std::string& nativeMetadata) override {
        __strong SKWChannel* strongChannel = channel_;
        if(!strongChannel) {
            return;
        }
        if([strongChannel.delegate respondsToSelector:@selector(channel:didUpdateMetadata:)]) {
            NSString* metadata = [NSString stringForStdString:nativeMetadata];
            dispatch_group_async(group_, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [strongChannel.delegate channel:strongChannel didUpdateMetadata:metadata];
            });
        }
    }
    void OnMemberListChanged() override {
        __strong SKWChannel* strongChannel = channel_;
        if(!strongChannel) {
            return;
        }
        if([strongChannel.delegate respondsToSelector:@selector(channelMemberListDidChange:)]) {
            dispatch_group_async(group_, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [strongChannel.delegate channelMemberListDidChange:strongChannel];
            });
        }
    }

    void OnMemberJoined(NativeMemberInterface* nativeMember) override {
        __strong SKWChannel* strongChannel = channel_;
        if(!strongChannel) {
            return;
        }
        if(!nativeMember) {
            SKW_ERROR("Undefined Member.");
            return;
        }
        id member = [strongChannel.repository registerMemberIfNeeded:nativeMember];
        if([strongChannel.delegate respondsToSelector:@selector(channel:memberDidJoin:)]) {
            dispatch_group_async(group_, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [strongChannel.delegate channel:strongChannel memberDidJoin:member];
            });
        }
    }
    void OnMemberLeft(NativeMemberInterface* nativeMember) override {
        __strong SKWChannel* strongChannel = channel_;
        if(!strongChannel) {
            return;
        }
        id member = [strongChannel.repository findMemberByMemberID:nativeMember->Id()];
        if([strongChannel.delegate respondsToSelector:@selector(channel:memberDidLeave:)]) {
            dispatch_group_async(group_, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [strongChannel.delegate channel:strongChannel memberDidLeave:member];
            });
        }
    }
    void OnMemberMetadataUpdated(NativeMemberInterface* nativeMember, const std::string& nativeMetadata) override {
        __strong SKWChannel* strongChannel = channel_;
        if(!strongChannel) {
            return;
        }
        if([strongChannel.delegate respondsToSelector:@selector(channel:member:metadataDidUpdate:)]) {
            NSString* metadata = [NSString stringForStdString:nativeMetadata];
            id member = [strongChannel.repository findMemberByMemberID:nativeMember->Id()];
            dispatch_group_async(group_, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [strongChannel.delegate channel:strongChannel member:member metadataDidUpdate:metadata];
            });
        }
    }
    
    void OnPublicationListChanged() override {
        __strong SKWChannel* strongChannel = channel_;
        if(!strongChannel) {
            return;
        }
        if([strongChannel.delegate respondsToSelector:@selector(channelPublicationListDidChange:)]) {
            dispatch_group_async(group_, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [strongChannel.delegate channelPublicationListDidChange:strongChannel];
            });
        }
    }

    void OnStreamPublished(NativePublicationInterface* nativePublication) override {
        __strong SKWChannel* strongChannel = channel_;
        if(!strongChannel) {
            return;
        }
        id publication = [strongChannel.repository registerPublicationIfNeeded:nativePublication];
        if([strongChannel.delegate respondsToSelector:@selector(channel:didPublishStreamOfPublication:)]) {
            dispatch_group_async(group_, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [strongChannel.delegate channel:strongChannel didPublishStreamOfPublication:publication];
            });
        }
    }
    void OnStreamUnpublished(NativePublicationInterface* nativePublication) override {
        __strong SKWChannel* strongChannel = channel_;
        if(!strongChannel) {
            return;
        }
        id publication = [strongChannel.repository findPublicationByPublicationID:nativePublication->Id()];
        if([strongChannel.delegate respondsToSelector:@selector(channel:didUnpublishStreamOfPublication:)]) {
            dispatch_group_async(group_, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [strongChannel.delegate channel:strongChannel didUnpublishStreamOfPublication:publication];
            });
        }
    }
    
    void OnPublicationEnabled(NativePublicationInterface* nativePublication) override {
        __strong SKWChannel* strongChannel = channel_;
        if(!strongChannel) {
            return;
        }
        if([strongChannel.delegate respondsToSelector:@selector(channel:publicationDidChangeToEnabled:)]) {
            id publication = [strongChannel.repository findPublicationByPublicationID:nativePublication->Id()];
            dispatch_group_async(group_, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [strongChannel.delegate channel:strongChannel publicationDidChangeToEnabled:publication];
            });
        }
    }
    
    void OnPublicationDisabled(NativePublicationInterface* nativePublication) override {
        __strong SKWChannel* strongChannel = channel_;
        if(!strongChannel) {
            return;
        }
        if([strongChannel.delegate respondsToSelector:@selector(channel:publicationDidChangeToDisabled:)]) {
            id publication = [strongChannel.repository findPublicationByPublicationID:nativePublication->Id()];
            dispatch_group_async(group_, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [strongChannel.delegate channel:strongChannel publicationDidChangeToDisabled:publication];
            });
        }
    }
    
    void OnPublicationMetadataUpdated(NativePublicationInterface* nativePublication,const std::string& nativeMetadata) override {
        __strong SKWChannel* strongChannel = channel_;
        if(!strongChannel) {
            return;
        }
        if([strongChannel.delegate respondsToSelector:@selector(channel:publication:metadataDidUpdate:)]) {
            NSString* metadata = [NSString stringForStdString:nativeMetadata];
            id publication = [strongChannel.repository findPublicationByPublicationID:nativePublication->Id()];
            dispatch_group_async(group_, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [strongChannel.delegate channel:strongChannel publication:publication metadataDidUpdate:metadata];
            });
        }
    }
    
    void OnSubscriptionListChanged() override {
        __strong SKWChannel* strongChannel = channel_;
        if(!strongChannel) {
            return;
        }
        if([strongChannel.delegate respondsToSelector:@selector(channelSubscriptionListDidChange:)]) {
            dispatch_group_async(group_, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [strongChannel.delegate channelSubscriptionListDidChange:strongChannel];
            });
        }
    }
    
    void OnPublicationSubscribed(NativeSubscriptionInterface* nativeSubscription) override {
        __strong SKWChannel* strongChannel = channel_;
        if(!strongChannel) {
            return;
        }
        id subscription = [strongChannel.repository registerSubscriptionIfNeeded:nativeSubscription];
        if([strongChannel.delegate respondsToSelector:@selector(channel:didSubscribePublicationOfSubscription:)]) {
            dispatch_group_async(group_, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [strongChannel.delegate channel:strongChannel didSubscribePublicationOfSubscription:subscription];
            });
        }
    }
    void OnPublicationUnsubscribed(NativeSubscriptionInterface* nativeSubscription) override {
        __strong SKWChannel* strongChannel = channel_;
        if(!strongChannel) {
            return;
        }
        id subscription = [strongChannel.repository findSubscriptionBySubscriptionID:nativeSubscription->Id()];
        if([strongChannel.delegate respondsToSelector:@selector(channel:didUnsubscribePublicationOfSubscription:)]) {
            dispatch_group_async(group_, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [strongChannel.delegate channel:strongChannel didUnsubscribePublicationOfSubscription:subscription];
            });
        }
    }
private:
    __weak SKWChannel* channel_;
    dispatch_group_t group_;
};


@implementation SKWChannelInit
@end

@implementation SKWChannelQuery
@end

@implementation SKWMemberInit
@end

@interface SKWChannel(){
    dispatch_group_t eventGroup;
    std::unique_ptr<ChannelEventListener> listener;
}
@end

@implementation SKWChannel

-(id _Nonnull)initWithSharedNative:(std::shared_ptr<NativeChannel>)native {
    if(self = [super init]) {
        _native = native;
        eventGroup = dispatch_group_create();
        _repository = [[ChannelStateRepository alloc] initWithNative:native.get() eventGroup:eventGroup];
        
        listener = std::make_unique<ChannelEventListener>(self, eventGroup);
        _native->AddEventListener(listener.get());
    }
    return self;
}

-(void)dealloc {
    SKW_TRACE("~SKWChannel");
    _native->RemoveEventListener(listener.get());
    // Remove repository resources before removing `_native`(channel)
    // because it has an ownership of native resources(e.g. member, publication etc.)
    [_repository clear];
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
    // TODO: Remove dispatch_group
    dispatch_group_notify(eventGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self->_repository clear];
        self.native->Dispose();
        if(completion) {
            completion(nil);
        }
    });
}

@end
