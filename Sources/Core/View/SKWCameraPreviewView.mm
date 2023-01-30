//
//  SKWCameraPreviewView.m
//  SkyWayRoom
//
//  Created by Naoto Takahashi on 2022/09/12.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#import <WebRTC/WebRTC.h>

#include "SKWCameraPreviewView+Internal.h"

@implementation SKWCameraPreviewView

-(void)setVideoGravity:(AVLayerVideoGravity)videoGravity {
    if(_rendererView) {
        AVCaptureVideoPreviewLayer* layer = (AVCaptureVideoPreviewLayer*)_rendererView.layer;
        layer.videoGravity = videoGravity;
    }
    _videoGravity = videoGravity;
}

-(void)renderWithCaptureSession:(AVCaptureSession* _Nonnull)captureSession{
    dispatch_async(dispatch_get_main_queue(), ^{
        RTCCameraPreviewView* rtcView = [[RTCCameraPreviewView alloc] initWithFrame:self.bounds];
        rtcView.captureSession = captureSession;
        self->_rendererView = rtcView;
        [self setVideoGravity:self.videoGravity];
        [self addSubview:self->_rendererView];
        [self sendSubviewToBack:self->_rendererView];
    });
}

-(void)stopRendering{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self->_rendererView != nil) {
            [self->_rendererView removeFromSuperview];
            self->_rendererView = nil;
        }
    });
}


@end
