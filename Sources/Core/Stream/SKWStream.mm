//
//  SKWStream.mm
//  SkyWay
//
//  Created by sandabu on 2022/02/04.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#import "SKWStream.h"
#import "SKWStream+Internal.h"
#import "Type+Internal.h"
#import "NSString+StdString.h"

#import <skyway/core/interface/stream.hpp>

using NativeStream = skyway::core::interface::Stream;

@implementation SKWStream

-(id _Nonnull)initWithSharedNative:(std::shared_ptr<NativeStream>)native {
    if(self = [super init]) {
        _native = native;
    }
    return self;
}

-(NSString* _Nonnull)id {
    return [NSString stringForStdString:_native->Id()];
}

-(SKWSide)side{
    return SKWSideFromNativeSide(_native->Side());
}

-(SKWContentType)contentType {
    return SKWContentTypeFromNativeContentType(_native->ContentType());
}

@end
