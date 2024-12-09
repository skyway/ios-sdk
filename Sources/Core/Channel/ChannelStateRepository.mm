//
//  ChannelStateRepository.mm
//  SkyWay
//
//  Created by sandabu on 2022/04/08.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#import "ChannelStateRepository+Internal.h"

#import "SKWContext.h"
#import "SKWLocalPerson+Internal.h"
#import "SKWMember+Internal.h"
#import "SKWPlugin+Internal.h"
#import "SKWPublication+Internal.h"
#import "SKWSubscription+Internal.h"
#import "SKWUnknownMember.h"

#import "NSString+StdString.h"

#import "skyway/global/interface/logger.hpp"

@implementation ChannelStateRepository

- (id _Nonnull)initWithNative:(std::shared_ptr<skyway::core::interface::Channel>)native
                   eventGroup:(dispatch_group_t)eventGroup {
    if (self = [super init]) {
        _mutableMembers       = [[NSMutableArray alloc] init];
        _mutablePublications  = [[NSMutableArray alloc] init];
        _mutableSubscriptions = [[NSMutableArray alloc] init];
        _eventGroup           = eventGroup;
        _isCleared            = NO;
        [self syncNativeChannel:native];
    }
    return self;
}

- (void)dealloc {
    SKW_TRACE("~SKWChannelStateRepository");
}

- (void)syncNativeChannel:(std::shared_ptr<skyway::core::interface::Channel>)nativeChannel {
    for (const auto& nativeMember : nativeChannel->Members()) {
        [self registerMemberIfNeeded:nativeMember];
    }
    for (const auto& nativePublication : nativeChannel->Publications()) {
        [self registerPublicationIfNeeded:nativePublication];
    }
    for (const auto& nativeSubscription : nativeChannel->Subscriptions()) {
        [self registerSubscriptionIfNeeded:nativeSubscription];
    }
}

- (NSArray<SKWMember*>* _Nonnull)members {
    @synchronized(_mutableMembers) {
        NSMutableArray<SKWMember*>* members = [[NSMutableArray alloc] init];
        [_mutableMembers enumerateObjectsUsingBlock:^(
                             SKWMember* _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
          if (obj.state != SKWMemberStateLeft) {
              [members addObject:obj];
          }
        }];
        return [members copy];
    }
}

- (NSArray<SKWPublication*>* _Nonnull)publications {
    @synchronized(_mutablePublications) {
        NSMutableArray<SKWPublication*>* publications = [[NSMutableArray alloc] init];
        [_mutablePublications
            enumerateObjectsUsingBlock:^(
                SKWPublication* _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
              if (obj.state != SKWPublicationStateCanceled) {
                  [publications addObject:obj];
              }
            }];
        return [publications copy];
    }
}

- (NSArray<SKWSubscription*>* _Nonnull)subscriptions {
    @synchronized(_mutableSubscriptions) {
        NSMutableArray<SKWSubscription*>* subscriptions = [[NSMutableArray alloc] init];
        [_mutableSubscriptions
            enumerateObjectsUsingBlock:^(
                SKWSubscription* _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
              if (obj.state != SKWSubscriptionStateCanceled) {
                  [subscriptions addObject:obj];
              }
            }];
        return [subscriptions copy];
    }
}

- (SKWMember* _Nullable)findMemberByMemberID:(const std::string&)memberID {
    SKWMember* member;
    @synchronized(_mutableMembers) {
        NSString* identifier = [NSString stringForStdString:memberID];
        NSUInteger idx =
            [_mutableMembers indexOfObjectPassingTest:^BOOL(
                                 SKWMember* _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
              return [obj.id isEqualToString:identifier];
            }];
        if (idx != NSNotFound) {
            member = _mutableMembers[idx];
        }
    }

    return member;
}

- (SKWPublication* _Nullable)findPublicationByPublicationID:(const std::string&)publicationID {
    SKWPublication* publication;
    @synchronized(_mutablePublications) {
        NSString* identifier = [NSString stringForStdString:publicationID];
        NSUInteger idx       = [_mutablePublications
            indexOfObjectPassingTest:^BOOL(
                SKWPublication* _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
              return [obj.id isEqualToString:identifier];
            }];
        if (idx != NSNotFound) {
            publication = _mutablePublications[idx];
        }
    }
    return publication;
}

- (SKWSubscription* _Nullable)findSubscriptionBySubscriptionID:(const std::string&)subscriptionID {
    SKWSubscription* subscription;
    @synchronized(_mutableSubscriptions) {
        NSString* identifier = [NSString stringForStdString:subscriptionID];
        NSUInteger idx       = [_mutableSubscriptions
            indexOfObjectPassingTest:^BOOL(
                SKWSubscription* _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
              return [obj.id isEqualToString:identifier];
            }];
        if (idx != NSNotFound) {
            subscription = _mutableSubscriptions[idx];
        }
    }
    return subscription;
}

- (SKWMember* _Nonnull)registerMemberIfNeeded:
    (std::shared_ptr<skyway::core::interface::Member>)nativeMember {
    SKWMember* member;
    @synchronized(_mutableMembers) {
        if (id existingMember = [self findMemberByMemberID:nativeMember->Id()]) {
            return existingMember;
        }

        member = [self createMemberForNative:nativeMember];
        [_mutableMembers addObject:member];
    }

    return member;
}

