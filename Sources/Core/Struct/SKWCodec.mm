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

@implementation SKWCodecParameters

- (id _Nonnull)init {
    if (self = [super init]) {
        _useDTX = YES;
    }
    return self;
}

+ (SKWCodecParameters*)parameterForNativeParameter:(NativeCodec::Parameters)nativeParameters {
    SKWCodecParameters* parameters = [[SKWCodecParameters alloc] init];
    parameters.useDTX = nativeParameters.use_dtx == boost::none || *nativeParameters.use_dtx;
    return parameters;
}
- (NativeCodec::Parameters)nativeParameter {
    NativeCodec::Parameters nativeParameters;
    nativeParameters.use_dtx = _useDTX;
    return nativeParameters;
}

@end

@implementation SKWCodec

- (id _Nonnull)initWithMimeType:(NSString* _Nonnull)mimeType {
    if (self = [super init]) {
        _mimeType   = mimeType;
        _parameters = [[SKWCodecParameters alloc] init];
    }
    return self;
}

+ (SKWCodec*)codecForNativeCodec:(NativeCodec)nativeCodec {
    NSString* mimeType = [NSString stringForStdString:nativeCodec.mime_type];
    SKWCodec* codec    = [[SKWCodec alloc] initWithMimeType:mimeType];
    codec.parameters   = [SKWCodecParameters parameterForNativeParameter:nativeCodec.parameters];
    return codec;
}

- (NativeCodec)nativeCodec {
    auto nativeMimeType = [NSString stdStringForString:_mimeType];
    NativeCodec nativeCodec;
    nativeCodec.mime_type  = nativeMimeType;
    nativeCodec.parameters = _parameters.nativeParameter;
    return nativeCodec;
}

@end
