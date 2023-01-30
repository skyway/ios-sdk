//
//  SKWRemoteAudioStream.mm
//  SkyWay
//
//  Created by sandabu on 2022/03/22.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#import "SKWRemoteAudioStream.h"
#import "SKWStream+Internal.h"

#import "RTCMediaStreamTrack+Private.h"

#import <skyway/core/stream/remote/audio_stream.hpp>

using NativeRemoteAudioStream = skyway::core::stream::remote::RemoteAudioStream;

@implementation SKWRemoteAudioStream

//-(void)setVolume:(double)volume{
//    auto nativeAudioStream = (NativeRemoteAudioStream*)self.native;
//    nativeAudioStream->SetVolume(volume);
//}
//
//-(double)getVolume {
//    auto nativeAudioStream = (NativeRemoteAudioStream*)self.native;
//    return nativeAudioStream->GetVolume();
//}

@end
