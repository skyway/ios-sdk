//
//  SKWCameraVideoSource.mm
//  SkyWayRoom
//
//  Created by sandabu on 2022/05/11.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#import <WebRTC/WebRTC.h>

#import "SKWCameraVideoSource.h"

#import "SKWContext+Internal.h"
#import "SKWErrorFactory.h"
#import "SKWVideoSource+Internal.h"

#import "SKWCameraPreviewView+Internal.h"

#import "SKWLocalVideoStream+Internal.h"

@implementation SKWCameraCaptureOptions

- (id)init {
    if (self = [super init]) {
        // 720p
        _preferredMaxWidth     = 1280;
        _preferredMaxHeight    = 720;
        _preferredMaxFrameRate = 30;
    }
    return self;
}

@end

static SKWCameraVideoSource* defaultInstance = nil;

@interface SKWCameraVideoSource ()

@property(nonatomic, readonly) RTCVideoSource* _Nonnull rtcVideoSource;
@property(nonatomic, readonly) SKWCameraCaptureOptions* _Nullable captureOptions;

- (id _Nonnull)init;

- (NSArray<AVCaptureDeviceFormat*>* _Nonnull)supportedFormats;

- (AVCaptureDeviceFormat*)selectFormatForCapturer:(RTCCameraVideoCapturer* _Nonnull)capturer
                                         maxWidth:(int)maxWidth
                                        maxHeight:(int)maxHeight;
- (int)selectFpsForFormat:(AVCaptureDeviceFormat*)format preferredMaxFrameRate:(int)preferredFps;
- (BOOL)isSupportedCamera:(AVCaptureDevice* _Nonnull)camera;

@end

@implementation SKWCameraVideoSource

+ (NSArray<AVCaptureDevice*>* _Nonnull)supportedCameras {
    return RTCCameraVideoCapturer.captureDevices;
}

+ (instancetype _Nonnull)shared {
    if (!defaultInstance) {
        defaultInstance = [[SKWCameraVideoSource alloc] init];
    }
    return defaultInstance;
}

- (id _Nonnull)init {
    if (self = [super initWithRTCCapturer:[[RTCCameraVideoCapturer alloc] init]]) {
        _rtcVideoSource = [SKWContext.pcFactory videoSource];
    }
    return self;
}

- (void)attachView:(SKWCameraPreviewView* _Nonnull)view {
    RTCCameraVideoCapturer* cameraCapturer = (RTCCameraVideoCapturer*)self.rtcCapturer;
    [view renderWithCaptureSession:cameraCapturer.captureSession];
}

- (void)detachView:(SKWCameraPreviewView* _Nonnull)view {
    [view stopRendering];
}

- (void)startCapturingWithDevice:(AVCaptureDevice* _Nonnull)device
                         options:(SKWCameraCaptureOptions* _Nullable)options
                      completion:
                          (SKWCameraVideoSourceStartCapturingCompletion _Nullable)completion {
    if (![self isSupportedCamera:device] && completion) {
        completion([SKWErrorFactory availableCameraIsMissing]);
        return;
    }
    _camera = device;
    if (!options) {
        options = [[SKWCameraCaptureOptions alloc] init];
    }
    _captureOptions                        = options;
    RTCCameraVideoCapturer* cameraCapturer = (RTCCameraVideoCapturer*)self.rtcCapturer;
    AVCaptureDeviceFormat* format          = [self selectFormatForCapturer:cameraCapturer
                                                         maxWidth:options.preferredMaxWidth
                                                        maxHeight:options.preferredMaxHeight];
    NSInteger fps                          = [self selectFpsForFormat:format
                       preferredMaxFrameRate:options.preferredMaxFrameRate];
    [cameraCapturer startCaptureWithDevice:_camera
                                    format:format
                                       fps:fps
                         completionHandler:completion];
}

- (void)changeDevice:(AVCaptureDevice* _Nonnull)device
          completion:(SKWCameraVideoSourceChangeDeviceCompletion _Nullable)completion {
    if (![self isSupportedCamera:device] && completion) {
        completion([SKWErrorFactory availableCameraIsMissing]);
        return;
    }
    _camera                                = device;
    RTCCameraVideoCapturer* cameraCapturer = (RTCCameraVideoCapturer*)self.rtcCapturer;
    if (cameraCapturer.captureSession.running) {
        [self startCapturingWithDevice:device options:_captureOptions completion:completion];
    } else if (completion) {
        completion(nil);
    }
}

- (void)stopCapturing {
    RTCCameraVideoCapturer* cameraCapturer = (RTCCameraVideoCapturer*)self.rtcCapturer;
    [cameraCapturer stopCapture];
}

- (SKWLocalVideoStream* _Nonnull)createStream {
    if (_rtcVideoSource == nil) {
        _rtcVideoSource = [SKWContext.pcFactory videoSource];
    }
    return [[SKWLocalVideoStream alloc] initWithSource:self rtcVideoSource:_rtcVideoSource];
}

- (NSArray<AVCaptureDeviceFormat*>* _Nonnull)supportedFormats {
    return [RTCCameraVideoCapturer supportedFormatsForDevice:_camera];
}

- (AVCaptureDeviceFormat*)selectFormatForCapturer:(RTCCameraVideoCapturer* _Nonnull)capturer
                                         maxWidth:(int)maxWidth
                                        maxHeight:(int)maxHeight {
    AVCaptureDeviceFormat* selectedFormat  = nil;
    RTCCameraVideoCapturer* cameraCapturer = (RTCCameraVideoCapturer*)self.rtcCapturer;
    int32_t currentDiff                    = INT_MAX;

    for (AVCaptureDeviceFormat* format in self.supportedFormats) {
        CMVideoDimensions dimension =
            CMVideoFormatDescriptionGetDimensions(format.formatDescription);
        FourCharCode pixelFormat = CMFormatDescriptionGetMediaSubType(format.formatDescription);
        int diff = abs(maxWidth - dimension.width) + abs(maxHeight - dimension.height);
        if (diff < currentDiff) {
            selectedFormat = format;
            currentDiff    = diff;
        }

        else if (diff == currentDiff &&
                 pixelFormat == [cameraCapturer preferredOutputPixelFormat]) {
            selectedFormat = format;
        }
    }

    return selectedFormat;
}

- (int)selectFpsForFormat:(AVCaptureDeviceFormat*)format preferredMaxFrameRate:(int)preferredFps {
    Float64 maxSupportedFramerate = 0;
    for (AVFrameRateRange* fpsRange in format.videoSupportedFrameRateRanges) {
        maxSupportedFramerate = fmax(maxSupportedFramerate, fpsRange.maxFrameRate);
    }
    return (int)fmin(maxSupportedFramerate, preferredFps);
}

- (BOOL)isSupportedCamera:(AVCaptureDevice* _Nonnull)camera {
    NSUInteger idx = [SKWCameraVideoSource.supportedCameras
        indexOfObjectPassingTest:^BOOL(
            AVCaptureDevice* _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
          return obj == camera;
        }];
    return idx != NSNotFound;
}

@end
