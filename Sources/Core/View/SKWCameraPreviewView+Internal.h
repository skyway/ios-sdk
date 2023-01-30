//
//  SKWCameraPreviewView+Internal.h
//  SkyWay
//
//  Created by Naoto Takahashi on 2022/09/12.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWCameraPreviewView_Internal_h
#define SKWCameraPreviewView_Internal_h

#include <AVFoundation/AVFoundation.h>

#include "SKWCameraPreviewView.h"

@interface SKWCameraPreviewView()
-(void)renderWithCaptureSession:(AVCaptureSession* _Nonnull)captureSession;
-(void)stopRendering;
@end

#endif /* SKWCameraPreviewView_Internal_h */
