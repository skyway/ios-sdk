//
//  SKWRemotePerson.m
//  SkyWay
//
//  Created by sandabu on 2022/03/28.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#import "SKWRemotePerson.h"
#import "SKWRemotePerson+Internal.h"
#import "SKWSubscription+Internal.h"
#import "SKWMember+Internal.h"
#import "SKWSubscriptionOptions+Internal.h"
#import "NSString+StdString.h"
#import "SKWErrorFactory.h"

class RemotePersonEventListener: public NativeRemotePerson::EventListener {
public:
    // MARK: - Member::EventListener
    RemotePersonEventListener(SKWRemotePerson* person)
        : person_(person) {}
    void OnLeft() override {
        if([person_.delegate respondsToSelector:@selector(memberDidLeave:)]) {
            [person_.delegate memberDidLeave:person_];
        }
    }
    void OnMetadataUpdated(const std::string& nativeMetadata) override {
        NSString* metadata = [NSString stringForStdString:nativeMetadata];
        if([person_.delegate respondsToSelector:@selector(member:didUpdateMetadata:)]) {
            [person_.delegate member:person_ didUpdateMetadata:metadata];
        }
    }
    void OnPublicationListChanged() override{
        if([person_.delegate respondsToSelector:@selector(memberPublicationListDidChange:)]) {
            [person_.delegate memberPublicationListDidChange:person_];
        }
    }
    
    void OnSubscriptionListChanged() override{
        if([person_.delegate respondsToSelector:@selector(memberSubscriptionListDidChange:)]) {
            [person_.delegate memberSubscriptionListDidChange:person_];
        }
    }
    // MARK: - RemotePerson::EventListener
    void OnPublicationSubscribed(NativeSubscription* nativeSubscription) override{
        if([person_.delegate respondsToSelector:@selector(remotePerson:didSubscribePublicationOfSubscription:)]) {
            id subscription = [person_.repository findSubscriptionBySubscriptionID:nativeSubscription->Id()];
            [person_.delegate remotePerson:person_ didSubscribePublicationOfSubscription:subscription];
        }
    }
    
    void OnPublicationUnsubscribed(NativeSubscription* nativeSubscription) override{
        if([person_.delegate respondsToSelector:@selector(remotePerson:didUnsubscribePublicationOfSubscription:)]) {
            id subscription = [person_.repository findSubscriptionBySubscriptionID:nativeSubscription->Id()];
            [person_.delegate remotePerson:person_ didUnsubscribePublicationOfSubscription:subscription];
        }
    }
private:
    SKWRemotePerson* person_;
};

@interface SKWRemotePerson(){
    std::unique_ptr<RemotePersonEventListener> listener;
}
@end

@implementation SKWRemotePerson

-(id _Nonnull)initWithNativePerson:(NativeRemotePerson* _Nonnull)native repository:(ChannelStateRepository* _Nonnull)repository{
    if(self = [super initWithNative:native repository:repository]) {
        listener = std::make_unique<RemotePersonEventListener>(self);
        native->AddEventListener(listener.get());
    }
    return self;
}

-(void)subscribePublicationWithPublicationID:(NSString* _Nonnull)publicationID completion:(SKWRemotePersonSubscribePublicationCompletion _Nullable)completion {
    auto nativePublicationId = [NSString stdStringForString:publicationID];
    auto nativePerson = (NativeRemotePerson*)self.native;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        auto nativeSubscription = nativePerson->Subscribe(nativePublicationId);
        if(completion) {
            if(nativeSubscription) {
                SKWSubscription* sub = [self.repository registerSubscriptionIfNeeded:nativeSubscription];
                completion(sub, nil);
            }else {
                completion(nil, [SKWErrorFactory remotePersonSubscribeError]);
            }
        }
    });
}

-(void)unsubscribeWithSubscriptionID:(NSString* _Nonnull)subscriptionID completion:(SKWRemotePersonUnsubscribeCompletion _Nullable)completion {
    auto nativeSubscriptionId = [NSString stdStringForString:subscriptionID];
    auto nativePerson = (NativeRemotePerson*)self.native;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        auto result = nativePerson->Unsubscribe(nativeSubscriptionId);
        if(completion) {
            if(result) {
                completion(nil);
            }else {
                completion([SKWErrorFactory remotePersonUnsubscribeError]);
            }
        }
    });
}


@end