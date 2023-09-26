//
//  SKWPublicationOptions.mm
//  SkyWay
//
//  Created by sandabu on 2022/04/01.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#import "SKWPublicationOptions.h"
#import "NSString+StdString.h"
#import "SKWPublicationOptions+Internal.h"

#import "SKWCodec+Internal.h"
#import "SKWEncoding+Internal.h"

@implementation SKWPublicationOptions

- (id)init {
    if (self = [super init]) {
        _isEnabled = true;
    }
    return self;
}

- (NativePublicationOptions)nativePublicationOptions {
    NativePublicationOptions nativeOptions;
    if (_metadata != nil) {
        nativeOptions.metadata = [NSString stdStringForString:_metadata];
    }
    for (SKWCodec* codec in _codecCapabilities) {
        nativeOptions.codec_capabilities.emplace_back(codec.nativeCodec);
    }
    for (SKWEncoding* encoding in _encodings) {
        nativeOptions.encodings.emplace_back(encoding.nativeEncoding);
    }
    return nativeOptions;
}

@end
