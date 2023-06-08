//
//  SKWVideoView.m
//  SkyWay
//
//  Created by sandabu on 2022/03/23.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#import <WebRTC/WebRTC.h>

#import "SKWVideoView.h"
#import "SKWVideoView+Internal.h"
#import "DispatchMainSync.h"


@interface SKWVideoView(){
    RTCVideoTrack* videoTrack;
}
@end

@implementation SKWVideoView

-(void)setVideoContentMode:(UIViewContentMode)videoContentMode {
    if(_rendererView) {
        RTCMTLVideoView* mtlRendererView = (RTCMTLVideoView*)_rendererView;
        mtlRendererView.videoContentMode = videoContentMode;
    }
    _videoContentMode = videoContentMode;
}

-(void)addRendererWithTrack:(RTCVideoTrack* _Nonnull)track {
    RTCMTLVideoView* mtlRendererView = [[RTCMTLVideoView alloc] init];
    mtlRendererView.videoContentMode = _videoContentMode;
    mtlRendererView.delegate = self;
    if(_rendererView != nil) {
        [self removeRenderer];
    }
    _rendererView = mtlRendererView;
    _rendererView.frame = self.bounds;
    videoTrack = track;
    dispatch_main_sync(^{
        [track addRenderer:mtlRendererView];
        [self addSubview:mtlRendererView];
    });
}

-(void)removeRenderer {
    dispatch_main_sync(^{
        RTCMTLVideoView* mtlRendererView = (RTCMTLVideoView*)self->_rendererView;
        [self->videoTrack removeRenderer:mtlRendererView];
        [self->_rendererView removeFromSuperview];
        self->videoTrack = nil;
        self->_rendererView = nil;
    });
}

-(void)layoutSubviews {
    [super layoutSubviews];
    if(_rendererView) {
        _rendererView.frame = self.bounds;
    }
}

-(void)layoutIfNeeded {
    [super layoutIfNeeded];
}

// MARK: - RTCVideoViewDelegate

- (void)videoView:(nonnull id<RTCVideoRenderer>)videoView didChangeVideoSize:(CGSize)size {
    [self layoutIfNeeded];
}

@end
