//
//  SKWChannel_h
//  SkyWay
//
//  Created by sandabu on 2022/02/04.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWChannel_h
#define SKWChannel_h

#import <Foundation/Foundation.h>
#import "SKWLocalPerson.h"
#import "SKWPublication.h"
#import "SKWRemoteMember.h"
#import "SKWSubscription.h"

/// Channel初期化オプション
NS_SWIFT_NAME(ChannelInit)
@interface SKWChannelInit : NSObject
/// Channel名
@property NSString* _Nullable name;
/// Channelのメタデータ
@property NSString* _Nullable metadata;

@end

/// Channel検索クエリ
NS_SWIFT_NAME(ChannelQuery)
@interface SKWChannelQuery : NSObject
/// チャンネル名
@property NSString* _Nullable name;

/// チャンネルID
@property NSString* _Nullable id;

@end

/// Member初期化オプション
NS_SWIFT_NAME(MemberInit)
@interface SKWMemberInit : NSObject
/// Member名
@property NSString* _Nullable name;
/// Memberのメタデータ
@property NSString* _Nullable metadata;
/// MemberのKeepAliveの更新間隔時間
@property int keepaliveIntervalSec;
/// MemberのKeepAliveの更新間隔時間を超えてChannelからMemberが削除されるまでの時間
@property int keepaliveIntervalGapSec;

@end

/// チャンネルの状態
typedef NS_ENUM(NSUInteger, SKWChannelState) {
    /// 利用可能状態
    Opened,
    /// 利用不可能状態
    Closed,
} NS_SWIFT_NAME(ChannelState);

/// チャンネル
NS_SWIFT_NAME(Channel)
@interface SKWChannel : NSObject

/// Channel識別子
@property(nonatomic, readonly) NSString* _Nonnull id;

/// Channelの名前
@property(nonatomic, readonly) NSString* _Nullable name;

/// Channelに付与されているメタデータ
@property(nonatomic, readonly) NSString* _Nullable metadata;

/// ChannelインスタンスにこのSDKから参加したLocalPerson
///
/// LocalPersonは1Channelインスタンスに一人しか参加できません。
@property(nonatomic, readonly) SKWLocalPerson* _Nullable localPerson;

/// Channelに参加しているBotの一覧
@property(nonatomic, readonly) NSArray<SKWRemoteMember*>* _Nonnull bots;

/// Channelに参加しているMemberの一覧
///
/// LocalPersonも含まれます。
@property(nonatomic, readonly) NSArray<SKWMember*>* _Nonnull members;

/// Channelに紐づく全てのPublicationの一覧
@property(nonatomic, readonly) NSArray<SKWPublication*>* _Nonnull publications;

/// Channelに紐づく全てのSubscriptionの一覧
@property(nonatomic, readonly) NSArray<SKWSubscription*>* _Nonnull subscriptions;

/// Channelの状態
///
/// 一度Closed状態になった場合、Channelの操作はできません。
@property(nonatomic, readonly) SKWChannelState state;

typedef void (^SKWChannelCompletion)(SKWChannel* _Nullable, NSError* _Nullable);
typedef void (^SKWChannelJoinCompletion)(SKWLocalPerson* _Nullable, NSError* _Nullable);
typedef void (^SKWChannelUpdateMetadataCompletion)(NSError* _Nullable);
typedef void (^SKWChannelLeaveMemberCompletion)(NSError* _Nullable);
typedef void (^SKWChannelCloseCompletion)(NSError* _Nullable);
typedef void (^SKWChannelDisposeCompletion)(NSError* _Nullable);

- (id _Nonnull)init NS_UNAVAILABLE;

/// クエリからChannelを検索します。
///
/// @param query 検索クエリ
/// @param completion 完了コールバック
+ (void)findWithQuery:(SKWChannelQuery* _Nonnull)query
           completion:(SKWChannelCompletion _Nullable)completion;

/// Channelを新規作成します。
///
/// @param init 初期化オプション
/// @param completion 完了コールバック
+ (void)createWithInit:(SKWChannelInit* _Nullable)init
            completion:(SKWChannelCompletion _Nullable)completion;

/// Channelを名前から検索し、存在しない場合は新規作成します。
///
/// @param init 検索・初期化オプション
/// @param completion 完了コールバック
+ (void)findOrCreateWithInit:(SKWChannelInit* _Nonnull)init
                  completion:(SKWChannelCompletion _Nullable)completion;

/// Channelに参加し、LocalPersonを作成します。
///
/// @param init LocalPerson初期化オプション
/// @param completion 完了コールバック
- (void)joinWithInit:(SKWMemberInit* _Nullable)init
          completion:(SKWChannelJoinCompletion _Nullable)completion;

/// メタデータを更新します。
///
/// @param metadata メタデータ
/// @param completion 完了コールバック
- (void)updateMetadata:(NSString* _Nonnull)metadata
            completion:(SKWChannelUpdateMetadataCompletion _Nullable)completion;

/// ChannelからMemberを退出させます。
///
/// 認可されていれば自分自身(LocalPerson)だけでなく、RemoteMemberも退出させることができます。
/// @param member 退出させるMember
/// @param completion 完了コールバック
- (void)leaveMember:(SKWMember* _Nonnull)member
         completion:(SKWChannelLeaveMemberCompletion _Nullable)completion;

