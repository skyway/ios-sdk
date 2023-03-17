//
//  SkyWayCore.h
//  SkyWay
//
//  Created by sandabu on 2022/05/18.
//  Copyright © 2020 NTT Communications. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for SkyWayCore.
FOUNDATION_EXPORT double SkyWayCoreVersionNumber;

//! Project version string for SkyWayCore.
FOUNDATION_EXPORT const unsigned char SkyWayCoreVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import "SkyWayCore/PublicHeader.h"

// Core
#import "SKWChannel.h"
#import "SKWMember.h"
#import "SKWRemoteMember.h"
#import "SKWLocalPerson.h"

#import "SKWPublication.h"
#import "SKWSubscription.h"

// Context
#import "SKWContext.h"

// Stream
#import "SKWStream.h"
#import "SKWLocalStream.h"
#import "SKWLocalAudioStream.h"
#import "SKWLocalVideoStream.h"
#import "SKWLocalDataStream.h"
#import "SKWRemoteStream.h"
#import "SKWRemoteAudioStream.h"
#import "SKWRemoteVideoStream.h"
#import "SKWRemoteDataStream.h"

// Plugin
#import "SKWPlugin.h"
#import "SKWRemotePerson.h"

// View
#import "SKWVideoView.h"
#import "SKWCameraPreviewView.h"

// Media
#import "SKWAudioSource.h"
#import "SKWMicrophoneAudioSource.h"
#import "SKWVideoSource.h"
#import "SKWCameraVideoSource.h"
#import "SKWFileVideoSource.h"
#import "SKWCustomFrameVideoSource.h"
#import "SKWDataSource.h"

// Type
#import "Type.h"
#import "SKWCodec.h"
#import "SKWEncoding.h"
#import "SKWWebRTCStats.h"
#import "SKWWebRTCStatsReport.h"
#import "SKWPublicationOptions.h"
#import "SKWSubscriptionOptions.h"
#import "SKWErrorFactory.h"

