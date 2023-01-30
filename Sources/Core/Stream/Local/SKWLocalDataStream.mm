//
//  SKWLocalDataStream.mm
//  SkyWay
//
//  Created by sandabu on 2022/03/22.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#import "SKWLocalDataStream+Internal.h"

#import "NSString+StdString.h"
#import "SKWStream+Internal.h"

#import <skyway/core/stream/local/data_stream.hpp>

using NativeLocalDataStream = skyway::core::stream::local::LocalDataStream;

@implementation SKWLocalDataStream

-(id _Nonnull)initWithVoid {
    auto native = std::make_shared<NativeLocalDataStream>();

    self = [super initWithSharedNative:native];
    return self;
}

-(void)writeString:(NSString* _Nonnull)string {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        auto native = std::static_pointer_cast<NativeLocalDataStream>(self.native);
        native->Write([NSString stdStringForString:string]);
    });
}
-(void)writeData:(NSData* _Nonnull)data{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        auto native = std::static_pointer_cast<NativeLocalDataStream>(self.native);
        auto bytes = reinterpret_cast<const uint8_t*>(data.bytes);
        auto length = data.length;
        native->Write(bytes, length);
    });
}

@end
