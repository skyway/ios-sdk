//
//  PlatformInfoDelegator.mm
//  SkyWayCore
//
//  Created by Muranaka Kei on 2023/12/04.
//  Copyright © 2023 NTT Communications. All rights reserved.
//

#include "./PlatformInfoDelegator.hpp"

#import <UIKit/UIKit.h>
#import <sys/utsname.h>

#include "NSString+StdString.h"
#include "skyway/global/interface/logger.hpp"

@interface PlatformDelegator : NSObject

@property(nonatomic, readonly) NSString* platform;
@property(nonatomic, readonly) NSString* osInfo;
@property(nonatomic, readonly) NSString* modelName;
@property(nonatomic, readonly) NSString* sdkVersion;

- (id)init;

@end

@implementation PlatformDelegator

- (id)init {
    if (self = [super init]) {
        _platform = @"ios";

        // os
        NSString* systemName    = [UIDevice currentDevice].systemName;
        NSString* systemVersion = [UIDevice currentDevice].systemVersion;
        _osInfo                 = [NSString stringWithFormat:@"%@ %@", systemName, systemVersion];

        // model
        struct utsname systemInfo;
        uname(&systemInfo);
        _modelName = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];

        // sdk version
        NSBundle* bundle = [NSBundle bundleForClass:self.class];
        _sdkVersion      = [bundle infoDictionary][@"CFBundleShortVersionString"];
    }
    return self;
}

@end

namespace skyway {
namespace platform {

class PlatformInfoDelegator::Impl {
public:
    Impl() : delegator_([[PlatformDelegator alloc] init]) {}
    PlatformDelegator* delegator_;
};

PlatformInfoDelegator::PlatformInfoDelegator()
    : impl_(std::make_unique<PlatformInfoDelegator::Impl>()) {}

PlatformInfoDelegator::~PlatformInfoDelegator(){SKW_TRACE("~PlatformInfoDelegator")}

std::string PlatformInfoDelegator::GetPlatform() const {
    return [NSString stdStringForString:impl_->delegator_.platform];
}

std::string PlatformInfoDelegator::GetOsInfo() const {
    return [NSString stdStringForString:impl_->delegator_.osInfo];
}

std::string PlatformInfoDelegator::GetModelName() const {
    return [NSString stdStringForString:impl_->delegator_.modelName];
}

std::string PlatformInfoDelegator::GetSdkVersion() const {
    return [NSString stdStringForString:impl_->delegator_.sdkVersion];
}

}  // namespace platform
}  // namespace skyway
