//
//  SKWErrorFactory.mm
//  SkyWay
//
//  Created by sandabu on 2022/04/27.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#import "SKWErrorFactory.h"

@implementation SKWErrorFactory

+(NSError* _Nonnull)availableCameraIsMissing{
    return [[NSError alloc] initWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:SKWAvailableCameraIsMissing userInfo:nil];
}

+(NSError* _Nonnull)cameraIsNotSet{
    return [[NSError alloc] initWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:SKWCameraIsNotSet userInfo:nil];
}

+(NSError* _Nonnull)contextSetupError {
    return [[NSError alloc] initWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:SKWContextSetupError userInfo:nil];
}

+(NSError* _Nonnull)channelFindError {
    return [[NSError alloc] initWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:SKWChannelFindError userInfo:nil];
}

+(NSError* _Nonnull)channelCreateError {
    return [[NSError alloc] initWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:SKWChannelCreateError userInfo:nil];
}

+(NSError* _Nonnull)channelFindOrCreateError{
    return [[NSError alloc] initWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:SKWChannelFindOrCreateError userInfo:nil];
}

+(NSError* _Nonnull)channelJoinError{
    return [[NSError alloc] initWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:SKWChannelJoinError userInfo:nil];
}

+(NSError* _Nonnull)channelLeaveError{
    return [[NSError alloc] initWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:SKWChannelLeaveError userInfo:nil];
}

+(NSError* _Nonnull)channelCloseError {
    return [[NSError alloc] initWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:SKWChannelCloseError userInfo:nil];
}

+(NSError* _Nonnull)memberUpdateMetadataError{
    return [[NSError alloc] initWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:SKWMemberUpdateMetadataError userInfo:nil];
}

+(NSError* _Nonnull)memberLeaveError{
    return [[NSError alloc] initWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:SKWMemberLeaveError userInfo:nil];
}

+(NSError* _Nonnull)localPersonPublishError{
    return [[NSError alloc] initWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:SKWLocalPersonPublishError userInfo:nil];
}

+(NSError* _Nonnull)localPersonSubscribeError{
    return [[NSError alloc] initWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:SKWLocalPersonSubscribeError userInfo:nil];
}

+(NSError* _Nonnull)localPersonUnpublishError{
    return [[NSError alloc] initWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:SKWLocalPersonUnpublishError userInfo:nil];
}

+(NSError* _Nonnull)localPersonUnsubscribeError{
    return [[NSError alloc] initWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:SKWLocalPersonUnsubscribeError userInfo:nil];
}

+(NSError* _Nonnull)remotePersonSubscribeError{
    return [[NSError alloc] initWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:SKWRemotePersonSubscribeError userInfo:nil];
}

+(NSError* _Nonnull)remotePersonUnsubscribeError{
    return [[NSError alloc] initWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:SKWRemotePersonUnsubscribeError userInfo:nil];
}

+(NSError* _Nonnull)publicationUpdateMetadataError{
    return [[NSError alloc] initWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:SKWPublicationUpdateMetadataError userInfo:nil];
}
+(NSError* _Nonnull)publicationCancelError{
    return [[NSError alloc] initWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:SKWPublicationCancelError userInfo:nil];
}
+(NSError* _Nonnull)publicationEnableError{
    return [[NSError alloc] initWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:SKWPublicationEnableError userInfo:nil];
}
+(NSError* _Nonnull)publicationDisableError{
    return [[NSError alloc] initWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:SKWPublicationDisableError userInfo:nil];
}

+(NSError* _Nonnull)subscriptionCancelError{
    return [[NSError alloc] initWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:SKWSubscriptionCancelError userInfo:nil];
}

+(NSError* _Nonnull)contextDisposeError {
    return [[NSError alloc] initWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:SKWContextDisposeError userInfo:nil];
}

+(NSError* _Nonnull)fatalErrorRAPIReconnectFailedError {
    return [[NSError alloc] initWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:SKWFatalErrorRAPIReconnectFailed userInfo:nil];
}


@end
