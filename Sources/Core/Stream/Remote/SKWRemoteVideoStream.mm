//
//  SKWRemoteVideoStream.mm
//  SkyWay
//
//  Created by sandabu on 2022/03/23.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#import "SKWRemoteVideoStream.h"
#import "SKWContext+Internal.h"
#import "SKWStream+Internal.h"
#import "SKWVideoView+Internal.h"

#import "RTCMediaStreamTrack+Private.h"

#import <skyway/core/stream/remote/video_stream.hpp>

using NativeRemoteVideoStream = skyway::core::stream::remote::RemoteVideoStream;

@interface SKWRemoteVideoStream () {
    RTCVideoTrack* track;
}
@end

@implementation SKWRemoteVideoStream

- (void)attachView:(SKWVideoView* _Nonnull)view {
    auto nativeVideoStream = std::static_pointer_cast<NativeRemoteVideoStream>(self.native);
    auto nativeTrack       = nativeVideoStream->GetTrack();
    track = (RTCVideoTrack*)[RTCMediaStreamTrack mediaTrackForNativeTrack:nativeTrack
                                                                  factory:SKWContext.pcFactory];
    [view addRendererWithTrack:track];
}

- (void)detachView:(SKWVideoView* _Nonnull)view {
    [view removeRenderer];
    track = nil;
}

@end
