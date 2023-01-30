//
//  SKWVideoView+Internal.h
//  SkyWay
//
//  Created by sandabu on 2022/03/28.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWVideoView_Internal_h
#define SKWVideoView_Internal_h

#import <AVFoundation/AVFoundation.h>
#import <WebRTC/WebRTC.h>

#import "SKWVideoView.h"
#import "SKWLocalVideoStream.h"
#import "SKWRemoteVideoStream.h"

@interface SKWVideoView()<RTCVideoViewDelegate>

-(void)addRendererWithTrack:(RTCVideoTrack* _Nonnull)track;
-(void)removeRenderer;
@end

#endif /* SKWVideoView_Internal_h */
