//
//  SKWVideoSource+Internal.h
//  SkyWay
//
//  Created by sandabu on 2022/05/11.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWVideoSource_Internal_h
#define SKWVideoSource_Internal_h

#import <WebRTC/WebRTC.h>

#import "SKWVideoSource.h"

@interface SKWVideoSource ()

@property(nonatomic, readonly) RTCVideoCapturer* _Nonnull rtcCapturer;

- (id _Nonnull)initWithRTCCapturer:(RTCVideoCapturer* _Nonnull)rtcCapturer;

@end

#endif /* SKWVideoSource_Internal_h */