- (SKWPublication* _Nonnull)registerPublicationIfNeeded:
    (std::shared_ptr<skyway::core::interface::Publication>)nativePublication {
    SKWPublication* publication;
    @synchronized(_mutablePublications) {
        if (id existingPublication =
                [self findPublicationByPublicationID:nativePublication->Id()]) {
            return existingPublication;
        }

        publication = [self createPublicationForNative:nativePublication];
        [_mutablePublications addObject:publication];
    }

    return publication;
}

- (SKWSubscription* _Nonnull)registerSubscriptionIfNeeded:
    (std::shared_ptr<skyway::core::interface::Subscription>)nativeSubscription {
    SKWSubscription* subscription;
    @synchronized(_mutableSubscriptions) {
        if (id existingSubscription =
                [self findSubscriptionBySubscriptionID:nativeSubscription->Id()]) {
            if (![existingSubscription stream] && nativeSubscription->Stream()) {
                [existingSubscription setStreamFromNativeStream:nativeSubscription->Stream()];
            }
            return existingSubscription;
        }
        subscription = [self createSubscriptionForNative:nativeSubscription];
        [_mutableSubscriptions addObject:subscription];
    }
    return subscription;
}

- (NSArray<SKWPublication*>* _Nonnull)getActivePublicationsByPublisherID:
    (NSString* _Nonnull)publisherID {
    NSMutableArray<SKWPublication*>* publications = [[NSMutableArray alloc] init];
    @synchronized(_mutablePublications) {
        [self.publications enumerateObjectsUsingBlock:^(
                               SKWPublication* _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
          if ([obj.publisher.id isEqualToString:publisherID]) {
              [publications addObject:obj];
          }
        }];
    }
    return [publications copy];
}

- (NSArray<SKWSubscription*>* _Nonnull)getActiveSubscriptionsBySubscriberID:
    (NSString* _Nonnull)subscriberID {
    NSMutableArray<SKWSubscription*>* subscriptions = [[NSMutableArray alloc] init];
    @synchronized(_mutableSubscriptions) {
        [self.subscriptions
            enumerateObjectsUsingBlock:^(
                SKWSubscription* _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
              if ([obj.subscriber.id isEqualToString:subscriberID]) {
                  [subscriptions addObject:obj];
              }
            }];
    }

    return [subscriptions copy];
}

- (NSArray<SKWSubscription*>* _Nonnull)getActiveSubscriptionsByPublicationID:
    (NSString* _Nonnull)publicationID {
    NSMutableArray<SKWSubscription*>* subscriptions = [[NSMutableArray alloc] init];
    @synchronized(_mutableSubscriptions) {
        [self.subscriptions
            enumerateObjectsUsingBlock:^(
                SKWSubscription* _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
              if ([obj.publication.id isEqualToString:publicationID]) {
                  [subscriptions addObject:obj];
              }
            }];
    }
    return [subscriptions copy];
}

- (SKWMember* _Nullable)createMemberForNative:
    (std::shared_ptr<skyway::core::interface::Member>)native {
    if (auto localPerson =
            std::dynamic_pointer_cast<skyway::core::channel::member::LocalPerson>(native)) {
        return [[SKWLocalPerson alloc] initWithNativePerson:localPerson repository:self];
    }
    __block SKWPlugin* plugin = nil;
    [SKWContext.plugins
        enumerateObjectsUsingBlock:^(SKWPlugin* _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
          if ([obj.subtype isEqualToString:[NSString stringForStdString:native->Subtype()]]) {
              plugin = obj;
              *stop  = YES;
          }
        }];
    if (plugin == nil) {
        return [[SKWUnknownMember alloc] initWithNative:native repository:self];
    } else if (auto nativeRemoteMember =
                   std::dynamic_pointer_cast<skyway::core::interface::RemoteMember>(native)) {
        return [plugin createRemoteMemberWithNative:nativeRemoteMember repository:self];
    }
    SKW_ERROR("Creating remote member failed.");
    return nil;
}

- (SKWPublication* _Nonnull)createPublicationForNative:
    (std::shared_ptr<skyway::core::interface::Publication>)native {
    return [[SKWPublication alloc] initWithNative:native repository:self];
}

- (SKWSubscription* _Nonnull)createSubscriptionForNative:
    (std::shared_ptr<skyway::core::interface::Subscription>)native {
    return [[SKWSubscription alloc] initWithNative:native repository:self];
}

- (void)clear {
    SKW_DEBUG("Wait for event threads to finish executing...");
    // It shouldn't cause dead-lock even if SKWChannel is destroyed or disposed on event thread
    // because `dispatch_group_wait` won't wait on the same queue with `_eventGroup`.
    dispatch_group_wait(_eventGroup, DISPATCH_TIME_FOREVER);
    SKW_DEBUG("Start removing resources on repository.");
    @synchronized(_mutableMembers) {
        [_mutableMembers enumerateObjectsUsingBlock:^(
                             SKWMember* _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
          [obj dispose];
        }];
        [_mutableMembers removeAllObjects];
    }
    @synchronized(_mutableSubscriptions) {
        [_mutableSubscriptions
            enumerateObjectsUsingBlock:^(
                SKWSubscription* _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
              [obj dispose];
            }];
        [_mutableSubscriptions removeAllObjects];
    }
    @synchronized(_mutablePublications) {
        [_mutablePublications
            enumerateObjectsUsingBlock:^(
                SKWPublication* _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
              [obj dispose];
            }];
        [_mutablePublications removeAllObjects];
    }
    _isCleared = YES;
    SKW_DEBUG("Resources were cleared.");
}

@end
