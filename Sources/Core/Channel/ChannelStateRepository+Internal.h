
//
//  ChannelStateRepository+Internal.h
//  SkyWay
//
//  Created by sandabu on 2024/10/25.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef ChannelStateRepository_Internal_h
#define ChannelStateRepository_Internal_h

#import "ChannelStateRepository.h"

@interface ChannelStateRepository ()

@property(nonatomic, readonly) NSMutableArray<SKWMember*>* _Nonnull mutableMembers;
@property(nonatomic, readonly) NSMutableArray<SKWPublication*>* _Nonnull mutablePublications;
@property(nonatomic, readonly) NSMutableArray<SKWSubscription*>* _Nonnull mutableSubscriptions;

- (void)syncNativeChannel:(std::shared_ptr<skyway::core::interface::Channel>)nativeChannel;
- (SKWMember* _Nullable)createMemberForNative:
    (std::shared_ptr<skyway::core::interface::Member>)native;
- (SKWPublication* _Nonnull)createPublicationForNative:
    (std::shared_ptr<skyway::core::interface::Publication>)native;
- (SKWSubscription* _Nonnull)createSubscriptionForNative:
    (std::shared_ptr<skyway::core::interface::Subscription>)native;

@end

#endif /* ChannelStateRepository_Internal_h */
