//
//  SKWPublication_h
//  SkyWay
//
//  Created by sandabu on 2022/03/08.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWPublication_h
#define SKWPublication_h

#import "SKWCodec.h"
#import "SKWEncoding.h"
#import "SKWLocalStream.h"
#import "SKWMember.h"
#import "SKWSubscription.h"
#import "Type.h"

typedef NS_ENUM(NSUInteger, SKWPublicationState) {
    SKWPublicationStateEnabled,
    SKWPublicationStateDisabled,
    SKWPublicationStateCanceled,
} NS_SWIFT_NAME(PublicationState);

/// Publication
///
/// PublicationはLocalMemberがPublishした時に取得でき、Roomに参加している他クライアント(RemoteMember)がSubscribeされると通信を行います。
///
/// Roomなどから他の人のPublicationも取得することはできますが、その場合Streamは含まれません。
NS_SWIFT_NAME(Publication)
@interface SKWPublication : NSObject

typedef void (^SKWPublicationUpdateMetadataCompletion)(NSError* _Nullable error);
typedef void (^SKWPublicationCancelCompletion)(NSError* _Nullable error);
typedef void (^SKWPublicationEnableCompletion)(NSError* _Nullable error);
typedef void (^SKWPublicationDisableCompletion)(NSError* _Nullable error);

/// Publicationを識別するためのID
@property(nonatomic, readonly) NSString* _Nonnull id;
/// このPublicationを生成したMember
@property(nonatomic, readonly) SKWMember* _Nullable publisher;
/// このPublicationに紐づくSubscription一覧
@property(nonatomic, readonly) NSArray<SKWSubscription*>* _Nonnull subscriptions;
/// PublishしているStreamのコンテントタイプ
@property(nonatomic, readonly) SKWContentType contentType;
/// メタデータ
@property(nonatomic, readonly) NSString* _Nullable metadata;
/// コーデック指定
@property(nonatomic, readonly) NSArray<SKWCodec*>* _Nonnull codecCapabilities;
/// エンコーディング設定
@property(nonatomic, readonly) NSArray<SKWEncoding*>* _Nonnull encodings;
/// ステート
///
/// Canceledの場合、このオブジェクトの操作は無効です。
@property(nonatomic, readonly) SKWPublicationState state;
/// このPublicationに紐づくStream
///
/// LocalRoomMemberがPublishした時に得られるPublicationのみセットされます。
@property(nonatomic, readonly) SKWLocalStream* _Nullable stream;
@property(nonatomic, readonly) SKWPublication* _Nullable origin;

- (id _Nonnull)init NS_UNAVAILABLE;

/// メタデータを更新します。
///
/// @param metadata メタデータ
/// @param completion 完了コールバック
- (void)updateMetadata:(NSString* _Nonnull)metadata
            completion:(SKWPublicationUpdateMetadataCompletion _Nullable)completion;

/// Publishを中止します
/// @param completion 完了コールバック
- (void)cancelWithCompletion:(SKWPublicationCancelCompletion _Nullable)completion;

/// Publicationを有効状態にします。
///
/// このAPIはLocalPublicationのみ機能します。
///
/// 既に有効状態の場合は何もしません。
/// @param completion 完了コールバック
- (void)enableWithCompletion:(SKWPublicationEnableCompletion _Nullable)completion;

/// Publicationを無効状態にします。
///
/// 既に無効状態の場合は何もしません。
/// @param completion 完了コールバック
- (void)disableWithCompletion:(SKWPublicationDisableCompletion _Nullable)completion;

- (SKWWebRTCStats* _Nullable)getStatsWithMemberId:(NSString* _Nonnull)memberId
    NS_SWIFT_NAME(getStats(withMemberId:))
        __attribute__((deprecated("SkyWayCore v2.0.0で非推奨となりました。")));

/// エンコーディング設定を更新します。
///
/// 更新はLocalRoomMemberのPublishしたPublicationのみ有効で、ContentTypeがAudioまたはVideoの時のみ更新ができます。
///
/// Publish時に設定したエンコーディングの数と一致している必要があります。
///
/// IDの変更は行えません。
- (void)updateEncodings:(NSArray<SKWEncoding*>* _Nonnull)encodings;

/// 送信するストリームを切り替えます。
///
/// このAPIはLocalPersonがPublishしたPublication(Streamがnilではない)のみ操作可能で、切り替え前と同じContentTypeである必要があります。
///
/// DataStreamを入れ替えることはできません。
/// @param stream ストリーム
- (void)replaceStream:(SKWLocalStream* _Nonnull)stream;

@end

/// Publicationイベントデリゲート
NS_SWIFT_NAME(PublicationDelegate)
@protocol SKWPublicationDelegate <NSObject>
@optional
/// このPublicationが中止された時に発生するイベント
///
/// @param publication Publication
- (void)publicationUnpublished:(SKWPublication* _Nonnull)publication;

/// このPublicationがSubscribeされた時に発生するイベント
///
/// @param publication Publication
/// @param subscription Subscription
/// LocalPersonによるSubscribeである場合、まだstreamがsetされていない可能性があります。
- (void)publication:(SKWPublication* _Nonnull)publication
         subscribed:(SKWSubscription* _Nonnull)subscription;

/// このPublicationがUnsubscribeされた時に発生するイベント
///
/// @param publication Publication
/// @param subscription Subscription
- (void)publication:(SKWPublication* _Nonnull)publication
       unsubscribed:(SKWSubscription* _Nonnull)subscription;
/// このPublicationのSubscribeされている数が変化した時に発生するイベント
///
/// @param publication Publication
- (void)publicationSubscriptionListDidChange:(SKWPublication* _Nonnull)publication;

/// このPublicationのMetadataが更新された時に発生するイベント
///
/// @param publication Publication
/// @param metadata Metadata
- (void)publication:(SKWPublication* _Nonnull)publication
    didUpdateMetadata:(NSString* _Nonnull)metadata;

/// このPublicationが有効状態に変化した時に発生するイベント
/// @param publication Publication
- (void)publicationEnabled:(SKWPublication* _Nonnull)publication;

/// このPublicationが無効状態に変化した時に発生するイベント
/// @param publication Publication
- (void)publicationDisabled:(SKWPublication* _Nonnull)publication;

/// このPublicationのステートが変化した時に発生するイベント
/// @param publication Publication
- (void)publicationStateDidChange:(SKWPublication* _Nonnull)publication;

/// このPublicationの接続状態が変化したときに発生するイベント
/// @param publication Publication
/// @param connectionState newState
- (void)publication:(SKWPublication* _Nonnull)publication
    connectionStateDidChange:(SKWConnectionState)connectionState;
@end

@interface SKWPublication ()

/// イベントデリゲート
@property(weak, nonatomic) id<SKWPublicationDelegate> _Nullable delegate;

@end

#endif /* SKWPublication_h */
