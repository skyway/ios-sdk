//
//  SKWPublication.mm
//  SkyWay
//
//  Created by sandabu on 2022/03/08.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#import "NSString+StdString.h"
#import "SKWPublication+Internal.h"
#import "SKWSubscription+Internal.h"

#import "SKWLocalPerson.h"
#import "SKWMember+Internal.h"
#import "SKWStream+Internal.h"

#import "SKWCodec+Internal.h"
#import "SKWEncoding+Internal.h"
#import "SKWErrorFactory.h"
#import "SKWWebRTCStats+Internal.h"

#import "Type+Internal.h"

using NativeLocalStream = skyway::core::interface::LocalStream;

class PublicationEventListener : public NativePublication::EventListener {
public:
    PublicationEventListener(SKWPublication* publication)
        : publication_(publication), group_(publication.repository.eventGroup) {}
    void OnUnpublished() override {
        if ([publication_.delegate respondsToSelector:@selector(publicationUnpublished:)]) {
            dispatch_group_async(
                group_, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                  [publication_.delegate publicationUnpublished:publication_];
                });
        }
    }

    void OnSubscribed(skyway::core::interface::Subscription* subscription) override {
        SKWSubscription* sub = [publication_.repository registerSubscriptionIfNeeded:subscription];
        if ([publication_.delegate respondsToSelector:@selector(publication:subscribed:)]) {
            dispatch_group_async(
                group_, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                  [publication_.delegate publication:publication_ subscribed:sub];
                });
        }
    }

    void OnUnsubscribed(skyway::core::interface::Subscription* subscription) override {
        SKWSubscription* sub =
            [publication_.repository findSubscriptionBySubscriptionID:subscription->Id()];
        if ([publication_.delegate respondsToSelector:@selector(publication:unsubscribed:)]) {
            dispatch_group_async(
                group_, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                  [publication_.delegate publication:publication_ unsubscribed:sub];
                });
        }
    }

    void OnSubscriptionListChanged() override {
        if ([publication_.delegate
                respondsToSelector:@selector(publicationSubscriptionListDidChange:)]) {
            dispatch_group_async(
                group_, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                  [publication_.delegate publicationSubscriptionListDidChange:publication_];
                });
        }
    }

    void OnMetadataUpdated(const std::string& nativeMetadata) override {
        if ([publication_.delegate respondsToSelector:@selector(publication:didUpdateMetadata:)]) {
            NSString* metadata = [NSString stringForStdString:nativeMetadata];
            dispatch_group_async(
                group_, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                  [publication_.delegate publication:publication_ didUpdateMetadata:metadata];
                });
        }
    }

    void OnEnabled() override {
        if ([publication_.delegate respondsToSelector:@selector(publicationEnabled:)]) {
            dispatch_group_async(
                group_, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                  [publication_.delegate publicationEnabled:publication_];
                });
        }
    }

    void OnDisabled() override {
        if ([publication_.delegate respondsToSelector:@selector(publicationDisabled:)]) {
            dispatch_group_async(
                group_, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                  [publication_.delegate publicationDisabled:publication_];
                });
        }
    }

    void OnStateChanged() override {
        if ([publication_.delegate respondsToSelector:@selector(publicationStateDidChange:)]) {
            dispatch_group_async(
                group_, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                  [publication_.delegate publicationStateDidChange:publication_];
                });
        }
    }

    void OnConnectionStateChanged(const skyway::core::ConnectionState new_state) override {
        SKWConnectionState state = SKWConvertConnectionState(new_state);
        if ([publication_.delegate respondsToSelector:@selector(publication:
                                                          connectionStateDidChange:)]) {
            dispatch_group_async(
                group_, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                  [publication_.delegate publication:publication_ connectionStateDidChange:state];
                });
        }
    }

private:
    __weak SKWPublication* publication_;
    dispatch_group_t group_;
};

@interface SKWPublication () {
    std::unique_ptr<PublicationEventListener> listener;
}
@end

@implementation SKWPublication

- (id _Nonnull)initWithNative:(NativePublication* _Nonnull)native
                   repository:(ChannelStateRepository* _Nonnull)repository;
{
    if (self = [super init]) {
        _native     = native;
        _repository = repository;
        listener    = std::make_unique<PublicationEventListener>(self);
        _native->AddEventListener(listener.get());
    }
    return self;
}

- (void)dealloc {
    SKW_TRACE("~SKWPublication");
}

- (NSString* _Nonnull)id {
    auto nativeId = _native->Id();
    return [NSString stringForStdString:nativeId];
}

