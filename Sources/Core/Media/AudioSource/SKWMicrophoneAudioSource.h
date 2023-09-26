//
//  SKWMicrophoneAudioSource.h
//  SkyWay
//
//  Created by sandabu on 2022/05/17.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWMicrophoneAudioSource_h
#define SKWMicrophoneAudioSource_h

#import "SKWAudioSource.h"
#import "SKWLocalAudioStream.h"

/// マイク入力ソース
NS_SWIFT_NAME(MicrophoneAudioSource)
@interface SKWMicrophoneAudioSource : SKWAudioSource

/// イニシャライザ
- (id _Nonnull)init;

// Override
- (SKWLocalAudioStream* _Nonnull)createStream;

@end

#endif /* SKWMicrophoneAudioSource_h */
