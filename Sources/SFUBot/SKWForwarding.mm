//
//  SKWForwarding.mm
//  SkyWay
//
//  Created by sandabu on 2022/03/30.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#import "SKWForwarding.h"
#import "SKWForwarding+Internal.h"
#import "NSString+StdString.h"

using NativeForwardingListener = skyway::plugin::sfu_bot::Forwarding::EventListener;

@implementation SKWForwardingConfigure
@end

class ForwardingListener: public NativeForwardingListener {
public:
    ForwardingListener(SKWForwarding* forwarding)
        : forwarding_(forwarding) {}
    void OnStopped() override {
        if([forwarding_.delegate respondsToSelector:@selector(forwardingDidStop:)]) {
            [forwarding_.delegate forwardingDidStop:forwarding_];
        }
        
    }
private:
    SKWForwarding* forwarding_;
};

@interface SKWForwarding(){
    std::unique_ptr<ForwardingListener> listener;
}

@end


@implementation SKWForwarding

-(id _Nonnull)initWithNative:(NativeForwarding*)native repository:(ChannelStateRepository* _Nonnull)repository{
    if(self = [super init]) {
        _native = native;
        _repository = repository;
        listener = std::make_unique<ForwardingListener>(self);
        _native->AddEventListener(listener.get());
    }
    return self;
}

-(NSString* _Nonnull)identifier {
    return [NSString stringForStdString:_native->Id()];
}

-(SKWForwardingState)state {
    switch (_native->State()) {
        case skyway::plugin::sfu_bot::ForwardingState::kStarted:
            return SKWForwardingStateStarted;
        case skyway::plugin::sfu_bot::ForwardingState::kStopped:
            return SKWForwardingStateStopped;
    }
}

-(SKWForwardingConfigure* _Nonnull)configure {
    SKWForwardingConfigure* conf = [[SKWForwardingConfigure alloc] init];
    auto nativeConf = _native->Configure();
    if(nativeConf.max_subscribers) {
        conf.maxSubscribers = nativeConf.max_subscribers;
    }
    return conf;
}

-(SKWPublication* _Nonnull)originPublication {
    return [self.repository findPublicationByPublicationID:_native->OriginPublication()->Id()];
}

-(SKWPublication* _Nonnull)relayingPublication {
    return [self.repository findPublicationByPublicationID:_native->RelayingPublication()->Id()];
}

@end
