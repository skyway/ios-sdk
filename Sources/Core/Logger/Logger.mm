//
//  Logger.mm
//  SkyWay
//
//  Created by sandabu on 2022/07/21.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <os/log.h>
#import "NSString+StdString.h"

#include <string>
#include "./Logger.hpp"

@interface LoggerDelegator: NSObject
@property(nonatomic, readonly) LoggerInterface::Level level;
-(id)initWithLevel:(LoggerInterface::Level)level;
-(void)traceWithMessage:(NSString*)message filename:(NSString*)filename function:(NSString*)function line:(int)line;
-(void)debugWithMessage:(NSString*)message filename:(NSString*)filename function:(NSString*)function line:(int)line;
-(void)logMessageWithLevel:(LoggerInterface::Level)level message:(NSString*)message filename:(NSString*)filename function:(NSString*)function line:(int)line;
@end

@implementation LoggerDelegator
-(id)initWithLevel:(LoggerInterface::Level)level{
    if(self = [super init]) {
        _level = level;
    }
    return self;
}

-(void)traceWithMessage:(NSString*)message filename:(NSString*)filename function:(NSString*)function line:(int)line {
    if(_level == skyway::global::interface::Logger::kTrace) {
        [self logMessageWithLevel: skyway::global::interface::Logger::kTrace message:message filename:filename function:function line:line];
    }
}

-(void)debugWithMessage:(NSString*)message filename:(NSString*)filename function:(NSString*)function line:(int)line {
    if(_level == skyway::global::interface::Logger::kTrace ||
       _level == skyway::global::interface::Logger::kDebug) {
        [self logMessageWithLevel: skyway::global::interface::Logger::kDebug message:message filename:filename function:function line:line];
    }
}

-(void)infoWithMessage:(NSString*)message filename:(NSString*)filename function:(NSString*)function line:(int)line {
    if(_level == skyway::global::interface::Logger::kTrace ||
       _level == skyway::global::interface::Logger::kDebug ||
       _level == skyway::global::interface::Logger::kInfo) {
        [self logMessageWithLevel: skyway::global::interface::Logger::kInfo message:message filename:filename function:function line:line];
    }
}

-(void)warnWithMessage:(NSString*)message filename:(NSString*)filename function:(NSString*)function line:(int)line {
    if(_level == skyway::global::interface::Logger::kTrace ||
       _level == skyway::global::interface::Logger::kDebug ||
       _level == skyway::global::interface::Logger::kInfo ||
       _level == skyway::global::interface::Logger::kWarn) {
        [self logMessageWithLevel: skyway::global::interface::Logger::kWarn message:message filename:filename function:function line:line];
    }
}

-(void)errorWithMessage:(NSString*)message filename:(NSString*)filename function:(NSString*)function line:(int)line {
    if(_level == skyway::global::interface::Logger::kTrace ||
       _level == skyway::global::interface::Logger::kDebug ||
       _level == skyway::global::interface::Logger::kInfo ||
       _level == skyway::global::interface::Logger::kWarn ||
       _level == skyway::global::interface::Logger::kError) {
        [self logMessageWithLevel: skyway::global::interface::Logger::kError message:message filename:filename function:function line:line];
    }
}

-(void)logMessageWithLevel:(LoggerInterface::Level)level message:(NSString*)message filename:(NSString*)filename function:(NSString*)function line:(int)line {
    NSString* prefix = @"[skyway]";
    if(level == LoggerInterface::kTrace) {
        prefix = [prefix stringByAppendingString:@"[ TRACE ] "];
    }else if (level == LoggerInterface::kDebug) {
        prefix = [prefix stringByAppendingString:@"[📓DEBUG] "];
    } else if (level == LoggerInterface::kInfo) {
        prefix = [prefix stringByAppendingString:@"[📘INFO ] "];
    } else if (level == LoggerInterface::kWarn) {
        prefix = [prefix stringByAppendingString:@"[📙WARN ] "];
    } else if (level == LoggerInterface::kError) {
        prefix = [prefix stringByAppendingString:@"[📕ERROR] "];
    }
    NSString* suffix = [NSString stringWithFormat:@" | %@(%@:%d)", function, filename, line];
    NSString* output = [[prefix stringByAppendingString:message] stringByAppendingString:suffix];
    NSLog(@"%@", output);
}

@end

namespace skyway {
namespace global {

class Logger::Impl {
public:
    Impl(LoggerInterface::Level level) : delegator_([[LoggerDelegator alloc] initWithLevel:level]) {}
    LoggerDelegator* delegator_;
};


Logger::Logger(LoggerInterface::Level level) : impl_(std::make_unique<Impl>(level)) {}

Logger::~Logger() = default;

void Logger::Trace(const std::string& msg,
                   const std::string& filename,
                   const std::string& function,
                   int line) {
    [impl_->delegator_ traceWithMessage:[NSString stringForStdString:msg]
                               filename:[NSString stringForStdString:filename]
                               function:[NSString stringForStdString:function]
                                   line:line];
}
void Logger::Debug(const std::string& msg,
                   const std::string& filename,
                   const std::string& function,
                   int line) {
    [impl_->delegator_ debugWithMessage:[NSString stringForStdString:msg]
                               filename:[NSString stringForStdString:filename]
                               function:[NSString stringForStdString:function]
                                   line:line];
}
void Logger::Info(const std::string& msg,
                  const std::string& filename,
                  const std::string& function,
                  int line) {
    [impl_->delegator_ infoWithMessage:[NSString stringForStdString:msg]
                               filename:[NSString stringForStdString:filename]
                               function:[NSString stringForStdString:function]
                                   line:line];
}
void Logger::Warn(const std::string& msg,
                  const std::string& filename,
                  const std::string& function,
                  int line) {
    [impl_->delegator_ warnWithMessage:[NSString stringForStdString:msg]
                               filename:[NSString stringForStdString:filename]
                               function:[NSString stringForStdString:function]
                                   line:line];
}
void Logger::Error(const std::string& msg,
                   const std::string& filename,
                   const std::string& function,
                   int line) {
    [impl_->delegator_ errorWithMessage:[NSString stringForStdString:msg]
                               filename:[NSString stringForStdString:filename]
                               function:[NSString stringForStdString:function]
                                   line:line];
}

}
}
