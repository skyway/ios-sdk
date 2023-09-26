//
//  SKWFileVideoSource.mm
//  SkyWayRoom
//
//  Created by sandabu on 2022/05/12.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#import "SKWFileVideoSource.h"

#import "SKWLocalVideoStream.h"

#import "SKWVideoSource+Internal.h"

@implementation SKWFileVideoSource

- (id _Nonnull)initWithFilename:(NSString* _Nonnull)filename {
    if (self = [super initWithRTCCapturer:[[RTCFileVideoCapturer alloc] init]]) {
        _filename = filename;
    }
    return self;
}

- (void)startCapturingOnError:(SKWFileVideoSourceStartCapturingOnError _Nullable)onError {
    RTCFileVideoCapturer* fileCapturer = (RTCFileVideoCapturer*)self.rtcCapturer;
    [fileCapturer startCapturingFromFileNamed:_filename onError:onError];
}

- (void)stopCapturing {
    RTCFileVideoCapturer* fileCapturer = (RTCFileVideoCapturer*)self.rtcCapturer;
    [fileCapturer stopCapture];
}

@end
