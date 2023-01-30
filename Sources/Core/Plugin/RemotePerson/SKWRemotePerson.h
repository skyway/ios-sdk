//
//  SKWRemotePerson.h
//  SkyWay
//
//  Created by sandabu on 2022/03/28.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWRemotePerson_h
#define SKWRemotePerson_h

#import "SKWRemoteMember.h"
#import "SKWSubscriptionOptions.h"

NS_SWIFT_NAME(RemotePerson)
@interface SKWRemotePerson : SKWRemoteMember

typedef void (^SKWRemotePersonSubscribePublicationCompletion)(SKWSubscription* _Nullable, NSError* _Nullable);
typedef void (^SKWRemotePersonUnsubscribeCompletion)(NSError* _Nullable);

-(void)subscribePublicationWithPublicationID:(NSString* _Nonnull)publicationID
                                  completion:(SKWRemotePersonSubscribePublicationCompletion _Nullable)completion
NS_SWIFT_NAME(subscribePublication(publicationID:completion:));

-(void)unsubscribeWithSubscriptionID:(NSString* _Nonnull)subscriptionID completion:(SKWRemotePersonUnsubscribeCompletion _Nullable)completion
NS_SWIFT_NAME(unsubscribe(subscriptionID:completion:));

@end

NS_SWIFT_NAME(RemotePersonDelegate)
@protocol SKWRemotePersonDelegate <SKWMemberDelegate>
@optional
-(void)remotePerson:(SKWRemotePerson* _Nonnull)remotePerson didSubscribePublicationOfSubscription:(SKWSubscription* _Nonnull)subscription;
-(void)remotePerson:(SKWRemotePerson* _Nonnull)remotePerson didUnsubscribePublicationOfSubscription:(SKWSubscription* _Nonnull)subscription;
@end

@interface SKWRemotePerson()

@property(nonatomic, weak) id<SKWRemotePersonDelegate> _Nullable delegate;

@end

#endif /* SKWRemotePerson_h */
