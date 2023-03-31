//
//  ChannelStateRepository.mm
//  SkyWay
//
//  Created by sandabu on 2022/04/08.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#import "ChannelStateRepository.h"

#import "SKWLocalPerson+Internal.h"
#import "SKWPublication+Internal.h"
#import "SKWSubscription+Internal.h"
#import "SKWPlugin+Internal.h"
#import "SKWContext.h"
#import "NSString+StdString.h"

@interface ChannelStateRepository(){
    NSMutableArray<SKWMember*>* mutableMembers;
    NSMutableArray<SKWPublication*>* mutablePublications;
    NSMutableArray<SKWSubscription*>* mutableSubscriptions;
}
-(void)syncNativeChannel:(NativeChannelInterface* _Nonnull)nativeChannel;

-(SKWMember* _Nullable)createMemberForNative:(NativeMemberInterface* _Nonnull)native;
-(SKWPublication* _Nonnull)createPublicationForNative:(NativePublication* _Nonnull)native;
-(SKWSubscription* _Nonnull)createSubscriptionForNative:(NativeSubscription* _Nonnull)native;

@end

@implementation ChannelStateRepository

-(id _Nonnull)initWithNative:(NativeChannelInterface* _Nonnull)native eventGroup:(dispatch_group_t)eventGroup{
    if(self = [super init]) {
        mutableMembers = [[NSMutableArray alloc] init];
        mutablePublications = [[NSMutableArray alloc] init];
        mutableSubscriptions = [[NSMutableArray alloc] init];
        _eventGroup = eventGroup;
        [self syncNativeChannel:native];
    }
    return self;
}

