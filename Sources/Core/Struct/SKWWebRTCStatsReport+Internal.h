//
//  SKWWebRTCStatsReport+Internal.h
//  SkyWay
//
//  Created by Naoto Takahashi on 2023/03/01.
//  Copyright © 2023 NTT Communications. All rights reserved.
//

#ifndef SKWWebRTCStatsReport_Internal_h
#define SKWWebRTCStatsReport_Internal_h

#import <skyway/model/domain.hpp>
#import "SKWWebRTCStatsReport.h"

@interface SKWWebRTCStatsReport ()

- (id _Nonnull)initWithNativeReport:(skyway::model::WebRTCStatsReport)report;

@end

#endif /* SKWWebRTCStatsReport_Internal_h */
