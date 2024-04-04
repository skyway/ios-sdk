//
//  SKWLocalDataStream_h
//  SkyWay
//
//  Created by sandabu on 2022/03/22.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWLocalDataStream_h
#define SKWLocalDataStream_h

#import "SKWLocalStream.h"

/// LocalDataStreamクラス
///
/// Sourceの`createStream()`から生成してください。
NS_SWIFT_NAME(LocalDataStream)
@interface SKWLocalDataStream : SKWLocalStream

- (id _Nonnull)init NS_UNAVAILABLE;

/// 文字列を送信します。
///
/// @param string 送信する文字列
- (void)writeString:(NSString* _Nonnull)string;

/// データを送信します。
///
/// @param data 送信するデータ
- (void)writeData:(NSData* _Nonnull)data;

@end

#endif /* SKWLocalDataStream_h */
