//
//  Logger.hpp
//  SkyWay
//
//  Created by sandabu on 2022/07/21.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef Logger_hpp
#define Logger_hpp

#include <skyway/global/interface/logger.hpp>

using LoggerInterface = skyway::global::interface::Logger;

namespace skyway {
namespace global {

class Logger: public LoggerInterface {
public:
    Logger(LoggerInterface::Level level);
    ~Logger();
    void Trace(const std::string& msg,
                       const std::string& filename,
                       const std::string& function,
                       int line)       override;
    void Debug(const std::string& msg,
                       const std::string& filename,
                       const std::string& function,
                       int line)       override;
    void Info(const std::string& msg,
                      const std::string& filename,
                      const std::string& function,
                      int line)        override;
    void Warn(const std::string& msg,
                      const std::string& filename,
                      const std::string& function,
                      int line)        override;
    void Error(const std::string& msg,
                       const std::string& filename,
                       const std::string& function,
                       int line)       override;
private:
    class Impl;
    std::unique_ptr<Impl> impl_;
};

}
}



#endif /* Logger_hpp */
