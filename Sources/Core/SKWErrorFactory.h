//
//  SKWErrorFactory.h
//  SkyWay
//
//  Created by sandabu on 2022/04/27.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWErrorFactory_h
#define SKWErrorFactory_h

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SKWErrorCode) {
    SKWAvailableCameraIsMissing = 0,
    SKWCameraIsNotSet = 1,
    SKWContextSetupError = 2,
    SKWChannelFindError = 3,
    SKWChannelCreateError = 4,
    SKWChannelFindOrCreateError = 5,
    SKWChannelJoinError = 6,
    SKWChannelLeaveError = 7,
    SKWChannelCloseError = 8,
    SKWMemberUpdateMetadataError = 9,
    SKWMemberLeaveError = 10,
    SKWLocalPersonPublishError = 11,
    SKWLocalPersonSubscribeError = 12,
    SKWLocalPersonUnpublishError = 13,
    SKWLocalPersonUnsubscribeError = 14,
    SKWRemotePersonSubscribeError = 15,
    SKWRemotePersonUnsubscribeError = 16,
    SKWPublicationUpdateMetadataError = 17,
    SKWPublicationCancelError = 18,
    SKWPublicationEnableError = 19,
    SKWPublicationDisableError = 20,
    SKWSubscriptionCancelError = 21,
    SKWContextDisposeError = 22,
};

@interface SKWErrorFactory: NSObject

+(NSError* _Nonnull)availableCameraIsMissing;
+(NSError* _Nonnull)cameraIsNotSet;
+(NSError* _Nonnull)contextSetupError;
+(NSError* _Nonnull)channelFindError;
+(NSError* _Nonnull)channelCreateError;
+(NSError* _Nonnull)channelFindOrCreateError;
+(NSError* _Nonnull)channelJoinError;
+(NSError* _Nonnull)channelLeaveError;
+(NSError* _Nonnull)channelCloseError;
+(NSError* _Nonnull)memberUpdateMetadataError;
+(NSError* _Nonnull)memberLeaveError;
+(NSError* _Nonnull)localPersonPublishError;
+(NSError* _Nonnull)localPersonSubscribeError;
+(NSError* _Nonnull)localPersonUnpublishError;
+(NSError* _Nonnull)localPersonUnsubscribeError;
+(NSError* _Nonnull)remotePersonSubscribeError;
+(NSError* _Nonnull)remotePersonUnsubscribeError;
+(NSError* _Nonnull)publicationUpdateMetadataError;
+(NSError* _Nonnull)publicationCancelError;
+(NSError* _Nonnull)publicationEnableError;
+(NSError* _Nonnull)publicationDisableError;
+(NSError* _Nonnull)subscriptionCancelError;
+(NSError* _Nonnull)contextDisposeError;

@end

#endif /* SKWErrorFactory_h */
