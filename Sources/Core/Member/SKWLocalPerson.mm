//
//  SKWLocalPerson.mm
//  SkyWay
//
//  Created by sandabu on 2022/02/04.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#import "SKWLocalPerson.h"
#import "SKWMember+Internal.h"
#import "SKWPublication+Internal.h"
#import "SKWSubscription+Internal.h"
#import "NSString+StdString.h"

#import "SKWStream+Internal.h"
#import "RTCAudioTrack+Private.h"

#import "SKWCodec+Internal.h"
#import "SKWEncoding+Internal.h"
#import "SKWPublicationOptions+Internal.h"
#import "SKWSubscriptionOptions+Internal.h"

#import "SKWErrorFactory.h"

#import <skyway/core/channel/member/local_person.hpp>
#import <skyway/core/interface/local_stream.hpp>

using NativeLocalPerson = skyway::core::channel::member::LocalPerson;
using NativePublicationOptions = skyway::core::channel::member::LocalPerson::PublicationOptions;
using NativeLocalStream = skyway::core::interface::LocalStream;
using NativePublicationInterface = skyway::core::interface::Publication;
using NativeSubscriptionInterface = skyway::core::interface::Subscription;

class LocalPersonEventListener: public NativeLocalPerson::EventListener {
public:
    LocalPersonEventListener(SKWLocalPerson* person)
        : person_(person), group_(person.repository.eventGroup) {}
    // MARK: - Member::EventListener
    void OnLeft() override {
        if([person_.delegate respondsToSelector:@selector(memberDidLeave:)]) {
            dispatch_group_async(group_, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [person_.delegate memberDidLeave:person_];
            });
        }
    }
    void OnMetadataUpdated(const std::string& nativeMetadata) override {
        NSString* metadata = [NSString stringForStdString:nativeMetadata];
        if([person_.delegate respondsToSelector:@selector(member:didUpdateMetadata:)]) {
            dispatch_group_async(group_, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [person_.delegate member:person_ didUpdateMetadata:metadata];
            });
        }
    }
    void OnPublicationListChanged() override{
        if([person_.delegate respondsToSelector:@selector(memberPublicationListDidChange:)]) {
            dispatch_group_async(group_, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [person_.delegate memberPublicationListDidChange:person_];
            });
        }
    }
    
    void OnSubscriptionListChanged() override{
        if([person_.delegate respondsToSelector:@selector(memberSubscriptionListDidChange:)]) {
            dispatch_group_async(group_, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [person_.delegate memberSubscriptionListDidChange:person_];
            });
        }
    }
    // MARK: - LocalPerson::EventListener
    void OnStreamPublished(NativePublication* nativePublication) override{
        if([person_.delegate respondsToSelector:@selector(localPerson:didPublishStreamOfPublication:)]) {
            id publication = [person_.repository findPublicationByPublicationID:nativePublication->Id()];
            dispatch_group_async(group_, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [person_.delegate localPerson:person_ didPublishStreamOfPublication:publication];
            });
        }
    }
    
    void OnStreamUnpublished(NativePublication* nativePublication) override{
        if([person_.delegate respondsToSelector:@selector(localPerson:didUnpublishStreamOfPublication:)]) {
            id publication = [person_.repository findPublicationByPublicationID:nativePublication->Id()];
            dispatch_group_async(group_, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [person_.delegate localPerson:person_ didUnpublishStreamOfPublication:publication];
            });
        }
    }
    
    void OnPublicationSubscribed(NativeSubscription* nativeSubscription) override{
        if([person_.delegate respondsToSelector:@selector(localPerson:didSubscribePublicationOfSubscription:)]) {
            id subscription = [person_.repository findSubscriptionBySubscriptionID:nativeSubscription->Id()];
            dispatch_group_async(group_, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [person_.delegate localPerson:person_ didSubscribePublicationOfSubscription:subscription];
            });
        }
    }
    
    void OnPublicationUnsubscribed(NativeSubscription* nativeSubscription) override{
        if([person_.delegate respondsToSelector:@selector(localPerson:didUnsubscribePublicationOfSubscription:)]) {
            id subscription = [person_.repository findSubscriptionBySubscriptionID:nativeSubscription->Id()];
            dispatch_group_async(group_, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [person_.delegate localPerson:person_ didUnsubscribePublicationOfSubscription:subscription];
            });
        }
    }
