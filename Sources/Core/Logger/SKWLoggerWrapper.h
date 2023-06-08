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

/// 内部Swiftモジュール向けロガーラッパー
///
/// アプリケーションにおいてはこのクラスは不要です。
///
/// Core SDKでの内部ロギングは`SKW_DEBUG`などのNativeマクロを利用してください。
///
/// いずれも`Logger.mm`の実装が利用されます。
@interface SKWLoggerWrapper: NSObject

-(id _Nonnull)init NS_UNAVAILABLE;

+(void)traceLogWithMessage:(NSString* _Nonnull)message
                  filename:(NSString* _Nonnull)filename
                  function:(NSString* _Nonnull)function
                      line:(int)line;
+(void)debugLogWithMessage:(NSString* _Nonnull)message
                  filename:(NSString* _Nonnull)filename
                  function:(NSString* _Nonnull)function
                      line:(int)line;
+(void)infoLogWithMessage:(NSString* _Nonnull)message
                  filename:(NSString* _Nonnull)filename
                  function:(NSString* _Nonnull)function
                     line:(int)line;
+(void)warnLogWithMessage:(NSString* _Nonnull)message
                  filename:(NSString* _Nonnull)filename
                  function:(NSString* _Nonnull)function
                     line:(int)line;
+(void)errorLogWithMessage:(NSString* _Nonnull)message
                  filename:(NSString* _Nonnull)filename
                  function:(NSString* _Nonnull)function
                      line:(int)line;

@end

#endif /* SKWLoggerWrapper_h */
