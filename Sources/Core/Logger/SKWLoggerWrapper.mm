//
//  SKWLogger.mm
//  SkyWayCore
//
//  Created by Naoto Takahashi on 2023/04/21.
//  Copyright © 2023 NTT Communications. All rights reserved.
//

#import "SKWLoggerWrapper.h"

#import "NSString+StdString.h"

#include <skyway/global/interface/logger.hpp>

@implementation SKWLoggerWrapper

+ (void)traceLogWithMessage:(NSString* _Nonnull)message
                   filename:(NSString* _Nonnull)filename
                   function:(NSString* _Nonnull)function
                       line:(int)line {
    auto nativeLogger = skyway::global::interface::Logger::Shared();
    if (nativeLogger) {
        nativeLogger->Trace(message.stdString, filename.stdString, function.stdString, line);
    }
}
+ (void)debugLogWithMessage:(NSString* _Nonnull)message
                   filename:(NSString* _Nonnull)filename
                   function:(NSString* _Nonnull)function
                       line:(int)line {
    auto nativeLogger = skyway::global::interface::Logger::Shared();
    if (nativeLogger) {
        nativeLogger->Debug(message.stdString, filename.stdString, function.stdString, line);
    }
}
+ (void)infoLogWithMessage:(NSString* _Nonnull)message
                  filename:(NSString* _Nonnull)filename
                  function:(NSString* _Nonnull)function
                      line:(int)line {
    auto nativeLogger = skyway::global::interface::Logger::Shared();
    if (nativeLogger) {
        nativeLogger->Info(message.stdString, filename.stdString, function.stdString, line);
    }
}
+ (void)warnLogWithMessage:(NSString* _Nonnull)message
                  filename:(NSString* _Nonnull)filename
                  function:(NSString* _Nonnull)function
                      line:(int)line {
    auto nativeLogger = skyway::global::interface::Logger::Shared();
    if (nativeLogger) {
        nativeLogger->Warn(message.stdString, filename.stdString, function.stdString, line);
    }
}
+ (void)errorLogWithMessage:(NSString* _Nonnull)message
                   filename:(NSString* _Nonnull)filename
                   function:(NSString* _Nonnull)function
                       line:(int)line {
    auto nativeLogger = skyway::global::interface::Logger::Shared();
    if (nativeLogger) {
        nativeLogger->Error(message.stdString, filename.stdString, function.stdString, line);
    }
}

@end
