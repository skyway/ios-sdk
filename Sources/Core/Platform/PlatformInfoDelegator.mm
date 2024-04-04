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

namespace skyway {
namespace platform {

std::string PlatformInfoDelegator::GetPlatform() const { return "ios"; }

std::string PlatformInfoDelegator::GetOsInfo() const {
    NSString* systemName    = [UIDevice currentDevice].systemName;
    NSString* systemVersion = [UIDevice currentDevice].systemVersion;
    NSString* osInfo        = [NSString stringWithFormat:@"%@ %@", systemName, systemVersion];
    return [NSString stdStringForString:osInfo];
}

std::string PlatformInfoDelegator::GetModelName() const {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString* modelName = [NSString stringWithCString:systemInfo.machine
                                             encoding:NSUTF8StringEncoding];
    return [NSString stdStringForString:modelName];
}

}  // namespace platform
}  // namespace skyway
