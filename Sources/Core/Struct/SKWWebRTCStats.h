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

/// WebRTC統計情報の一覧の構造体
///
/// 併せて公式サイトの通信状態の統計的分析もご確認ください。
/// https://skyway.ntt.com/ja/docs/user-guide/tips/getstats/
NS_SWIFT_NAME(WebRTCStats)
@interface SKWWebRTCStats: NSObject

/// WebRTC統計情報の一覧
@property(nonatomic, readonly) NSArray<SKWWebRTCStatsReport*>* _Nonnull reports;

-(id _Nonnull)init NS_UNAVAILABLE;

@end

#endif /* SKWWebRTCStats_h */
