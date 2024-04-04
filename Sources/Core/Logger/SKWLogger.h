//
//  SKWLoggerWrapper.h
//  SkyWay
//
//  Created by Naoto Takahashi on 2023/04/21.
//  Copyright © 2023 NTT Communications. All rights reserved.
//

#ifndef SKWLoggerWrapper_h
#define SKWLoggerWrapper_h

#import <Foundation/Foundation.h>
#import "Type.h"

NS_SWIFT_NAME(LoggerDelegate)
@protocol SKWLoggerDelegate <NSObject>
@optional

/// SkyWay内部で出力したログのハンドラです。
///
/// 出力されるログのレベルは`ContextOptions.logLevel`で設定した値に依存します。
///
/// @param log ログメッセージ
/// @param level  発生したログのレベル
- (void)didReceiveLog:(NSString* _Nonnull)log atLevel:(SKWLogLevel)level;

@end

///
/// 内部Swiftモジュール向けロガークラス
///
NS_SWIFT_NAME(Logger)
@interface SKWLogger : NSObject
/// イベントデリゲート
@property(class, weak, nonatomic) id<SKWLoggerDelegate> _Nullable delegate;

- (id _Nonnull)init NS_UNAVAILABLE;

+ (void)traceLogWithMessage:(NSString* _Nonnull)message
                   filename:(NSString* _Nonnull)filename
                   function:(NSString* _Nonnull)function
                       line:(int)line;
+ (void)debugLogWithMessage:(NSString* _Nonnull)message
                   filename:(NSString* _Nonnull)filename
                   function:(NSString* _Nonnull)function
                       line:(int)line;
+ (void)infoLogWithMessage:(NSString* _Nonnull)message
                  filename:(NSString* _Nonnull)filename
                  function:(NSString* _Nonnull)function
                      line:(int)line;
+ (void)warnLogWithMessage:(NSString* _Nonnull)message
                  filename:(NSString* _Nonnull)filename
                  function:(NSString* _Nonnull)function
                      line:(int)line;
+ (void)errorLogWithMessage:(NSString* _Nonnull)message
                   filename:(NSString* _Nonnull)filename
                   function:(NSString* _Nonnull)function
                       line:(int)line;
@end

#endif /* SKWLoggerWrapper_h */
