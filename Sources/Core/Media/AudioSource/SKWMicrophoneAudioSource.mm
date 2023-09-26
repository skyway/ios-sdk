//
//  SKWMicrophoneAudioSource.mm
//  SkyWay
//
//  Created by sandabu on 2022/05/17.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#import "SKWMicrophoneAudioSource.h"
#import "SKWAudioSource+Internal.h"

@implementation SKWMicrophoneAudioSource

- (id _Nonnull)init {
    return [super initWithVoid];
}

- (SKWLocalAudioStream* _Nonnull)createStream {
    return [[SKWLocalAudioStream alloc] init];
}

@end
