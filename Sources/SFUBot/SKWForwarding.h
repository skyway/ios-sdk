//
//  SKWForwarding_h
//  SkyWay
//
//  Created by sandabu on 2022/03/23.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWForwarding_h
#define SKWForwarding_h

#import <SkyWayCore/SkyWayCore.h>

/// フォワーディング状態
typedef NS_ENUM(NSUInteger, SKWForwardingState) {
    /// フォワード状態
    SKWForwardingStateStarted,
    /// フォワード停止状態
    SKWForwardingStateStopped,
} NS_SWIFT_NAME(ForwardingState);

/// フォワードコンフィグ
NS_SWIFT_NAME(ForwardingConfigure)
@interface SKWForwardingConfigure : NSObject

/// フォワードしたPublicationをSubscribeできる最大人数
///
/// デフォルトは10人で、最大値は99です。詳しくはこちらをご覧ください。
///
/// https://skyway.ntt.com/ja/docs/user-guide/sfu/
@property(nonatomic) int maxSubscribers;

@end

/// フォワーディング
///
/// Botがフォワードした時に取得できます。
@interface SKWForwarding : NSObject

/// Forwarding識別子
///
/// RelayingPublicationのidと同じです。
@property(nonatomic, readonly) NSString* _Nonnull identifier;

/// Forwardingの状態
@property(nonatomic, readonly) SKWForwardingState state;

/// コンフィグ
@property(nonatomic, readonly) SKWForwardingConfigure* _Nonnull configure;

/// Forwarding対象(オリジナル)のPublication
@property(nonatomic, readonly) SKWPublication* _Nonnull originPublication;

/// Forwardingを表すPublication
@property(nonatomic, readonly) SKWPublication* _Nonnull relayingPublication;

- (id _Nonnull)init NS_UNAVAILABLE;

@end

@protocol SKWForwardingDelegate <NSObject>
@optional
- (void)forwardingDidStop:(SKWForwarding* _Nonnull)forwarding;
@end

@interface SKWForwarding ()

@property(weak, nonatomic) id<SKWForwardingDelegate> _Nullable delegate;

@end

#endif /* SKWForwarding_h */