private:
    SKWLocalPerson* person_;
    dispatch_group_t group_;
};

@interface SKWLocalPerson(){
    std::unique_ptr<LocalPersonEventListener> listener;
}
@end

@implementation SKWLocalPerson

-(id _Nonnull)initWithNativePerson:(NativeLocalPerson* _Nonnull)native repository:(ChannelStateRepository* _Nonnull)repository {
    if(self = [super initWithNative:native repository:repository]) {
        listener = std::make_unique<LocalPersonEventListener>(self);
        native->AddEventListener(listener.get());
    }
    return self;
}

-(void)dealloc{
    if(self.native) {
        self.native->RemoveEventListener(listener.get());
    }
}

-(void)publishStream:(SKWLocalStream* _Nonnull)stream options:(SKWPublicationOptions* _Nullable)options completion:(SKWLocalPersonPublishStreamCompletion _Nullable)completion{
    auto nativeStream = std::static_pointer_cast<NativeLocalStream>(stream.native);
    auto nativePerson = (NativeLocalPerson*)self.native;
    NativePublicationOptions nativeOptions;
    if(options) {
        nativeOptions = options.nativePublicationOptions;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        auto nativePublication = nativePerson->Publish(nativeStream, nativeOptions);
        if(completion) {
            if(nativePublication) {
                SKWPublication* pub = [self.repository registerPublicationIfNeeded:nativePublication];
                [pub setStream:stream];
                completion(pub, nil);
            }else {
                completion(nil, [SKWErrorFactory localPersonPublishError]);
            }
        }
    });
}

-(void)subscribePublicationWithPublicationID:(NSString* _Nonnull)publicationID options:(SKWSubscriptionOptions* _Nullable)options completion:(SKWLocalPersonSubscribePublicationCompletion _Nullable)completion{
    auto nativePublicationId = [NSString stdStringForString:publicationID];
    auto nativePerson = (NativeLocalPerson*)self.native;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        auto nativeSubscription = nativePerson->Subscribe(nativePublicationId, options.nativeSubscriptionOptions);
        if(completion) {
            if(nativeSubscription) {
                SKWSubscription* sub = [self.repository registerSubscriptionIfNeeded:nativeSubscription];
                completion(sub, nil);
            }else {
                completion(nil, [SKWErrorFactory localPersonSubscribeError]);
            }
        }
    });

}

-(void)unpublishWithPublicationID:(NSString* _Nonnull)publicationID completion:(SKWLocalPersonUnpublishCompletion _Nullable)completion{
    auto nativePublicationId = [NSString stdStringForString:publicationID];
    auto nativePerson = (NativeLocalPerson*)self.native;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        auto result = nativePerson->Unpublish(nativePublicationId);
        if(completion) {
            if(result) {
                completion(nil);
            }else {
                completion([SKWErrorFactory localPersonUnpublishError]);
            }
        }
    });
}

-(void)unsubscribeWithSubscriptionID:(NSString* _Nonnull)subscriptionID completion:(SKWLocalPersonUnsubscribeCompletion _Nullable)completion{
    auto nativeSubscriptionId = [NSString stdStringForString:subscriptionID];
    auto nativePerson = (NativeLocalPerson*)self.native;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        auto result = nativePerson->Unsubscribe(nativeSubscriptionId);
        if(completion) {
            if(result) {
                completion(nil);
            }else {
                completion([SKWErrorFactory localPersonUnsubscribeError]);
            }
        }
    });
}

@end
