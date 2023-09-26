//
//  SKWVideoSource.mm
//  SkyWayRoom
//
//  Created by sandabu on 2022/05/12.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#import "SKWLocalVideoStream+Internal.h"
#import "SKWVideoSource+Internal.h"

@implementation SKWVideoSource

- (id _Nonnull)initWithRTCCapturer:(RTCVideoCapturer* _Nonnull)rtcCapturer {
    if (self = [super init]) {
        _rtcCapturer = rtcCapturer;
    }
    return self;
}

- (SKWLocalVideoStream* _Nonnull)createStream {
    return [[SKWLocalVideoStream alloc] initWithSource:self];
}

@end
