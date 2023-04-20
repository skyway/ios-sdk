//
//  SKWPublication_h
//  SkyWay
//
//  Created by sandabu on 2022/03/08.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWPublication_h
#define SKWPublication_h

#import "SKWLocalStream.h"
#import "SKWMember.h"
#import "SKWSubscription.h"
#import "SKWCodec.h"
#import "SKWEncoding.h"
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

-(id _Nonnull)init NS_UNAVAILABLE;

/// メタデータを更新します。
/// - Parameters:
///   - metadata: メタデータ
///   - completion: 完了コールバック
-(void)updateMetadata:(NSString* _Nonnull)metadata completion:(SKWPublicationUpdateMetadataCompletion _Nullable)completion;


/// Publishを中止します
/// - Parameter completion: 完了コールバック
-(void)cancelWithCompletion:(SKWPublicationCancelCompletion _Nullable)completion;

/// Publicationを有効状態にします。
///
/// このAPIはLocalPublicationのみ機能します。
///
/// 既に有効状態の場合は何もしません。
/// - Parameter completion: 完了コールバック
-(void)enableWithCompletion:(SKWPublicationEnableCompletion _Nullable)completion;


/// Publicationを無効状態にします。
///
/// 既に無効状態の場合は何もしません。
/// - Parameter completion: 完了コールバック
-(void)disableWithCompletion:(SKWPublicationDisableCompletion _Nullable)completion;


/// [Experimental API]
/// 
/// 試験的なAPIです。今後インターフェースや仕様が変更される可能性があります。
///
/// 通信中の統計情報を取得します。
///
/// 併せて公式サイトの通信状態の統計的分析もご確認ください。
/// https://skyway.ntt.com/ja/docs/user-guide/tips/getstats/
/// - Parameter memberId: 通信相手のMemberID
-(SKWWebRTCStats* _Nullable)getStatsWithMemberId:(NSString* _Nonnull)memberId
NS_SWIFT_NAME(getStats(withMemberId:));

/// エンコーディング設定を更新します。
///
/// 更新はLocalRoomMemberのPublishしたPublicationのみ有効で、ContentTypeがAudioまたはVideoの時のみ更新ができます。
///
/// Publish時に設定したエンコーディングの数と一致している必要があります。
///
/// IDの変更は行えません。
-(void)updateEncodings:(NSArray<SKWEncoding*>* _Nonnull)encodings;

/// 送信するストリームを切り替えます。
///
/// このAPIはLocalPersonがPublishしたPublication(Streamがnilではない)のみ操作可能で、切り替え前と同じContentTypeである必要があります。
///
/// DataStreamを入れ替えることはできません。
/// - Parameter stream: ストリーム
-(void)replaceStream:(SKWLocalStream* _Nonnull)stream;

@end

/// Publicationイベントデリゲート
NS_SWIFT_NAME(PublicationDelegate)
@protocol SKWPublicationDelegate <NSObject>
@optional
/// このPublicationが中止された時に発生するイベント
///
/// - Parameter publication: Publication
-(void)publicationUnpublished:(SKWPublication* _Nonnull)publication;
/// このPublicationがSubscribeされた時に発生するイベント
///
/// - Parameter publication: Publication
-(void)publicationSubscribed:(SKWPublication* _Nonnull)publication;
/// このPublicationがUnsubscribeされた時に発生するイベント
///
/// - Parameter publication: Publication
-(void)publicationUnsubscribed:(SKWPublication* _Nonnull)publication;
/// このPublicationのSubscribeされている数が変化した時に発生するイベント
///
/// - Parameter publication: Publication
-(void)publicationSubscriptionListDidChange:(SKWPublication* _Nonnull)publication;

/// このPublicationのMetadataが更新された時に発生するイベント
/// - Parameters:
///   - publication: Publication
///   - metadata: Metadata
-(void)publication:(SKWPublication* _Nonnull)publication didUpdateMetadata:(NSString* _Nonnull)metadata;

/// このPublicationが有効状態に変化した時に発生するイベント
/// - Parameter publication: Publication
-(void)publicationEnabled:(SKWPublication* _Nonnull)publication;

/// このPublicationが無効状態に変化した時に発生するイベント
/// - Parameter publication: Publication
-(void)publicationDisabled:(SKWPublication* _Nonnull)publication;

/// このPublicationのステートが変化した時に発生するイベント
/// - Parameter publication: Publication
-(void)publicationStateDidChange:(SKWPublication* _Nonnull)publication;
@end

@interface SKWPublication()

/// イベントデリゲート
@property (weak, nonatomic) id<SKWPublicationDelegate> _Nullable delegate;

@end

#endif /* SKWPublication_h */
