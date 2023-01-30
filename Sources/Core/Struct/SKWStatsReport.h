//
//  SKWStatsReport.h
//  SkyWay
//
//  Created by sandabu on 2022/04/01.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWStatsReport_h
#define SKWStatsReport_h

#import <Foundation/Foundation.h>

@interface SKWStatsReportInboundRTP: NSObject

@property uint64_t bytesReceived;

@end

@interface SKWStatsReportOutboundRTP: NSObject

@property uint64_t bytesSent;

@end

@interface SKWStatsReport: NSObject

@property SKWStatsReportInboundRTP* inbound;
@property SKWStatsReportOutboundRTP* outbound;

@end

#endif /* SKWStatsReport_h */
