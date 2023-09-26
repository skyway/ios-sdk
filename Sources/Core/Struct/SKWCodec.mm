//
//  SKWCodec.mm
//  SkyWay
//
//  Created by sandabu on 2022/04/01.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#import "SKWCodec.h"
#import "NSString+StdString.h"
#import "SKWCodec+Internal.h"

@implementation SKWCodec

- (id _Nonnull)initWithMimeType:(NSString* _Nonnull)mimeType {
    if (self = [super init]) {
        _mimeType = mimeType;
    }
    return self;
}

+ (SKWCodec*)codecForNativeCodec:(NativeCodec)nativeCodec {
    NSString* mimeType = [NSString stringForStdString:nativeCodec.mime_type];
    SKWCodec* codec    = [[SKWCodec alloc] init];
    codec.mimeType     = mimeType;
    return codec;
}

- (NativeCodec)nativeCodec {
    auto nativeMimeType = [NSString stdStringForString:_mimeType];
    NativeCodec nativeCodec;
    nativeCodec.mime_type = nativeMimeType;
    return nativeCodec;
}

@end
