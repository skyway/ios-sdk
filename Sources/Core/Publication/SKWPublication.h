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

NS_SWIFT_NAME(Publication)
@interface SKWPublication : NSObject

typedef void (^SKWPublicationUpdateMetadataCompletion)(NSError* _Nullable error);
typedef void (^SKWPublicationCancelCompletion)(NSError* _Nullable error);
typedef void (^SKWPublicationEnableCompletion)(NSError* _Nullable error);
typedef void (^SKWPublicationDisableCompletion)(NSError* _Nullable error);

@property(nonatomic, readonly) NSString* _Nonnull id;
@property(nonatomic, readonly) SKWMember* _Nullable publisher;
@property(nonatomic, readonly) NSArray<SKWSubscription*>* _Nonnull subscriptions;
@property(nonatomic, readonly) SKWContentType contentType;
@property(nonatomic, readonly) NSString* _Nullable metadata;
@property(nonatomic, readonly) NSArray<SKWCodec*>* _Nonnull codecCapabilities;
@property(nonatomic, readonly) NSArray<SKWEncoding*>* _Nonnull encodings;
@property(nonatomic, readonly) SKWPublicationState state;
@property(nonatomic, readonly) SKWLocalStream* _Nullable stream;
@property(nonatomic, readonly) SKWPublication* _Nullable origin;

-(void)updateMetadata:(NSString* _Nonnull)metadata completion:(SKWPublicationUpdateMetadataCompletion _Nullable)completion;
-(void)cancelWithCompletion:(SKWPublicationCancelCompletion _Nullable)completion;
-(void)enableWithCompletion:(SKWPublicationEnableCompletion _Nullable)completion;
-(void)disableWithCompletion:(SKWPublicationDisableCompletion _Nullable)completion;
-(void)updateEncodings:(NSArray<SKWEncoding*>* _Nonnull)encodings;

@end

NS_SWIFT_NAME(PublicationDelegate)
@protocol SKWPublicationDelegate <NSObject>
@optional
-(void)publicationUnpublished:(SKWPublication* _Nonnull)publication;
-(void)publicationSubscribed:(SKWPublication* _Nonnull)publication;
-(void)publicationUnsubscribed:(SKWPublication* _Nonnull)publication;
-(void)publicationSubscriptionListDidChange:(SKWPublication* _Nonnull)publication;
-(void)publication:(SKWPublication* _Nonnull)publication didUpdateMetadata:(NSString* _Nonnull)metadata;
-(void)publicationEnabled:(SKWPublication* _Nonnull)publication;
-(void)publicationDisabled:(SKWPublication* _Nonnull)publication;
-(void)publicationStateDidChange:(SKWPublication* _Nonnull)publication;
@end

@interface SKWPublication()

@property (weak, nonatomic) id<SKWPublicationDelegate> _Nullable delegate;

@end

#endif /* SKWPublication_h */
