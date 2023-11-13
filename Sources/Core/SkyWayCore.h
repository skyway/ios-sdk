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

// In this header, you should import all the public headers of your framework using statements like
// #import "SkyWayCore/PublicHeader.h"

// Core
#import "SKWChannel.h"
#import "SKWLocalPerson.h"
#import "SKWMember.h"
#import "SKWPublication.h"
#import "SKWRemoteMember.h"
#import "SKWSubscription.h"
#import "SKWUnknownMember.h"

// Context
#import "SKWContext.h"

// Stream
#import "SKWLocalAudioStream.h"
#import "SKWLocalDataStream.h"
#import "SKWLocalStream.h"
#import "SKWLocalVideoStream.h"
#import "SKWRemoteAudioStream.h"
#import "SKWRemoteDataStream.h"
#import "SKWRemoteStream.h"
#import "SKWRemoteVideoStream.h"
#import "SKWStream.h"

// Plugin
#import "SKWPlugin.h"
#import "SKWRemotePerson.h"

// View
#import "SKWCameraPreviewView.h"
#import "SKWVideoView.h"

// Media
#import "SKWAudioSource.h"
#import "SKWCameraVideoSource.h"
#import "SKWCustomFrameVideoSource.h"
#import "SKWDataSource.h"
#import "SKWFileVideoSource.h"
#import "SKWMicrophoneAudioSource.h"
#import "SKWVideoSource.h"

// Type
#import "SKWCodec.h"
#import "SKWEncoding.h"
#import "SKWErrorFactory.h"
#import "SKWLogger.h"
#import "SKWPublicationOptions.h"
#import "SKWSubscriptionOptions.h"
#import "SKWWebRTCStats.h"
#import "SKWWebRTCStatsReport.h"
#import "Type.h"
