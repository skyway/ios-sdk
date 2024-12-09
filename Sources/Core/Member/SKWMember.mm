//
//  SKWMember.mm
//  SkyWay
//
//  Created by sandabu on 2022/02/04.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#import "SKWMember.h"
#import "SKWErrorFactory.h"
#import "SKWMember+Internal.h"

#import "Type+Internal.h"

#import "NSString+StdString.h"

#import <skyway/core/interface/member.hpp>

@implementation SKWMember

- (id _Nonnull)initWithNative:(std::shared_ptr<skyway::core::interface::Member>)native
                   repository:(ChannelStateRepository* _Nonnull)repository {
    if (self = [super init]) {
        _native     = native;
        _repository = repository;
    }
    return self;
}

- (NSString* _Nonnull)id {
    auto nativeId = _native->Id();
    return [NSString stringForStdString:nativeId];
}

- (NSString* _Nullable)name {
    auto name = _native->Name();
    if (name) {
        return [NSString stringForStdString:*name];
    }
    return nil;
}

- (NSString* _Nullable)metadata {
    auto metadata = _native->Metadata();
    if (metadata) {
        return [NSString stringForStdString:*metadata];
    }
    return nil;
}

- (SKWMemberType)type {
    return SKWMemberTypeFromNativeType(_native->Type());
}

- (SKWSide)side {
    return SKWSideFromNativeSide(_native->Side());
}

- (NSString* _Nonnull)subtype {
    return [NSString stringForStdString:_native->Subtype()];
}

- (SKWMemberState)state {
    switch (_native->State()) {
        case skyway::core::interface::MemberState::kJoined:
            return SKWMemberStateJoined;
        case skyway::core::interface::MemberState::kLeft:
            return SKWMemberStateLeft;
    }
}

- (NSArray<SKWPublication*>* _Nonnull)publications {
    return [_repository getActivePublicationsByPublisherID:self.id];
}

- (NSArray<SKWSubscription*>* _Nonnull)subscriptions {
    return [_repository getActiveSubscriptionsBySubscriberID:self.id];
}

- (void)updateMetadata:(NSString* _Nonnull)metadata
            completion:(SKWMemberUpdateMetadataCompletion _Nullable)completion {
    auto nativeMetadata = [NSString stdStringForString:metadata];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      auto result = self.native->UpdateMetadata(nativeMetadata);
      if (completion) {
          if (result) {
              completion(nil);
          } else {
              completion([SKWErrorFactory memberUpdateMetadataError]);
          }
      }
    });
}

- (void)leaveWithCompletion:(SKWMemberLeaveCompletion _Nullable)completion {
    auto nativeMemberId = [NSString stdStringForString:self.id];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      auto result = self.native->Leave();
      if (result) {
          completion(nil);
      } else {
          completion([SKWErrorFactory memberLeaveError]);
      }
    });
}

- (void)dispose {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

@end
