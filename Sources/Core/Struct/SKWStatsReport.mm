//
//  SKWStatsReport.mm
//  SkyWay
//
//  Created by sandabu on 2022/04/01.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#import "SKWStatsReport.h"
#import "SKWStatsReport+Internal.h"
#import "NSString+StdString.h"

#include <boost/optional.hpp>

@implementation SKWStatsReportInboundRTP

+(SKWStatsReportInboundRTP*)inboundForNativeInbound:(NativeStatsReport::InboundRtp)nativeInbound{
    SKWStatsReportInboundRTP* inbound = [[SKWStatsReportInboundRTP alloc] init];
    inbound.bytesReceived = nativeInbound.bytes_received;
    return inbound;
}

-(NativeStatsReport::InboundRtp)nativeInbound{
    NativeStatsReport::InboundRtp nativeInbound;
    nativeInbound.bytes_received = _bytesReceived;
    return nativeInbound;
}

@end

@implementation SKWStatsReportOutboundRTP

+(SKWStatsReportOutboundRTP*)outboundForNativeOutbound:(NativeStatsReport::OutboundRtp)nativeOutbound{
    SKWStatsReportOutboundRTP* outbound = [[SKWStatsReportOutboundRTP alloc] init];
    outbound.bytesSent = nativeOutbound.bytes_sent;
    return outbound;
}

-(NativeStatsReport::OutboundRtp)nativeOutbound{
    NativeStatsReport::OutboundRtp nativeOutbound;
    nativeOutbound.bytes_sent = _bytesSent;
    return nativeOutbound;
}

@end


@implementation SKWStatsReport

+(SKWStatsReport*)statsReportForNativeStatsReport:(NativeStatsReport)nativeStatsReport{
    SKWStatsReport* report = [[SKWStatsReport alloc] init];
    if(nativeStatsReport.inbound){
        report.inbound = [SKWStatsReportInboundRTP inboundForNativeInbound:nativeStatsReport.inbound.get()];
    }
    if(nativeStatsReport.outbound){
        report.outbound = [SKWStatsReportOutboundRTP outboundForNativeOutbound:nativeStatsReport.outbound.get()];
    }
    return report;
}

-(NativeStatsReport)nativeStatsReport{
    NativeStatsReport nativeStatsReport;
    if(_inbound) {
        nativeStatsReport.inbound =  [_inbound nativeInbound];
    }
    if(_outbound) {
        nativeStatsReport.outbound =  [_outbound nativeOutbound];
    }
    return nativeStatsReport;
}

@end
