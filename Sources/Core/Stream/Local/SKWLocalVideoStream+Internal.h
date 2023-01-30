//
//  SKWLocalVideoStream+Internal.h
//  SkyWay
//
//  Created by sandabu on 2022/04/06.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWLocalVideoStream_Internal_h
#define SKWLocalVideoStream_Internal_h

#import <WebRTC/WebRTC.h>

#import "SKWLocalVideoStream.h"

@interface SKWLocalVideoStream()

-(id _Nonnull)initWithSource:(SKWVideoSource* _Nonnull)source;

-(id _Nonnull)initWithSource:(SKWVideoSource* _Nonnull)source
              rtcVideoSource:(RTCVideoSource* _Nonnull)rtcVideoSource;

-(void)customFrameUpdated:(NSNotification* _Nonnull)notification;

@end

#endif /* SKWLocalVideoStream_Internal_h */
