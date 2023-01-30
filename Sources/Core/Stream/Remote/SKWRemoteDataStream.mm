//
//  SKWRemoteDataStream.mm
//  SkyWay
//
//  Created by sandabu on 2022/03/22.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#import "SKWRemoteDataStream+Internal.h"

#import <skyway/core/stream/remote/data_stream.hpp>

#import "SKWStream+Internal.h"
#import "NSString+StdString.h"

using NativeRemoteDataStream = skyway::core::stream::remote::RemoteDataStream;


class RemoteDataStreamListener: public NativeRemoteDataStream::Listener {
public:
    RemoteDataStreamListener(SKWRemoteDataStream* stream)
        : stream_(stream) {}
    void OnData(const std::string& nativeData) override {
        if([stream_.delegate respondsToSelector:@selector(dataStream:didReceiveString:)]) {
            NSString* string = [NSString stringForStdString:nativeData];
            [stream_.delegate dataStream:stream_ didReceiveString:string];
        }
    }
    void OnDataBuffer(const uint8_t* nativeData, size_t length) override {
        if([stream_.delegate respondsToSelector:@selector(dataStream:didReceiveData:)]) {
            NSData* data = [[NSData alloc] initWithBytes:nativeData length:length];
            [stream_.delegate dataStream:stream_ didReceiveData:data];
        }
    }
private:
    SKWRemoteDataStream* stream_;
};

@interface SKWRemoteDataStream(){
    std::shared_ptr<RemoteDataStreamListener> listener;
}

@end

@implementation SKWRemoteDataStream

-(id _Nonnull)initWithSharedNative:(std::shared_ptr<NativeStream>)native {
    if(self = [super initWithSharedNative:native]) {
        self->listener = std::make_shared<RemoteDataStreamListener>(self);
        auto nativeDataStream = std::static_pointer_cast<NativeRemoteDataStream>(native);
        nativeDataStream->AddListener(self->listener.get());

    }
    return self;
}

@end
