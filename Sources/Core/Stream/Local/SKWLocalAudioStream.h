//
//  SKWLocalAudioStream_h
//  SkyWay
//
//  Created by sandabu on 2022/03/10.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWLocalAudioStream_h
#define SKWLocalAudioStream_h

#import <AVFoundation/AVFoundation.h>

#import "SKWLocalStream.h"


/// LocalAudioStreamクラス
///
/// Sourceの`createStream()`から生成してください。
NS_SWIFT_NAME(LocalAudioStream)
@interface SKWLocalAudioStream : SKWLocalStream

/// イニシャライザ
-(id _Nonnull)init;

@end


#endif /* SKWLocalAudioStream_h */
