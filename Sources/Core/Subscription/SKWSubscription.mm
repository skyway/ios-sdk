//
//  SKWSubscription.mm
//  SkyWay
//
//  Created by sandabu on 2022/03/08.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#import "SKWSubscription+Internal.h"

#import "SKWMember+Internal.h"

#import "SKWRemoteAudioStream.h"
#import "SKWRemoteVideoStream.h"
#import "SKWRemoteDataStream.h"
#import "SKWPublication+Internal.h"
#import "SKWStream+Internal.h"
#import "SKWRemoteDataStream+Internal.h"
#import "SKWErrorFactory.h"
#import "SKWWebRTCStats+Internal.h"
#import "Type+Internal.h"

#import "NSString+StdString.h"

class SubscriptionEventListener: public NativeSubscription::EventListener{
public:
    SubscriptionEventListener(SKWSubscription* subscription)
        : subscription_(subscription), group_(subscription.repository.eventGroup) {}
    void OnCanceled() override {
        if([subscription_.delegate respondsToSelector:@selector(subscriptionCanceled:)]) {
            dispatch_group_async(group_, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [subscription_.delegate subscriptionCanceled:subscription_];
            });
        }
    }
    
    void OnConnectionStateChanged(const skyway::core::ConnectionState new_state) override {
        SKWConnectionState state = SKWConvertConnectionState(new_state);
        if([subscription_.delegate respondsToSelector:@selector(subscription:connectionStateDidChange:)]) {
            dispatch_group_async(group_, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [subscription_.delegate subscription:subscription_ connectionStateDidChange:state];
            });
        }
    }
    
private:
    __weak SKWSubscription* subscription_;
    dispatch_group_t group_;
};


@interface SKWSubscription(){
    std::unique_ptr<SubscriptionEventListener> listener;
}

-(void)instantiateStream;

@end

@implementation SKWSubscription


-(id _Nonnull)initWithNative:(NativeSubscription* _Nonnull)native repository:(ChannelStateRepository* _Nonnull)repository{
    if(self = [super init]) {
        _native = native;
        _repository = repository;
        listener = std::make_unique<SubscriptionEventListener>(self);
        _native->AddEventListener(listener.get());
        [self instantiateStream];
    }
    return self;
}

-(void)dealloc{
    SKW_TRACE("~SKWSubscription");
}

-(NSString* _Nonnull)id {
    auto nativeId = _native->Id();
    return [NSString stringForStdString:nativeId];
}

-(SKWContentType)contentType {
    return SKWContentTypeFromNativeContentType(_native->ContentType());
}

-(SKWPublication* _Nullable)publication {
    auto nativePublication = _native->Publication();
    if(!nativePublication) {
        return nil;
    }
    return [self.repository findPublicationByPublicationID:nativePublication->Id()];
}

-(SKWMember* _Nullable)subscriber {
    auto nativeSubscriber = _native->Subscriber();
    if(!nativeSubscriber) {
        return nil;
    }
    return [self.repository findMemberByMemberID:nativeSubscriber->Id()];
}

-(SKWSubscriptionState)state{
    switch (_native->State()) {
        case skyway::core::interface::SubscriptionState::kEnabled: return SKWSubscriptionStateEnabled;
        case skyway::core::interface::SubscriptionState::kDisabled: return
            // TODO: Change it to disabled
            SKWSubscriptionStateCanceled;
        case skyway::core::interface::SubscriptionState::kCanceled: return SKWSubscriptionStateCanceled;
    }
}

-(NSString* _Nullable)preferredEncodingId {
    auto nativeEncodingId = _native->PreferredEncodingId();
    if(!nativeEncodingId) {
        return nil;
    }
    return [NSString stringForStdString:*nativeEncodingId];
}

-(void)changePreferredEncodingWithEncodingId:(NSString* _Nonnull)encodingId {
    _native->ChangePreferredEncoding([NSString stdStringForString:encodingId]);
}

-(void)cancelWithCompletion:(SKWSubscriptionCancelCompletion _Nullable)completion{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        auto result = self.native->Cancel();
        if(completion) {
            if(result) {
                completion(nil);
            }else {
                completion([SKWErrorFactory subscriptionCancelError]);
            }
        }
    });
}

-(SKWWebRTCStats* _Nullable)getStats {
    auto stats = self.native->GetStats();
    if(!stats) {
        return nil;
    }
    return [[SKWWebRTCStats alloc] initWithNativeStats:*stats];
}

-(void)instantiateStream {
    auto nativeStream = _native->Stream();
    [self setStreamFromNativeStream:nativeStream];
}

-(void)setStreamFromNativeStream:(std::shared_ptr<skyway::core::interface::RemoteStream>)nativeStream {
    if(!nativeStream) {
        return;
    }
    auto type = nativeStream->ContentType();
    switch(type) {
        case skyway::model::ContentType::kAudio:
            _stream =[[SKWRemoteAudioStream alloc] initWithSharedNative:nativeStream];
            break;
        case skyway::model::ContentType::kVideo:
            _stream =[[SKWRemoteVideoStream alloc] initWithSharedNative:nativeStream];
            break;
        case skyway::model::ContentType::kData:
            _stream =[[SKWRemoteDataStream alloc] initWithSharedNative:nativeStream eventGroup:_repository.eventGroup];
            break;
    }
}

-(void)dispose {
    _native->RemoveEventListener(listener.get());
}

@end
