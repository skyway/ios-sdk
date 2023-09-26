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

NS_SWIFT_NAME(LocalPerson)
@interface SKWLocalPerson : SKWMember

typedef void (^SKWLocalPersonPublishStreamCompletion)(SKWPublication* _Nullable,
                                                      NSError* _Nullable error);
typedef void (^SKWLocalPersonSubscribePublicationCompletion)(SKWSubscription* _Nullable,
                                                             NSError* _Nullable error);
typedef void (^SKWLocalPersonUnpublishCompletion)(NSError* _Nullable error);
typedef void (^SKWLocalPersonUnsubscribeCompletion)(NSError* _Nullable error);
typedef void (^SKWLocalPersonLeaveCompletion)(NSError* _Nullable error);

- (void)publishStream:(SKWLocalStream* _Nonnull)stream
              options:(SKWPublicationOptions* _Nullable)options
           completion:(SKWLocalPersonPublishStreamCompletion _Nullable)completion
    NS_SWIFT_NAME(publish(_:options:completion:));

- (void)subscribePublicationWithPublicationID:(NSString* _Nonnull)publicationID
                                      options:(SKWSubscriptionOptions* _Nullable)options
                                   completion:
                                       (SKWLocalPersonSubscribePublicationCompletion _Nullable)
                                           completion
    NS_SWIFT_NAME(subscribePublication(publicationID:options:completion:));

- (void)unpublishWithPublicationID:(NSString* _Nonnull)publicationID
                        completion:(SKWLocalPersonUnpublishCompletion _Nullable)completion
    NS_SWIFT_NAME(unpublish(publicationID:completion:));

- (void)unsubscribeWithSubscriptionID:(NSString* _Nonnull)subscriptionID
                           completion:(SKWLocalPersonUnsubscribeCompletion _Nullable)completion
    NS_SWIFT_NAME(unsubscribe(subscriptionID:completion:));
@end

NS_SWIFT_NAME(LocalPersonDelegate)
@protocol SKWLocalPersonDelegate <SKWMemberDelegate>
@optional
- (void)localPerson:(SKWLocalPerson* _Nonnull)localPerson
    didPublishStreamOfPublication:(SKWPublication* _Nonnull)publication;
- (void)localPerson:(SKWLocalPerson* _Nonnull)localPerson
    didUnpublishStreamOfPublication:(SKWPublication* _Nonnull)publication;
- (void)localPerson:(SKWLocalPerson* _Nonnull)localPerson
    didSubscribePublicationOfSubscription:(SKWSubscription* _Nonnull)subscription;
- (void)localPerson:(SKWLocalPerson* _Nonnull)localPerson
    didUnsubscribePublicationOfSubscription:(SKWSubscription* _Nonnull)subscription;
@end

@interface SKWLocalPerson ()

/// イベントデリゲート
@property(nonatomic, weak) id<SKWLocalPersonDelegate> _Nullable delegate;

@end

#endif /* SKWLocalPerson_h */
