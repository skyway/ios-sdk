//
//  SKWLocalPerson_h
//  SkyWay
//
//  Created by sandabu on 2022/02/04.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWLocalPerson_h
#define SKWLocalPerson_h

#import "SKWLocalStream.h"
#import "SKWMember.h"
#import "SKWPublication.h"
#import "SKWPublicationOptions.h"
#import "SKWSubscription.h"
#import "SKWSubscriptionOptions.h"

/// このSDKで生成されたLocalMember
NS_SWIFT_NAME(LocalPerson)
@interface SKWLocalPerson : SKWMember

typedef void (^SKWLocalPersonPublishStreamCompletion)(SKWPublication* _Nullable,
                                                      NSError* _Nullable error);
typedef void (^SKWLocalPersonSubscribePublicationCompletion)(SKWSubscription* _Nullable,
                                                             NSError* _Nullable error);
typedef void (^SKWLocalPersonUnpublishCompletion)(NSError* _Nullable error);
typedef void (^SKWLocalPersonUnsubscribeCompletion)(NSError* _Nullable error);
typedef void (^SKWLocalPersonLeaveCompletion)(NSError* _Nullable error);

/// 入室しているChannelにStreamをPublishします。
///
/// Streamは各種Sourceから作成できます。
///
/// 同じインスタンスのStreamを複数回Publishすることはできません。必要ならば各種Sourceから再度作成してPublishしてください。
///
/// 詳しいオプションの設定例については[PublicationOptions](/core/Classes/SKWPublicationOptions.html)、開発者ドキュメントの[大規模会議アプリを実装する上での注意点](https://skyway.ntt.com/ja/docs/user-guide/tips/large-scale/)をご覧ください。
///
/// @param stream PublishするStream
/// @param options Publishオプション
/// @param completion 完了コールバック
- (void)publishStream:(SKWLocalStream* _Nonnull)stream
              options:(SKWPublicationOptions* _Nullable)options
           completion:(SKWLocalPersonPublishStreamCompletion _Nullable)completion
    NS_SWIFT_NAME(publish(_:options:completion:));

///  PublicationをSubscribeします。
///
/// @param publicationID SubscribeするPublicationのID
/// @param options Subscribeオプション
/// @param completion 完了コールバック
- (void)subscribePublicationWithPublicationID:(NSString* _Nonnull)publicationID
                                      options:(SKWSubscriptionOptions* _Nullable)options
                                   completion:
                                       (SKWLocalPersonSubscribePublicationCompletion _Nullable)
                                           completion
    NS_SWIFT_NAME(subscribePublication(publicationID:options:completion:));

/// Publishを中止します。
/// @param publicationID 中止するPublicationのID
/// @param completion 完了コールバック
- (void)unpublishWithPublicationID:(NSString* _Nonnull)publicationID
                        completion:(SKWLocalPersonUnpublishCompletion _Nullable)completion
    NS_SWIFT_NAME(unpublish(publicationID:completion:));

/// Subscribeを中止します。
/// @param subscriptionID 中止するSubscriptionのID
/// @param completion 完了コールバック
- (void)unsubscribeWithSubscriptionID:(NSString* _Nonnull)subscriptionID
                           completion:(SKWLocalPersonUnsubscribeCompletion _Nullable)completion
    NS_SWIFT_NAME(unsubscribe(subscriptionID:completion:));
@end

/// LocalPersonイベントデリゲート
NS_SWIFT_NAME(LocalPersonDelegate)
@protocol SKWLocalPersonDelegate <SKWMemberDelegate>
@optional

/// LocalPersonがStreamをPublishした後にコールされます。
///
/// @param localPerson LocalPerson
/// @param publication StreamをPublishした時のPublication
- (void)localPerson:(SKWLocalPerson* _Nonnull)localPerson
    didPublishStreamOfPublication:(SKWPublication* _Nonnull)publication;

/// LocalPersonがStreamをUnpublishした後にコールされます。
///
/// @param localPerson LocalPerson
/// @param publication StreamをUnpublishした時のPublication
- (void)localPerson:(SKWLocalPerson* _Nonnull)localPerson
    didUnpublishStreamOfPublication:(SKWPublication* _Nonnull)publication;

///
/// LocalPersonがPublicationをSubscribeした後にコールされます。
///
/// @param localPerson LocalPerson
/// @param subscription Subscribeした時のSubscription まだstreamがsetされていない可能性があります。
- (void)localPerson:(SKWLocalPerson* _Nonnull)localPerson
    didSubscribePublicationOfSubscription:(SKWSubscription* _Nonnull)subscription;

/// LocalPersonがPublicationをUnsubscribeした後にコールされます。
///
/// @param localPerson LocalPerson
/// @param subscription Unsubscribeした時のSubscription
- (void)localPerson:(SKWLocalPerson* _Nonnull)localPerson
    didUnsubscribePublicationOfSubscription:(SKWSubscription* _Nonnull)subscription;
@end

@interface SKWLocalPerson ()

/// イベントデリゲート
@property(nonatomic, weak) id<SKWLocalPersonDelegate> _Nullable delegate;

@end

#endif /* SKWLocalPerson_h */
