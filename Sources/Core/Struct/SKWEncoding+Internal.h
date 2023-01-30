//
//  SKWEncoding+Internal.h
//  SkyWay
//
//  Created by sandabu on 2022/04/01.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWEncoding_Internal_h
#define SKWEncoding_Internal_h

#import "SKWEncoding.h"

#import <skyway/model/domain.hpp>

using NativeEncoding = skyway::model::Encoding;

@interface SKWEncoding()

+(SKWEncoding*)encodingForNativeEncoding:(NativeEncoding)nativeEncoding;
-(NativeEncoding)nativeEncoding;

@end

#endif /* SKWEncoding_Internal_h */
