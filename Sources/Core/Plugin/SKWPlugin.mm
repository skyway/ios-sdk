//
//  SKWPlugin.mm
//  SkyWay
//
//  Created by sandabu on 2022/03/30.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#import "NSString+StdString.h"
#import "SKWPlugin+Internal.h"

@implementation SKWPlugin

- (id _Nonnull)initWithUniqueNative:(std::unique_ptr<NativePlugin>)uniqueNative {
    if (self = [super init]) {
        _native       = uniqueNative.get();
        _uniqueNative = std::move(uniqueNative);
    }
    return self;
}

- (NSString* _Nonnull)subtype {
    return [NSString stringForStdString:_native->GetSubtype()];
}

- (std::unique_ptr<NativePlugin>)uniqueNative {
    return std::move(_uniqueNative);
}

// MARK: - SKWPlugin

- (SKWRemoteMember* _Nullable)createRemoteMemberWithNative:(NativeRemoteMember*)native
                                                repository:(ChannelStateRepository*)repository {
    [NSException raise:@"NotImplemented" format:@"Subclasses must implement a valid method"];
    return nil;
}

@end
