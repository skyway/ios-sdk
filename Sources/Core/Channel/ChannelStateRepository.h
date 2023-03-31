//
//  ChannelStateRepository.h
//  SkyWay
//
//  Created by sandabu on 2022/04/08.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef ChannelStateRepository_h
#define ChannelStateRepository_h

#import <Foundation/Foundation.h>

#import <skyway/core/interface/channel.hpp>

@class SKWMember;
@class SKWRemoteMember;
@class SKWPublication;
@class SKWSubscription;

using NativeChannelInterface = skyway::core::interface::Channel;
using NativeMemberInterface = skyway::core::interface::Member;
using NativeRemoteMemberInterface = skyway::core::interface::RemoteMember;
using NativePublicationInterface = skyway::core::interface::Publication;
using NativeSubscriptionInterface = skyway::core::interface::Subscription;

@interface ChannelStateRepository : NSObject

@property(nonatomic, readonly) NSArray<SKWMember*>* _Nonnull members;
@property(nonatomic, readonly) NSArray<SKWPublication*>* _Nonnull publications;
@property(nonatomic, readonly) NSArray<SKWSubscription*>* _Nonnull subscriptions;
@property(nonatomic, readonly) dispatch_group_t _Nonnull eventGroup;

-(id _Nonnull)initWithNative:(NativeChannelInterface* _Nonnull)native eventGroup:(dispatch_group_t _Nonnull)eventGroup;

-(SKWMember* _Nullable)findMemberByMemberID:(const std::string&)memberID;
-(SKWPublication* _Nullable)findPublicationByPublicationID:(const std::string&)publicationID;
-(SKWSubscription* _Nullable)findSubscriptionBySubscriptionID:(const std::string&)subscriptionID;

-(SKWMember* _Nonnull)registerMemberIfNeeded:(NativeMemberInterface* _Nonnull)nativeMember;
-(SKWPublication* _Nonnull)registerPublicationIfNeeded:(NativePublicationInterface* _Nonnull)nativePublication;
-(SKWSubscription* _Nonnull)registerSubscriptionIfNeeded:(NativeSubscriptionInterface* _Nonnull)nativeSubscription;

-(NSArray<SKWPublication*>* _Nonnull)getActivePublicationsByPublisherID:(NSString* _Nonnull)publisherID;
-(NSArray<SKWSubscription*>* _Nonnull)getActiveSubscriptionsBySubscriberID:(NSString* _Nonnull)subscriberID;
-(NSArray<SKWSubscription*>* _Nonnull)getActiveSubscriptionsByPublicationID:(NSString* _Nonnull)publicationID;


@end

#endif /* ChannelStateRepository_h */
