//
//  SKWWebRTCStats+Internal.h
//  SkyWay
//
//  Created by Naoto Takahashi on 2023/03/01.
//  Copyright © 2023 NTT Communications. All rights reserved.
//

#ifndef SKWWebRTCStats_Private_h
#define SKWWebRTCStats_Private_h

#import "SKWWebRTCStats.h"

#import <skyway/core/interface/local_stream.hpp>

@interface SKWWebRTCStats()

-(id _Nonnull)initWithNativeStats:(skyway::model::WebRTCStats)stats;

@end

#endif /* SKWWebRTCStats_Private_h */
