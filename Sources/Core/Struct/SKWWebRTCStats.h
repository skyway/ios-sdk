//
//  SKWWebRTCStats.h
//  SkyWay
//
//  Created by Naoto Takahashi on 2023/02/27.
//  Copyright © 2023 NTT Communications. All rights reserved.
//

#ifndef SKWWebRTCStats_h
#define SKWWebRTCStats_h

#import "SKWWebRTCStatsReport.h"

__attribute__((deprecated("SkyWayCore v2.0.0で非推奨となりました。"))) NS_SWIFT_NAME(WebRTCStats)
    @interface SKWWebRTCStats : NSObject

/// WebRTC統計情報の一覧
@property(nonatomic, readonly) NSArray<SKWWebRTCStatsReport*>* _Nonnull reports;

- (id _Nonnull)init NS_UNAVAILABLE;

@end

#endif /* SKWWebRTCStats_h */