/// Channelを閉じます。
///
/// `dispose(completion:)`とは異なり、Channelを閉じると参加しているMemberは全て退出し、Channelは破棄されます。
///
/// 入室している全てのMemberがPublishとSubscribeをしている場合は中止してから退出します。
///
/// Close後のChannelインスタンスおよび、Channelで生成されたMember, Publication,
/// Subscriptionインスタンスは利用できません。
///
/// @param completion 完了コールバック
- (void)closeWithCompletion:(SKWChannelCloseCompletion _Nullable)completion;

/// Channelを閉じずにChannelインスタンスを無効にし、非同期的にリソースを解放します。
///
/// `close(completion:)`とは異なり、サーバ上でのChannel破棄しないため入室しているMemberには影響しません。
///
/// Dispose完了後のChannelインスタンスおよび、Channelで生成されたMember, Publication,
/// Subscriptionインスタンスは利用できません。
- (void)disposeWithCompletion:(SKWChannelDisposeCompletion _Nullable)completion;

@end

/// Channelイベントデリゲート
NS_SWIFT_NAME(ChannelDelegate)
@protocol SKWChannelDelegate <NSObject>
@optional

/// このChannelが閉じられた時に発生するイベント
///
/// @param channel Channel
- (void)channelDidClose:(SKWChannel* _Nonnull)channel;

/// このChannelのMetadataが更新された時に発生するイベント
///
/// @param channel Channel
/// @param metadata Metadata
- (void)channel:(SKWChannel* _Nonnull)channel didUpdateMetadata:(NSString* _Nonnull)metadata;

/// このChannelに参加しているMemberの数が変化した時に発生するイベント
///
/// `channel(_:memberDidJoin:)`または`channel(_:memberDidLeave:)`がコールされた後にコールされます。
///
/// @param channel Channel
- (void)channelMemberListDidChange:(SKWChannel* _Nonnull)channel;

/// ChannelにMemberが参加した時に発生するイベント
///
/// @param channel Channel
/// @param member 参加したMember
- (void)channel:(SKWChannel* _Nonnull)channel memberDidJoin:(SKWMember* _Nonnull)member;

/// ChannelからMemberが退出した時に発生するイベント
///
/// @param channel Channel
/// @param member 退出したMember
- (void)channel:(SKWChannel* _Nonnull)channel memberDidLeave:(SKWMember* _Nonnull)member;

/// このChannelのMemberのMetadataが更新された時に発生するイベント
///
/// @param channel Channel
/// @param member 対象のMember
/// @param metadata Metadata
- (void)channel:(SKWChannel* _Nonnull)channel
               member:(SKWMember* _Nonnull)member
    metadataDidUpdate:(NSString* _Nonnull)metadata;

/// このChannelのPublicationの数が変化した時に発生するイベント
///
/// `channel(_:didPublishStreamOfPublication:)`または`channel(_:didUnpublishStreamOfPublication:)`がコールされた後にコールされます。
///
/// @param channel Channel
- (void)channelPublicationListDidChange:(SKWChannel* _Nonnull)channel;

/// このChannelにStreamがPublishされた時に発生するイベント
///
/// @param channel Channel
/// @param publication 対象のPublication
- (void)channel:(SKWChannel* _Nonnull)channel
    didPublishStreamOfPublication:(SKWPublication* _Nonnull)publication;

/// このChannelにStreamがUnpublishされた時に発生するイベント
///
/// @param channel Channel
/// @param publication 対象のPublication
- (void)channel:(SKWChannel* _Nonnull)channel
    didUnpublishStreamOfPublication:(SKWPublication* _Nonnull)publication;

/// このChannelのPublicationが`Enabled`状態に変更された時に発生するイベント
///
/// @param channel Channel
/// @param publication 対象のPublication
- (void)channel:(SKWChannel* _Nonnull)channel
    publicationDidChangeToEnabled:(SKWPublication* _Nonnull)publication;

/// このChannelのPublicationが`Disabled`状態に変更された時に発生するイベント
///
/// @param channel Channel
/// @param publication 対象のPublication
- (void)channel:(SKWChannel* _Nonnull)channel
    publicationDidChangeToDisabled:(SKWPublication* _Nonnull)publication;

/// このChannelのPublicationのMetadataが更新された時に発生するイベント
///
/// @param channel Channel
/// @param publication 対象のPublication
/// @param metadata Metadata
- (void)channel:(SKWChannel* _Nonnull)channel
          publication:(SKWPublication* _Nonnull)publication
    metadataDidUpdate:(NSString* _Nonnull)metadata;

/// StreamがSubscribeまたはUnsubscribeされた時に発生するイベント
///
/// `channel(_:didSubscribeStreamOf:)`または`channel(_:UnsubscribeStreamOf:)`がコールされた後にコールされます。
/// @param channel Channel
- (void)channelSubscriptionListDidChange:(SKWChannel* _Nonnull)channel;

/// StreamがSubscribeされた時に発生するイベント
///
/// @param channel Channel
/// @param subscription 対象のSubscription
/// LocalPersonによるSubscribeである場合、まだstreamがsetされていない可能性があります。
- (void)channel:(SKWChannel* _Nonnull)channel
    didSubscribePublicationOfSubscription:(SKWSubscription* _Nonnull)subscription;

/// StreamがUnsubscribeされた時に発生するイベント
///
/// @param channel Channel
/// @param subscription 対象のSubscription
- (void)channel:(SKWChannel* _Nonnull)channel
    didUnsubscribePublicationOfSubscription:(SKWSubscription* _Nonnull)subscription;
@end

@interface SKWChannel ()

/// イベントデリゲート
@property(weak, nonatomic) id<SKWChannelDelegate> _Nullable delegate;

@end

#endif /* SKWChannel_h */