-(void)syncNativeChannel:(NativeChannelInterface* _Nonnull)nativeChannel{
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

-(NSArray<SKWMember*>* _Nonnull)members {
    @synchronized (mutableMembers) {
        NSMutableArray<SKWMember*>* members = [[NSMutableArray alloc] init];
        [mutableMembers enumerateObjectsUsingBlock:^(SKWMember * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(obj.state != SKWMemberStateLeft) {
                [members addObject:obj];
            }
        }];
        return [members copy];
    }
}

-(NSArray<SKWPublication*>* _Nonnull)publications {
    @synchronized (mutablePublications) {
        NSMutableArray<SKWPublication*>* publications = [[NSMutableArray alloc] init];
        [mutablePublications enumerateObjectsUsingBlock:^(SKWPublication * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(obj.state != SKWPublicationStateCanceled) {
                [publications addObject:obj];
            }
        }];
        return [publications copy];
    }
}

-(NSArray<SKWSubscription*>* _Nonnull)subscriptions {
    @synchronized (mutableSubscriptions) {
        NSMutableArray<SKWSubscription*>* subscriptions = [[NSMutableArray alloc] init];
        [mutableSubscriptions enumerateObjectsUsingBlock:^(SKWSubscription * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(obj.state != SKWSubscriptionStateCanceled) {
                [subscriptions addObject:obj];
            }
        }];
        return [subscriptions copy];
    }
}


-(SKWMember* _Nullable)findMemberByMemberID:(const std::string&)memberID{
    SKWMember* member;
    @synchronized(mutableMembers) {
        NSString* identifier = [NSString stringForStdString:memberID];
        NSUInteger idx = [mutableMembers indexOfObjectPassingTest:^BOOL(SKWMember * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return [obj.id isEqualToString:identifier];
        }];
        if(idx != NSNotFound) {
            member = mutableMembers[idx];
        }
    }
    
    return member;
}

-(SKWPublication* _Nullable)findPublicationByPublicationID:(const std::string&)publicationID{
    SKWPublication* publication;
    @synchronized(mutablePublications) {
        NSString* identifier = [NSString stringForStdString:publicationID];
        NSUInteger idx = [mutablePublications indexOfObjectPassingTest:^BOOL(SKWPublication * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return [obj.id isEqualToString:identifier];
        }];
        if(idx != NSNotFound) {
            publication = mutablePublications[idx];
        }
    }
    return publication;
}

-(SKWSubscription* _Nullable)findSubscriptionBySubscriptionID:(const std::string&)subscriptionID{
    SKWSubscription* subscription;
    @synchronized(mutableSubscriptions) {
        NSString* identifier = [NSString stringForStdString:subscriptionID];
        NSUInteger idx = [mutableSubscriptions indexOfObjectPassingTest:^BOOL(SKWSubscription * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return [obj.id isEqualToString:identifier];
        }];
        if(idx != NSNotFound) {
            subscription = mutableSubscriptions[idx];
        }
    }
    return subscription;
}


-(SKWMember* _Nonnull)registerMemberIfNeeded:(NativeMemberInterface* _Nonnull)nativeMember{
    SKWMember* member;
    @synchronized(mutableMembers) {
        if(id existingMember = [self findMemberByMemberID:nativeMember->Id()]) {
            return existingMember;
        }
        
        member = [self createMemberForNative:nativeMember];
        [mutableMembers addObject:member];
    }

    return member;
}

-(SKWPublication* _Nonnull)registerPublicationIfNeeded:(NativePublicationInterface* _Nonnull)nativePublication{
    SKWPublication* publication;
    @synchronized (mutablePublications) {
        if(id existingPublication = [self findPublicationByPublicationID:nativePublication->Id()]) {
            return existingPublication;
        }
        
        publication = [self createPublicationForNative:nativePublication];
        [mutablePublications addObject:publication];
    }

    return publication;
}

-(SKWSubscription* _Nonnull)registerSubscriptionIfNeeded:(NativeSubscriptionInterface* _Nonnull)nativeSubscription{
    SKWSubscription* subscription;
    @synchronized (mutableSubscriptions) {
        if(id existingSubscription = [self findSubscriptionBySubscriptionID:nativeSubscription->Id()]) {
            return existingSubscription;
        }
        
        subscription = [self createSubscriptionForNative:nativeSubscription];
        [mutableSubscriptions addObject:subscription];
    }
    return subscription;
}

-(NSArray<SKWPublication*>* _Nonnull)getActivePublicationsByPublisherID:(NSString* _Nonnull)publisherID{
    NSMutableArray<SKWPublication*>* publications = [[NSMutableArray alloc] init];
    @synchronized(mutablePublications) {
        [self.publications enumerateObjectsUsingBlock:^(SKWPublication * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([obj.publisher.id isEqualToString:publisherID]){
                [publications addObject:obj];
            }
        }];
    }
    return [publications copy];
}

-(NSArray<SKWSubscription*>* _Nonnull)getActiveSubscriptionsBySubscriberID:(NSString* _Nonnull)subscriberID{
    NSMutableArray<SKWSubscription*>* subscriptions = [[NSMutableArray alloc] init];
    @synchronized(mutableSubscriptions) {
        [self.subscriptions enumerateObjectsUsingBlock:^(SKWSubscription * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([obj.subscriber.id isEqualToString:subscriberID]){
                [subscriptions addObject:obj];
            }
        }];
    }

    return [subscriptions copy];
}

-(NSArray<SKWSubscription*>* _Nonnull)getActiveSubscriptionsByPublicationID:(NSString* _Nonnull)publicationID{
    NSMutableArray<SKWSubscription*>* subscriptions = [[NSMutableArray alloc] init];
    @synchronized(mutableSubscriptions) {
        [self.subscriptions enumerateObjectsUsingBlock:^(SKWSubscription * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([obj.publication.id isEqualToString:publicationID]){
                [subscriptions addObject:obj];
            }
        }];
    }
    return [subscriptions copy];
}

-(SKWMember* _Nullable)createMemberForNative:(NativeMemberInterface* _Nonnull)native{
    if(auto localPerson = dynamic_cast<NativeLocalPerson*>(native)) {
        return [[SKWLocalPerson alloc] initWithNativePerson:localPerson repository:self];
    }
    __block SKWPlugin* plugin = nil;
    [SKWContext.plugins enumerateObjectsUsingBlock:^(SKWPlugin * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj.subtype isEqualToString:[NSString stringForStdString:native->Subtype()]]) {
            plugin = obj;
            *stop = YES;
        }
    }];
    if(auto nativeRemoteMember = dynamic_cast<NativeRemoteMember*>(native)) {
        return [plugin createRemoteMemberWithNative:nativeRemoteMember repository:self];
    }
    
    return nil;
}

-(SKWPublication* _Nonnull)createPublicationForNative:(NativePublication* _Nonnull)native{
    return [[SKWPublication alloc] initWithNative:native repository:self];
}

-(SKWSubscription* _Nonnull)createSubscriptionForNative:(NativeSubscription* _Nonnull)native{
    return [[SKWSubscription alloc] initWithNative:native repository:self];
}

@end
