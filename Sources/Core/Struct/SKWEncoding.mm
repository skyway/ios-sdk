//
//  SKWEncoding.mm
//  SkyWay
//
//  Created by sandabu on 2022/04/01.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#import "SKWEncoding.h"
#import "SKWEncoding+Internal.h"
#import "NSString+StdString.h"

#include <boost/optional.hpp>

@implementation SKWEncoding

+(SKWEncoding*)encodingForNativeEncoding:(NativeEncoding)nativeEncoding{
    SKWEncoding* encoding = [[SKWEncoding alloc] init];
    if(nativeEncoding.id) {
        encoding.id = [NSString stringForStdString:nativeEncoding.id.get()];
    }
    if(nativeEncoding.max_bitrate){
        encoding.maxBitrate = nativeEncoding.max_bitrate.get();
    }
    if(nativeEncoding.scale_resolution_down_by) {
        encoding.scaleResolutionDownBy = nativeEncoding.scale_resolution_down_by.get();
    }
    return encoding;
}

-(NativeEncoding)nativeEncoding{
    NativeEncoding nativeEncoding;
    if(_id) {
        nativeEncoding.id = [NSString stdStringForString:_id];
    }
    if(_maxBitrate) {
        nativeEncoding.max_bitrate =  _maxBitrate;
    }
    if(_scaleResolutionDownBy) {
        nativeEncoding.scale_resolution_down_by = _scaleResolutionDownBy;
    }
    return nativeEncoding;
}

@end
