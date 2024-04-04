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

/// Channelに入室しているMemberの抽象クラス
NS_SWIFT_NAME(Member)
@interface SKWMember : NSObject

typedef void (^SKWMemberUpdateMetadataCompletion)(NSError* _Nullable);
typedef void (^SKWMemberLeaveCompletion)(NSError* _Nullable);

/// Memberを識別するためのID
@property(nonatomic, readonly) NSString* _Nonnull id;
/// Memberの名前
@property(nonatomic, readonly) NSString* _Nullable name;
/// メタデータ
@property(nonatomic, readonly) NSString* _Nullable metadata;
/// メンバータイプ
@property(nonatomic, readonly) SKWMemberType type;
/// メンバーサイド
///
/// このクライアントで生成されたメンバーの場合localになります。
@property(nonatomic, readonly) SKWSide side;
/// サブタイプ
///
/// Botの種類を判別するときに利用します。
@property(nonatomic, readonly) NSString* _Nonnull subtype;
/// ステート
///
/// Leftの場合、このオブジェクトの操作は無効です。
@property(nonatomic, readonly) SKWMemberState state;
/// Publish中のPublication一覧
@property(nonatomic, readonly) NSArray<SKWPublication*>* _Nonnull publications;
/// Subscribe中のSubscription一覧
@property(nonatomic, readonly) NSArray<SKWSubscription*>* _Nonnull subscriptions;

/// メタデータを更新します。
///
/// @param metadata 更新するメタデータ
/// @param completion 完了コールバック
- (void)updateMetadata:(NSString* _Nonnull)metadata
            completion:(SKWMemberUpdateMetadataCompletion _Nullable)completion;

/// Channelから退出します。
/// @param completion 完了コールバック
- (void)leaveWithCompletion:(SKWMemberLeaveCompletion _Nullable)completion;

@end

/// Memberイベントデリゲート
NS_SWIFT_NAME(MemberDelegate)
@protocol SKWMemberDelegate <NSObject>
@optional
/// MemberがChannelから退出した時にコールされます。
/// @param member Member
- (void)memberDidLeave:(SKWMember* _Nonnull)member;

/// Memberのメタデータが更新された時にコールされます。
/// @param member Member
/// @param metatada 更新後のMetada
- (void)member:(SKWMember* _Nonnull)member didUpdateMetadata:(NSString* _Nonnull)metatada;

/// MemberがPublishしているStreamの数が変化した時にコールされます。
/// @param member Member
- (void)memberPublicationListDidChange:(SKWMember* _Nonnull)member;

/// MemberがSubscribeしているStreamの数が変化した時にコールされます。
/// @param member Member
- (void)memberSubscriptionListDidChange:(SKWMember* _Nonnull)member;
@end

#endif /* SKWMember_h */
