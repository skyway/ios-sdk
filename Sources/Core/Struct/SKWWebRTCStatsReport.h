//
//  SKWWebRTCStatsReport.h
//  SkyWay
//
//  Created by Naoto Takahashi on 2023/02/27.
//  Copyright © 2023 NTT Communications. All rights reserved.
//

#ifndef SKWWebRTCStatsReport_h
#define SKWWebRTCStatsReport_h

#import <Foundation/Foundation.h>

/// WebRTC統計情報の一覧
///
/// 併せて公式サイトの通信状態の統計的分析もご確認ください。
/// https://skyway.ntt.com/ja/docs/user-guide/tips/getstats/
NS_SWIFT_NAME(WebRTCStatsReport)
@interface SKWWebRTCStatsReport : NSObject

/// 統計情報のID
@property(nonatomic, readonly) NSString* _Nonnull id;

/// 統計情報のType
///
/// Type一覧はこちらをご確認ください。
/// https://w3c.github.io/webrtc-stats/#rtctatstype-*
@property(nonatomic, readonly) NSString* _Nonnull type;

/// IDとType以外のパラメータ
///
/// パラメータはtypeに応じて値が異なります。
///
/// 例えば、typeが`codec`の場合はこのkey, valueの組み合わせになります。
///
/// https://w3c.github.io/webrtc-stats/#codec-dict*
///
/// valueの取りうる値の型は、NSString, NSNumber , NSDataです。
///
/// BoolはNSNumber(0 or 1)で表現されます。
///
/// 配列・オブジェクトの場合、JSON文字列をNSData型で返します。
@property(nonatomic, readonly) NSDictionary<NSString*, NSObject*>* _Nonnull params;

- (id _Nonnull)init NS_UNAVAILABLE;

@end

#endif /* SKWWebRTCStatsReport_h */
