//
//  SKWSubscription_h
//  SkyWay
//
//  Created by sandabu on 2022/03/08.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWSubscription_h
#define SKWSubscription_h

#import "SKWMember.h"
#import "SKWRemoteStream.h"
#import "SKWWebRTCStats.h"
#import "Type.h"

/// Subscriptionの状態
typedef NS_ENUM(NSUInteger, SKWSubscriptionState) {
    /// 有効状態
    SKWSubscriptionStateEnabled,
    /// Subscribe停止(unsubscribe)状態
    SKWSubscriptionStateCanceled,
} NS_SWIFT_NAME(SubscriptionState);

@class SKWPublication;

/// SubscriptionはLocalMemberがSubscribeした時に取得でき、Subscriptionに含まれるStreamを利用して映像を描画したりします。
///
/// Channelなどから他の人のSubscriptionも取得することはできますが、その場合Streamは含まれません。
NS_SWIFT_NAME(Subscription)
@interface SKWSubscription : NSObject

typedef void (^SKWSubscriptionCancelCompletion)(NSError* _Nullable error);

/// Subscriptionを識別するID
@property(nonatomic, readonly) NSString* _Nonnull id;
/// このSubscriptionに紐づくStreamのContentType
@property(nonatomic, readonly) SKWContentType contentType;
/// SubscribeしているPublication
@property(nonatomic, readonly) SKWPublication* _Nullable publication;
/// SubscribeしているMember
@property(nonatomic, readonly) SKWMember* _Nullable subscriber;
/// ステート
///
/// Canceledの場合、このオブジェクトの操作は無効です。
@property(nonatomic, readonly) SKWSubscriptionState state;
/// このSubscriptionに紐づくStream
///
/// LocalPersonがSubscribeし、成功した時の返り値または完了コールバックで得られるSubscriptionにおいては値がSetされていることが保証されています。
///
/// その他、イベントによってSubscriptionを取得した場合、まだ値がSetされていない可能性があります。
@property(nonatomic, readonly) SKWRemoteStream* _Nullable stream;
/// 優先エンコーディング設定
@property(nonatomic, readonly) NSString* _Nullable preferredEncodingId;

- (id _Nonnull)init NS_UNAVAILABLE;

/// Simulcastで利用するPreferredEncodingIDを変更します。
///
/// LocalRoomMemberがSFU bot
/// がforwardingしたPublicationをSubscribeした時のSubscriptionで、ContentTypeがAudioまたはVideoの時のみ変更ができます。
- (void)changePreferredEncodingWithEncodingId:(NSString* _Nonnull)encodingId;

///  Subscribeを中止します。
///
/// @param completion 完了コールバック
- (void)cancelWithCompletion:(SKWSubscriptionCancelCompletion _Nullable)completion
    __attribute__((deprecated("SkyWayCore v2.0.7で非推奨となりました。")));

- (SKWWebRTCStats* _Nullable)getStats
    __attribute__((deprecated("SkyWayCore v2.0.0で非推奨となりました。")));

@end

NS_SWIFT_NAME(SubscriptionDelegate)
@protocol SKWSubscriptionDelegate <NSObject>
@optional

/// RoomSubscriptionがUnsubscribeされCanceled状態に変化した後にコールされます。
/// @param subscription Subscription
- (void)subscriptionCanceled:(SKWSubscription* _Nonnull)subscription
    __attribute__((deprecated("SkyWayCore v2.0.7で非推奨となりました。")));

/// RoomSubscriptionの接続状態が変化した後にコールされるイベント
///
/// @param subscription Subscription
/// @param connectionState 接続状態
- (void)subscription:(SKWSubscription* _Nonnull)subscription
    connectionStateDidChange:(SKWConnectionState)connectionState;
@end

@interface SKWSubscription ()

@property(weak, nonatomic) id<SKWSubscriptionDelegate> _Nullable delegate;

@end

#endif /* SKWSubscription_h */
