//
//  SKWEncoding.h
//  SkyWay
//
//  Created by sandabu on 2022/04/01.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWEncoding_h
#define SKWEncoding_h

#import <Foundation/Foundation.h>


/// エンコード設定
NS_SWIFT_NAME(Encoding)
@interface SKWEncoding: NSObject

/// エンコードID
///
/// Simulcastにおいてレイヤーを指定する場合はIDを指定できます。
///
/// ```
/// // On Publisher side
/// let lowEnc: Encoding = .init()
/// lowEnc.id = "low"
/// lowEnc.scaleResolutionDownBy = 4.0
///
/// // and publish with encoding options...
/// ```
/// ```
/// // On subscriber side
/// let options: SubscriptionOptions = .init()
/// options.preferredEncodingId = "low"
///
/// // and subscribe with options...
/// ```
@property NSString* _Nullable id;


/// 最大ビットレート
@property int maxBitrate;

/// 映像の解像度をスケールダウンさせる指数
///
/// このオプションはVideoStreamのみ有効です。
///
/// 例えば2.0を設定してPublishを行うと、縦横それぞれ半分の解像度にスケールダウンするのでオリジナルの映像の25%まで解像度が下がります。
/// 
/// デフォルトでは1.0です。
@property double scaleResolutionDownBy;

@end

#endif /* SKWEncoding_h */
