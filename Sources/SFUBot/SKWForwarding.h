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
@interface SKWForwardingConfigure: NSObject

/// フォワードしたPublicationをSubscribeできる最大人数
///
/// デフォルトは4人です。
@property(nonatomic) int maxSubscribers;

@end


/// フォワーディング
///
/// Botがフォワードした時に取得できます。
@interface SKWForwarding : NSObject


@property(nonatomic, readonly) NSString* _Nonnull identifier;
@property(nonatomic, readonly) SKWForwardingState state;
@property(nonatomic, readonly) SKWForwardingConfigure* _Nonnull configure;
@property(nonatomic, readonly) SKWPublication* _Nonnull originPublication;
@property(nonatomic, readonly) SKWPublication* _Nonnull relayingPublication;

-(id _Nonnull)init NS_UNAVAILABLE;

@end

@protocol SKWForwardingDelegate <NSObject>
@optional
-(void)forwardingDidStop:(SKWForwarding* _Nonnull)forwarding;
@end

@interface SKWForwarding()

@property (weak, nonatomic) id<SKWForwardingDelegate> _Nullable delegate;

@end

#endif /* SKWForwarding_h */
