//
//  SKWWebRTCStats.mm
//  SkyWay
//
//  Created by Naoto Takahashi on 2023/02/27.
//  Copyright © 2023 NTT Communications. All rights reserved.
//

#import "SKWWebRTCStats+Internal.h"
#import "SKWWebRTCStatsReport+Internal.h"
#import "NSString+StdString.h"

@implementation SKWWebRTCStats

-(id _Nonnull)initWithNativeStats:(skyway::model::WebRTCStats)stats {
    if(self = [super init]) {
        NSMutableArray<SKWWebRTCStatsReport*>* reports = [NSMutableArray array];
        for(const auto& report : stats.reports) {
            [reports addObject:[[SKWWebRTCStatsReport alloc] initWithNativeReport:report]];
        }
        _reports = reports;
    }
    return self;
}

@end

