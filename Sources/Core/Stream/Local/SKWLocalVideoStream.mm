//
//  SKWLocalVideoStream.mm
//  SkyWay
//
//  Created by sandabu on 2022/03/22.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#import <WebRTC/WebRTC.h>

#import "SKWLocalVideoStream.h"

#import "SKWStream+Internal.h"
#import "SKWContext+Internal.h"

#import "NSString+StdString.h"
#import "SKWStream+Internal.h"
#import "RTCVideoTrack+Private.h"

#import "SKWCustomFrameVideoSource.h"
#import "SKWVideoSource+Internal.h"


#import "SKWVideoView+Internal.h"
#import "NSString+NotificationString.h"

#import <skyway/core/stream/local/video_stream.hpp>

using NativeLocalVideoStream = skyway::core::stream::local::LocalVideoStream;

@interface SKWLocalVideoStream()

@property(nonatomic, readonly) RTCVideoSource* _Nonnull rtcVideoSource;
@property(nonatomic, readonly) RTCVideoTrack* _Nonnull track;

-(void)applySource;

@end

@implementation SKWLocalVideoStream

-(id _Nonnull)initWithSource:(SKWVideoSource* _Nonnull)source
              rtcVideoSource:(RTCVideoSource* _Nonnull)rtcVideoSource {
    RTCPeerConnectionFactory* pcFactory = SKWContext.pcFactory;
    NSString* trackId = [[[NSUUID UUID] UUIDString] lowercaseString];
    _track = [pcFactory videoTrackWithSource:rtcVideoSource trackId:trackId];
    auto nativeTrack = _track.nativeVideoTrack;
    auto native = std::make_shared<NativeLocalVideoStream>(nativeTrack);
    if(self = [super initWithSharedNative:native]) {
        _source = source;
        _rtcVideoSource = rtcVideoSource;
        [self applySource];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(customFrameUpdated:) name:NSString.SKWCustomFrameVideoSourceDidUpdateFrame object:nil];
    }
    return self;
}

-(id _Nonnull)initWithSource:(SKWVideoSource* _Nonnull)source{
    return [self initWithSource:source rtcVideoSource:[SKWContext.pcFactory videoSource]];
}

-(void)applySource {
    _source.rtcCapturer.delegate = _rtcVideoSource;
}

-(void)attachView:(SKWVideoView* _Nonnull)view {
    [view addRendererWithTrack:_track];
}

-(void)detachView:(SKWVideoView* _Nonnull)view {
    [view removeRenderer];
}

-(void)customFrameUpdated:(NSNotification* _Nonnull)notification{
    if((SKWCustomFrameVideoSource*)[notification object] != _source) {
        return;
    }
    
    RTCVideoFrame* frame = [[notification userInfo] objectForKey:NSString.SKWCustomFrameVideoSourceDidUpdateFrameKeyForFrame];
    [_rtcVideoSource capturer:_source.rtcCapturer didCaptureVideoFrame:frame];
}




@end


