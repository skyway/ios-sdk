//
//  SKWLogger.mm
//  SkyWayCore
//
//  Created by Naoto Takahashi on 2023/04/21.
//  Copyright © 2023 NTT Communications. All rights reserved.
//

#import "SKWLogger.h"

#include "Logger.hpp"
#import "NSString+StdString.h"
#import "Type+Internal.h"
#import "Type.h"

class LoggerListener : public skyway::global::Logger::Listener {
public:
    LoggerListener(id<SKWLoggerDelegate> delegate) : delegate_(delegate) {}
    void OnLog(skyway::global::interface::Logger::Level nativeLevel,
               const std::string& nativeMessage) {
        if (delegate_ && [delegate_ respondsToSelector:@selector(didReceiveLog:atLevel:)]) {
            NSString* message = [NSString stringForStdString:nativeMessage];
            SKWLogLevel level = SKWLogLevelFromNativeLogLevel(nativeLevel);
            [delegate_ didReceiveLog:message atLevel:level];
        }
    }
    id<SKWLoggerDelegate> delegate_;
};

@implementation SKWLogger
static std::unique_ptr<LoggerListener> listener_ = nullptr;

+ (id<SKWLoggerDelegate> _Nullable)delegate {
    if (listener_) {
        return listener_->delegate_;
    }
    return nil;
}

+ (void)setDelegate:(id<SKWLoggerDelegate>)delegate {
    if (listener_) {
        skyway::global::Logger::UnregisterListener();
    }
    listener_ = std::make_unique<LoggerListener>(delegate);
    skyway::global::Logger::RegisterListener(listener_.get());
}

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
