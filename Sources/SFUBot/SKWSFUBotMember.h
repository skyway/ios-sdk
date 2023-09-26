//
//  SKWSFUBotMember_h
//  SkyWay
//
//  Created by sandabu on 2022/03/23.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWSFUBotMember_h
#define SKWSFUBotMember_h

#import <SkyWayCore/SkyWayCore.h>

#import "SKWForwarding.h"

/// SFU Bot
///
/// すでに存在するPublicationをフォワードし、それをSubscribeすることでSFUサーバ経由での通信ができます。
NS_SWIFT_NAME(SFUBotMember)
@interface SKWSFUBotMember : SKWRemoteMember

typedef void (^SKWSFUBotMemberStartForwardingPublicationCompletion)(SKWForwarding* _Nullable,
                                                                    NSError* _Nullable error);

/// フォワーディング一覧
@property(nonatomic, readonly) NSArray<SKWForwarding*>* _Nonnull forwardings;

/// Publicationをフォワードさせます。
///
/// コーデック指定(`codecCapabilities`)のあるPublicationはサポートされていないので失敗します。
///
/// また、maxFramerateを複数設定したPublicationのForwarding(サイマルキャスト)は利用できません。
///
/// - Parameters:
///   - publication: Publication
///   - configure: コンフィグオプション
///   - completion: 完了コールバック
- (void)startForwardingPublication:(SKWPublication* _Nonnull)publication
                     withConfigure:(SKWForwardingConfigure* _Nullable)configure
                        completion:(SKWSFUBotMemberStartForwardingPublicationCompletion _Nullable)
                                       completion
    NS_SWIFT_NAME(startForwarding(_:configure:completion:));
@end

/// イベントデリゲート
NS_SWIFT_NAME(SFUBotMemberDelegate)
@protocol SKWSFUBotMemberDelegate <SKWMemberDelegate>
@optional
// TODO: Impl these after libskyway is ready.
//-(void)bot:(SKWSFUBotMember* _Nonnull)bot didStartForwarding:(SKWForwarding* _Nonnull)forwarding;
//-(void)bot:(SKWSFUBotMember* _Nonnull)bot didStopForwarding:(SKWForwarding* _Nonnull)forwarding;
//-(void)botForwardingListChanged:(SKWSFUBotMember* _Nonnull)bot;
@end

@interface SKWSFUBotMember ()

/// イベントデリゲート
@property(nonatomic, weak) id<SKWSFUBotMemberDelegate> _Nullable delegate;

@end

#endif /* SKWSFUBotMember_h */
