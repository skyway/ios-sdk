//
//  SKWAudioSource.h
//  SkyWay
//
//  Created by sandabu on 2022/05/17.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWAudioSource_h
#define SKWAudioSource_h

#import "SKWLocalAudioStream.h"

/// 音声入力ソースの抽象クラス
NS_SWIFT_NAME(AudioSource)
@interface SKWAudioSource : NSObject

- (id _Nonnull)init NS_UNAVAILABLE;

/// ストリームを作成します。
- (SKWLocalAudioStream* _Nonnull)createStream;

@end

#endif /* SKWAudioSource_h */
