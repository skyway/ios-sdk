//
//  SKWStatsReport+Internal.h
//  SkyWay
//
//  Created by sandabu on 2022/04/01.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWStatsReport_Internal_h
#define SKWStatsReport_Internal_h

#import "SKWStatsReport.h"

#import <skyway/model/domain.hpp>

using NativeStatsReport = skyway::model::StatsReport;

@interface SKWStatsReportInboundRTP()
+(SKWStatsReportInboundRTP*)inboundForNativeInbound:(NativeStatsReport::InboundRtp)nativeInbound;
-(NativeStatsReport::InboundRtp)nativeInbound;
@end

@interface SKWStatsReportOutboundRTP()
+(SKWStatsReportOutboundRTP*)outboundForNativeOutbound:(NativeStatsReport::OutboundRtp)nativeOutbound;
-(NativeStatsReport::OutboundRtp)nativeOutbound;
@end


@interface SKWStatsReport()

+(SKWStatsReport*)statsReportForNativeStatsReport:(NativeStatsReport)nativeStatsReport;
-(NativeStatsReport)nativeStatsReport;

@end

#endif /* SKWStatsReport_Internal_h */
