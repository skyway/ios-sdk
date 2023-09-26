//
//  SKWRemoteDataStream.mm
//  SkyWay
//
//  Created by sandabu on 2022/03/22.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#import "SKWRemoteDataStream+Internal.h"

#import <skyway/core/stream/remote/data_stream.hpp>

#import "NSString+StdString.h"
#import "SKWStream+Internal.h"

using NativeRemoteDataStream = skyway::core::stream::remote::RemoteDataStream;

class RemoteDataStreamListener : public NativeRemoteDataStream::Listener {
public:
    RemoteDataStreamListener(SKWRemoteDataStream* stream, dispatch_group_t group)
        : stream_(stream), group_(group) {}
    void OnData(const std::string& nativeData) override {
        if ([stream_.delegate respondsToSelector:@selector(dataStream:didReceiveString:)]) {
            NSString* string = [NSString stringForStdString:nativeData];
            dispatch_group_async(
                group_, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                  [stream_.delegate dataStream:stream_ didReceiveString:string];
                });
        }
    }
    void OnDataBuffer(const uint8_t* nativeData, size_t length) override {
        if ([stream_.delegate respondsToSelector:@selector(dataStream:didReceiveData:)]) {
            NSData* data = [[NSData alloc] initWithBytes:nativeData length:length];
            dispatch_group_async(
                group_, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                  [stream_.delegate dataStream:stream_ didReceiveData:data];
                });
        }
    }

private:
    SKWRemoteDataStream* stream_;
    dispatch_group_t group_;
};

@interface SKWRemoteDataStream () {
    std::shared_ptr<RemoteDataStreamListener> listener;
}

@end

@implementation SKWRemoteDataStream

- (id _Nonnull)initWithSharedNative:(std::shared_ptr<NativeStream>)native
                         eventGroup:(dispatch_group_t _Nonnull)eventGroup {
    if (self = [super initWithSharedNative:native]) {
        self->listener        = std::make_shared<RemoteDataStreamListener>(self, eventGroup);
        auto nativeDataStream = std::static_pointer_cast<NativeRemoteDataStream>(native);
        nativeDataStream->AddListener(self->listener.get());
    }
    return self;
}

@end
