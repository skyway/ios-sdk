//
//  SKWCodec.h
//  SkyWay
//
//  Created by sandabu on 2022/04/01.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWCodec_h
#define SKWCodec_h

#import <Foundation/Foundation.h>

/// コーデックパラメータ
NS_SWIFT_NAME(CodecParameters)
@interface SKWCodecParameters : NSObject

/// Opus DTXを利用するかどうか
///
/// 利用する場合、発話していない時の音声通信を停止します。
///
/// コーデックでOpusが利用される場合は、デフォルトで利用します。
///
/// 利用しない場合は以下のように設定します。
/// 　```
/// let codec: Codec = .init(mimeType: "audio/opus")
/// codec.parameters.useDTX = false
/// // and publish with codec options
/// ```
@property BOOL useDTX;

@end

/// コーデック設定
NS_SWIFT_NAME(Codec)
@interface SKWCodec : NSObject

- (id _Nonnull)init __attribute__((
    deprecated("SkyWayCore v1.6.0で非推奨となりました。`init(mimeType:)`をご利用ください。")));
- (id _Nonnull)initWithMimeType:(NSString* _Nonnull)mimeType;

/// コーデックのmimeType
///
/// サポートしているコーデックは公式サイトをご確認ください。
///
/// ex. `video/h264`, `audio/opus`
@property NSString* _Nonnull mimeType;

/// fmtpパラメータ設定
@property SKWCodecParameters* _Nonnull parameters;

@end

#endif /* SKWCodec_h */
