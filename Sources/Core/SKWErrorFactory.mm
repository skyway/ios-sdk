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
    NSBundle *bundle = [NSBundle bundleForClass:self];
    return [[NSError alloc] initWithDomain:bundle.bundleIdentifier code:SKWAvailableCameraIsMissing userInfo:nil];
}

+(NSError* _Nonnull)cameraIsNotSet{
    NSBundle *bundle = [NSBundle bundleForClass:self];
    return [[NSError alloc] initWithDomain:bundle.bundleIdentifier code:SKWCameraIsNotSet userInfo:nil];
}

+(NSError* _Nonnull)contextSetupError {
    NSBundle *bundle = [NSBundle bundleForClass:self];
    return [[NSError alloc] initWithDomain:bundle.bundleIdentifier code:SKWContextSetupError userInfo:nil];
}

+(NSError* _Nonnull)channelFindError {
    NSBundle *bundle = [NSBundle bundleForClass:self];
    return [[NSError alloc] initWithDomain:bundle.bundleIdentifier code:SKWChannelFindError userInfo:nil];
}

+(NSError* _Nonnull)channelCreateError {
    NSBundle *bundle = [NSBundle bundleForClass:self];
    return [[NSError alloc] initWithDomain:bundle.bundleIdentifier code:SKWChannelCreateError userInfo:nil];
}

+(NSError* _Nonnull)channelFindOrCreateError{
    NSBundle *bundle = [NSBundle bundleForClass:self];
    return [[NSError alloc] initWithDomain:bundle.bundleIdentifier code:SKWChannelFindOrCreateError userInfo:nil];
}

+(NSError* _Nonnull)channelJoinError{
    NSBundle *bundle = [NSBundle bundleForClass:self];
    return [[NSError alloc] initWithDomain:bundle.bundleIdentifier code:SKWChannelJoinError userInfo:nil];
}

+(NSError* _Nonnull)channelLeaveError{
    NSBundle *bundle = [NSBundle bundleForClass:self];
    return [[NSError alloc] initWithDomain:bundle.bundleIdentifier code:SKWChannelLeaveError userInfo:nil];
}

+(NSError* _Nonnull)channelCloseError {
    NSBundle *bundle = [NSBundle bundleForClass:self];
    return [[NSError alloc] initWithDomain:bundle.bundleIdentifier code:SKWChannelCloseError userInfo:nil];
}

+(NSError* _Nonnull)memberUpdateMetadataError{
    NSBundle *bundle = [NSBundle bundleForClass:self];
    return [[NSError alloc] initWithDomain:bundle.bundleIdentifier code:SKWMemberUpdateMetadataError userInfo:nil];
}

+(NSError* _Nonnull)memberLeaveError{
    NSBundle *bundle = [NSBundle bundleForClass:self];
    return [[NSError alloc] initWithDomain:bundle.bundleIdentifier code:SKWMemberLeaveError userInfo:nil];
}

+(NSError* _Nonnull)localPersonPublishError{
    NSBundle *bundle = [NSBundle bundleForClass:self];
    return [[NSError alloc] initWithDomain:bundle.bundleIdentifier code:SKWLocalPersonPublishError userInfo:nil];
}

+(NSError* _Nonnull)localPersonSubscribeError{
    NSBundle *bundle = [NSBundle bundleForClass:self];
    return [[NSError alloc] initWithDomain:bundle.bundleIdentifier code:SKWLocalPersonSubscribeError userInfo:nil];
}

+(NSError* _Nonnull)localPersonUnpublishError{
    NSBundle *bundle = [NSBundle bundleForClass:self];
    return [[NSError alloc] initWithDomain:bundle.bundleIdentifier code:SKWLocalPersonUnpublishError userInfo:nil];
}

+(NSError* _Nonnull)localPersonUnsubscribeError{
    NSBundle *bundle = [NSBundle bundleForClass:self];
    return [[NSError alloc] initWithDomain:bundle.bundleIdentifier code:SKWLocalPersonUnsubscribeError userInfo:nil];
}

+(NSError* _Nonnull)remotePersonSubscribeError{
    NSBundle *bundle = [NSBundle bundleForClass:self];
    return [[NSError alloc] initWithDomain:bundle.bundleIdentifier code:SKWRemotePersonSubscribeError userInfo:nil];
}

+(NSError* _Nonnull)remotePersonUnsubscribeError{
    NSBundle *bundle = [NSBundle bundleForClass:self];
    return [[NSError alloc] initWithDomain:bundle.bundleIdentifier code:SKWRemotePersonUnsubscribeError userInfo:nil];
}

+(NSError* _Nonnull)publicationUpdateMetadataError{
    NSBundle *bundle = [NSBundle bundleForClass:self];
    return [[NSError alloc] initWithDomain:bundle.bundleIdentifier code:SKWPublicationUpdateMetadataError userInfo:nil];
}
+(NSError* _Nonnull)publicationCancelError{
    NSBundle *bundle = [NSBundle bundleForClass:self];
    return [[NSError alloc] initWithDomain:bundle.bundleIdentifier code:SKWPublicationCancelError userInfo:nil];
}
+(NSError* _Nonnull)publicationEnableError{
    NSBundle *bundle = [NSBundle bundleForClass:self];
    return [[NSError alloc] initWithDomain:bundle.bundleIdentifier code:SKWPublicationEnableError userInfo:nil];
}
+(NSError* _Nonnull)publicationDisableError{
    NSBundle *bundle = [NSBundle bundleForClass:self];
    return [[NSError alloc] initWithDomain:bundle.bundleIdentifier code:SKWPublicationDisableError userInfo:nil];
}

+(NSError* _Nonnull)subscriptionCancelError{
    NSBundle *bundle = [NSBundle bundleForClass:self];
    return [[NSError alloc] initWithDomain:bundle.bundleIdentifier code:SKWSubscriptionCancelError userInfo:nil];
}

+(NSError* _Nonnull)contextDisposeError {
    NSBundle *bundle = [NSBundle bundleForClass:self];
    return [[NSError alloc] initWithDomain:bundle.bundleIdentifier code:SKWContextDisposeError userInfo:nil];
}

+(NSError* _Nonnull)fatalErrorRAPIReconnectFailedError {
    NSBundle *bundle = [NSBundle bundleForClass:self];
    return [[NSError alloc] initWithDomain:bundle.bundleIdentifier code:SKWFatalErrorRAPIReconnectFailed userInfo:nil];
}


@end
