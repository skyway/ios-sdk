//
//  SKWLocalAudioStream.mm
//  SkyWay
//
//  Created by sandabu on 2022/03/10.
//  Copyright © 2022 NTT Communications. All rights reserved.
//
#import <WebRTC/WebRTC.h>

#import "SKWContext+Internal.h"
#import "SKWLocalAudioStream.h"

#import "NSString+StdString.h"

#import <skyway/core/stream/local/audio_stream.hpp>

#import "RTCAudioTrack+Private.h"
#import "SKWStream+Internal.h"

using NativeLocalAudioStream = skyway::core::stream::local::LocalAudioStream;

@implementation SKWLocalAudioStream

- (id _Nonnull)init {
    RTCPeerConnectionFactory* pcFactory = SKWContext.pcFactory;
    NSString* trackId                   = [[[NSUUID UUID] UUIDString] lowercaseString];
    RTCAudioTrack* track                = [pcFactory audioTrackWithTrackId:trackId];
    auto nativeTrack                    = track.nativeAudioTrack;
    auto native                         = std::make_shared<NativeLocalAudioStream>(nativeTrack);

    self = [super initWithSharedNative:native];
    return self;
}

@end
