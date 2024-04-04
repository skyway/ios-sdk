//
//  PlatformInfoDelegator.hpp
//  SkyWay
//
//  Created by Muranaka Kei on 2023/12/04.
//  Copyright © 2023 NTT Communications. All rights reserved.
//

#ifndef SKYWAY_PLATFORM_IOS_PLATFORM_INFO_DELEGATOR_HPP_
#define SKYWAY_PLATFORM_IOS_PLATFORM_INFO_DELEGATOR_HPP_

#include "skyway/platform/interface/platform_info_delegator.hpp"

namespace skyway {
namespace platform {

class PlatformInfoDelegator : public interface::PlatformInfoDelegator {
public:
    std::string GetPlatform() const override;
    std::string GetOsInfo() const override;
    std::string GetModelName() const override;
};

}  // namespace platform
}  // namespace skyway

#endif /* SKYWAY_PLATFORM_IOS_PLATFORM_INFO_DELEGATOR_HPP_ */
