//
//  SKWPublication.mm
//  SkyWay
//
//  Created by sandabu on 2022/03/08.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#import "SKWPublication+Internal.h"
#import "SKWSubscription+Internal.h"
#import "NSString+StdString.h"

#import "SKWLocalPerson.h"
#import "SKWMember+Internal.h"

#import "SKWCodec+Internal.h"
#import "SKWEncoding+Internal.h"
#import "SKWErrorFactory.h"

#import "Type+Internal.h"

class PublicationEventListener: public NativePublication::EventListener{
public:
    PublicationEventListener(SKWPublication* publication)
        : publication_(publication) {}
    void OnUnpublished() override {
        if([publication_.delegate respondsToSelector:@selector(publicationUnpublished:)]) {
            [publication_.delegate publicationUnpublished:publication_];
        }
    }
    
    void OnSubscribed() override {
        if([publication_.delegate respondsToSelector:@selector(publicationSubscribed:)]) {
            [publication_.delegate publicationSubscribed:publication_];
        }
    }
    
    void OnUnsubscribed() override {
        if([publication_.delegate respondsToSelector:@selector(publicationUnsubscribed:)]) {
            [publication_.delegate publicationUnsubscribed:publication_];
        }
    }
    
    void OnSubscriptionListChanged() override {
        if([publication_.delegate respondsToSelector:@selector(publicationSubscriptionListDidChange:)]) {
            [publication_.delegate publicationSubscriptionListDidChange:publication_];
        }
    }
    
    void OnMetadataUpdated(const std::string& nativeMetadata) override {
        if([publication_.delegate respondsToSelector:@selector(publication:didUpdateMetadata:)]) {
            NSString* metadata = [NSString stringForStdString:nativeMetadata];
            [publication_.delegate publication:publication_ didUpdateMetadata:metadata];
        }
    }
    
    void OnEnabled() override {
        if([publication_.delegate respondsToSelector:@selector(publicationEnabled:)]) {
            [publication_.delegate publicationEnabled:publication_];
        }
    }
    
    void OnDisabled() override {
        if([publication_.delegate respondsToSelector:@selector(publicationDisabled:)]) {
            [publication_.delegate publicationDisabled:publication_];
        }
    }
    
    void OnStateChanged() override {
        if([publication_.delegate respondsToSelector:@selector(publicationStateDidChange:)]) {
            [publication_.delegate publicationStateDidChange:publication_];
        }
    }
    
private:
    SKWPublication* publication_;
};

@interface SKWPublication(){
    std::unique_ptr<PublicationEventListener> listener;
}
@end

@implementation SKWPublication

-(id _Nonnull)initWithNative:(NativePublication* _Nonnull)native repository:(ChannelStateRepository* _Nonnull)repository;{
    if(self = [super init]) {
        _native = native;
        _repository = repository;
        listener = std::make_unique<PublicationEventListener>(self);
        _native->AddEventListener(listener.get());
    }
    return self;
}

-(NSString* _Nonnull)id {
    auto nativeId = _native->Id();
    return [NSString stringForStdString:nativeId];
}

-(SKWMember* _Nullable)publisher {
    auto nativePublisher = _native->Publisher();
    if(!nativePublisher) {
        return nil;
    }
    return [self.repository findMemberByMemberID:nativePublisher->Id()];
}

-(NSArray<SKWSubscription*>* _Nonnull)subscriptions {
    return [self.repository getActiveSubscriptionsByPublicationID:self.id];
}

-(SKWContentType)contentType {
    return SKWContentTypeFromNativeContentType(_native->ContentType());
}

-(NSString* _Nullable)metadata {
    auto metadata = _native->Metadata();
    if(metadata) {
        return [NSString stringForStdString:*metadata];
    }
    return nil;
}

-(NSArray<SKWCodec*>* _Nonnull)codecCapabilities{
    NSMutableArray *codecs = [[NSMutableArray alloc] init];
    for(const auto& nativeCodec : _native->CodecCapabilities()){
        SKWCodec* codec = [SKWCodec codecForNativeCodec:nativeCodec];
        [codecs addObject:codec];
    }
    return [codecs copy];
}

-(NSArray<SKWEncoding*>* _Nonnull)encodings{
    NSMutableArray *encodings = [[NSMutableArray alloc] init];
    for(const auto& nativeEncoding : _native->Encodings()){
        SKWEncoding* encoding = [SKWEncoding encodingForNativeEncoding:nativeEncoding];
        [encodings addObject:encoding];
    }
    return [encodings copy];
}

-(SKWPublicationState)state{
    switch(_native->State()) {
        case skyway::core::interface::PublicationState::kEnabled:
            return SKWPublicationStateEnabled;
        case skyway::core::interface::PublicationState::kDisabled:
            return SKWPublicationStateDisabled;
        case skyway::core::interface::PublicationState::kCanceled:
            return SKWPublicationStateCanceled;
    }
}

-(SKWPublication* _Nullable)origin{
    if(auto origin = _native->Origin()) {
        return [_repository findPublicationByPublicationID:origin->Id()];
    }
    return nil;
}

-(void)updateMetadata:(NSString* _Nonnull)metadata completion:(SKWPublicationUpdateMetadataCompletion _Nullable)completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        auto result = self.native->UpdateMetadata(metadata.stdString);
        if(completion) {
            if(result) {
                completion(nil);
            }else {
                completion([SKWErrorFactory publicationUpdateMetadataError]);
            }
        }
    });
}

-(void)cancelWithCompletion:(SKWPublicationCancelCompletion _Nullable)completion{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        auto result = self.native->Cancel();
        if(completion) {
            if(result) {
                completion(nil);
            }else {
                completion([SKWErrorFactory publicationCancelError]);
            }
        }
    });
}

-(void)enableWithCompletion:(SKWPublicationEnableCompletion _Nullable)completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        auto result = self.native->Enable();
        if(completion) {
            if(result) {
                completion(nil);
            }else {
                completion([SKWErrorFactory publicationEnableError]);
            }
        }
    });
}

-(void)disableWithCompletion:(SKWPublicationDisableCompletion _Nullable)completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        auto result = self.native->Disable();
        if(completion) {
            if(result) {
                completion(nil);
            }else {
                completion([SKWErrorFactory publicationDisableError]);
            }
        }
    });
}


-(void)updateEncodings:(NSArray<SKWEncoding*>* _Nonnull)encodings{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block std::vector<NativeEncoding> nativeEncodings;
        [encodings enumerateObjectsUsingBlock:^(SKWEncoding * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            nativeEncodings.emplace_back([obj nativeEncoding]);
        }];
        self.native->UpdateEncodings(nativeEncodings);
    });
}

-(void)setStream:(SKWLocalStream* _Nonnull)stream {
    _stream = stream;
}


@end
