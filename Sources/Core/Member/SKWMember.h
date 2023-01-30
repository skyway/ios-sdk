//
//  SKWMember_h
//  SkyWay
//
//  Created by sandabu on 2022/02/04.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWMember_h
#define SKWMember_h

#import "Foundation/Foundation.h"
#import "Type.h"

typedef NS_ENUM(NSUInteger, SKWMemberState) {
    SKWMemberStateJoined,
    SKWMemberStateLeft,
} NS_SWIFT_NAME(MemberState);

@class SKWPublication;
@class SKWSubscription;

NS_SWIFT_NAME(Member)
@interface SKWMember: NSObject

typedef void (^SKWMemberUpdateMetadataCompletion)(NSError* _Nullable);
typedef void (^SKWMemberLeaveCompletion)(NSError* _Nullable);

@property(nonatomic, readonly) NSString* _Nonnull id;
@property(nonatomic, readonly) NSString* _Nullable name;
@property(nonatomic, readonly) NSString* _Nullable metadata;
@property(nonatomic, readonly) SKWMemberType type;
@property(nonatomic, readonly) SKWSide side;
@property(nonatomic, readonly) NSString* _Nonnull subtype;
@property(nonatomic, readonly) SKWMemberState state;
@property(nonatomic, readonly) NSArray<SKWPublication*>* _Nonnull publications;
@property(nonatomic, readonly) NSArray<SKWSubscription*>* _Nonnull subscriptions;

-(void)updateMetadata:(NSString* _Nonnull)metadata completion:(SKWMemberUpdateMetadataCompletion _Nullable)completion;
-(void)leaveWithCompletion:(SKWMemberLeaveCompletion _Nullable)completion;

@end

/// Memberイベントデリゲート
NS_SWIFT_NAME(MemberDelegate)
@protocol SKWMemberDelegate <NSObject>
@optional
/// MemberがChannelから退出した時にコールされます。
/// - Parameter member: Member
-(void)memberDidLeave:(SKWMember* _Nonnull)member;

/// Memberのメタデータが更新された時にコールされます。
/// - Parameters:
///   - member: Member
///   - metatada: 更新後のMetada
-(void)member:(SKWMember* _Nonnull)member didUpdateMetadata:(NSString* _Nonnull)metatada;


/// MemberがPublishしているStreamの数が変化した時にコールされます。
/// - Parameter member: Member
-(void)memberPublicationListDidChange:(SKWMember* _Nonnull)member;


/// MemberがSubscribeしているStreamの数が変化した時にコールされます。
/// - Parameter member: Member
-(void)memberSubscriptionListDidChange:(SKWMember* _Nonnull)member;
@end



#endif /* SKWMember_h */