- (SKWMember* _Nullable)publisher {
    auto nativePublisher = _native->Publisher();
    if (!nativePublisher) {
        return nil;
    }
    return [self.repository findMemberByMemberID:nativePublisher->Id()];
}

- (NSArray<SKWSubscription*>* _Nonnull)subscriptions {
    return [self.repository getActiveSubscriptionsByPublicationID:self.id];
}

- (SKWContentType)contentType {
    return SKWContentTypeFromNativeContentType(_native->ContentType());
}

- (NSString* _Nullable)metadata {
    auto metadata = _native->Metadata();
    if (metadata) {
        return [NSString stringForStdString:*metadata];
    }
    return nil;
}

- (NSArray<SKWCodec*>* _Nonnull)codecCapabilities {
    NSMutableArray* codecs = [[NSMutableArray alloc] init];
    for (const auto& nativeCodec : _native->CodecCapabilities()) {
        SKWCodec* codec = [SKWCodec codecForNativeCodec:nativeCodec];
        [codecs addObject:codec];
    }
    return [codecs copy];
}

- (NSArray<SKWEncoding*>* _Nonnull)encodings {
    NSMutableArray* encodings = [[NSMutableArray alloc] init];
    for (const auto& nativeEncoding : _native->Encodings()) {
        SKWEncoding* encoding = [SKWEncoding encodingForNativeEncoding:nativeEncoding];
        [encodings addObject:encoding];
    }
    return [encodings copy];
}

- (SKWPublicationState)state {
    switch (_native->State()) {
        case skyway::core::interface::PublicationState::kEnabled:
            return SKWPublicationStateEnabled;
        case skyway::core::interface::PublicationState::kDisabled:
            return SKWPublicationStateDisabled;
        case skyway::core::interface::PublicationState::kCanceled:
            return SKWPublicationStateCanceled;
    }
}

- (SKWPublication* _Nullable)origin {
    if (auto origin = _native->Origin()) {
        return [_repository findPublicationByPublicationID:origin->Id()];
    }
    return nil;
}

- (void)updateMetadata:(NSString* _Nonnull)metadata
            completion:(SKWPublicationUpdateMetadataCompletion _Nullable)completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      auto result = self.native->UpdateMetadata(metadata.stdString);
      if (completion) {
          if (result) {
              completion(nil);
          } else {
              completion([SKWErrorFactory publicationUpdateMetadataError]);
          }
      }
    });
}

- (void)cancelWithCompletion:(SKWPublicationCancelCompletion _Nullable)completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      auto result = self.native->Cancel();
      if (completion) {
          if (result) {
              completion(nil);
          } else {
              completion([SKWErrorFactory publicationCancelError]);
          }
      }
    });
}

- (void)enableWithCompletion:(SKWPublicationEnableCompletion _Nullable)completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      auto result = self.native->Enable();
      if (completion) {
          if (result) {
              completion(nil);
          } else {
              completion([SKWErrorFactory publicationEnableError]);
          }
      }
    });
}

- (void)disableWithCompletion:(SKWPublicationDisableCompletion _Nullable)completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      auto result = self.native->Disable();
      if (completion) {
          if (result) {
              completion(nil);
          } else {
              completion([SKWErrorFactory publicationDisableError]);
          }
      }
    });
}

- (SKWWebRTCStats* _Nullable)getStatsWithMemberId:(NSString* _Nonnull)memberId {
    auto stats = self.native->GetStats(memberId.stdString);
    if (!stats) {
        return nil;
    }
    return [[SKWWebRTCStats alloc] initWithNativeStats:*stats];
}

- (void)updateEncodings:(NSArray<SKWEncoding*>* _Nonnull)encodings {
    __block std::vector<NativeEncoding> nativeEncodings;
    [encodings enumerateObjectsUsingBlock:^(
                   SKWEncoding* _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
      nativeEncodings.emplace_back([obj nativeEncoding]);
    }];
    self.native->UpdateEncodings(nativeEncodings);
}

- (void)replaceStream:(SKWLocalStream* _Nonnull)stream {
    auto nativeStream = std::static_pointer_cast<NativeLocalStream>(stream.native);
    bool result       = self.native->ReplaceStream(nativeStream);
    if (!result) {
        SKW_ERROR("Replace stream failed.");
        return;
    }
    [self setStream:stream];
}

- (void)setStream:(SKWLocalStream* _Nonnull)stream {
    _stream = stream;
}

- (void)dispose {
    _native->RemoveEventListener(listener.get());
}

@end
