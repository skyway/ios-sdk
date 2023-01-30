//
//  SKWPublicationOptions.h
//  SkyWay
//
//  Created by sandabu on 2022/04/01.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWPublicationOptions_h
#define SKWPublicationOptions_h

#import "SKWCodec.h"
#import "SKWEncoding.h"

NS_SWIFT_NAME(PublicationOptions)
@interface SKWPublicationOptions: NSObject

/// Publicationに付与するメタデータ
@property NSString* _Nullable metadata;

/// 指定コーデック
///
/// SkyWayが対応していないコーデックが選択された場合はこのオプションは無視されます。
///
/// SFU Botは非対応です。 SFU RoomのPublishまたはSFU BotにおけるStartForwardingでこの値が設定されている場合は失敗します。
@property NSArray<SKWCodec*>* _Nonnull codecCapabilities;

/// エンコーディング設定
///
/// SFUを利用する場合、複数設定がある場合のみサイマルキャストが有効になります。
///
/// P2P通信において複数設定されている場合は最大ビットレートが低いまたはスケールダウン指数が高いエンコーディング設定が有効になります。
@property NSArray<SKWEncoding*>* _Nonnull encodings;

/// Publicationが有効かどうか
@property BOOL isEnabled;

@end

#endif /* SKWPublicationOptions_h */
