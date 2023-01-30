//
//  SKWCustomFrameVideoSource.mm
//  SkyWayRoom
//
//  Created by sandabu on 2022/05/12.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#import "SKWCustomFrameVideoSource.h"

#import "SKWVideoSource+Internal.h"
#import "NSString+NotificationString.h"


@implementation SKWCustomFrameVideoSource

-(id _Nonnull)init{
    return [super initWithRTCCapturer:[[RTCVideoCapturer alloc] init]];
}

-(void)updateFrameWithSampleBuffer:(CMSampleBufferRef _Nonnull)sampleBuffer {
    CVPixelBufferRef pixelBuf = CMSampleBufferGetImageBuffer(sampleBuffer);
    RTCCVPixelBuffer* rtcPixelBuf = [[RTCCVPixelBuffer alloc] initWithPixelBuffer:pixelBuf];
    int64_t timeStampNs = CMTimeGetSeconds(CMSampleBufferGetPresentationTimeStamp(sampleBuffer)) * 1000 * 1000 * 1000;
    RTCVideoFrame* frame = [[RTCVideoFrame alloc] initWithBuffer:rtcPixelBuf rotation:RTCVideoRotation_0 timeStampNs:timeStampNs];
    NSDictionary* dic = [NSDictionary dictionaryWithObject:frame forKey:NSString.SKWCustomFrameVideoSourceDidUpdateFrameKeyForFrame];
    [[NSNotificationCenter defaultCenter] postNotificationName:NSString.SKWCustomFrameVideoSourceDidUpdateFrame object:self userInfo:dic];
}

@end
