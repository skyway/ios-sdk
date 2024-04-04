//
//  SKWContextOptions.h
//  SkyWay
//
//  Created by Naoto Takahashi on 2023/02/03.
//  Copyright © 2023 NTT Communications. All rights reserved.
//

#ifndef SKWContextOptions_h
#define SKWContextOptions_h

#import "Type.h"

NS_SWIFT_NAME(ContextOptionsRTCAPI)
@interface SKWContextOptionsRTCAPI : NSObject

@property(nonatomic) NSString* _Nullable domain;
@property(nonatomic) BOOL secure;

@end

NS_SWIFT_NAME(ContextOptionsICEParams)
@interface SKWContextOptionsICEParams : NSObject

@property(nonatomic) NSString* _Nullable domain;
@property(nonatomic) int version;
@property(nonatomic) BOOL secure;

@end

NS_SWIFT_NAME(ContextOptionsSignaling)
@interface SKWContextOptionsSignaling : NSObject

@property(nonatomic) NSString* _Nullable domain;
@property(nonatomic) BOOL secure;

@end

NS_SWIFT_NAME(ContextOptionsAnalytics)
@interface SKWContextOptionsAnalytics : NSObject

@property(nonatomic) NSString* _Nullable domain;
@property(nonatomic) BOOL secure;

@end

/// WebRTCに関するオプション
NS_SWIFT_NAME(ContextOptionsRTCConfig)
@interface SKWContextOptionsRTCConfig : NSObject

/// TURNサーバに関するポリシー
@property(nonatomic) SKWTurnPolicy policy;

@end

NS_SWIFT_NAME(ContextOptionsToken)
@interface SKWContextOptionsToken : NSObject

/// トークン失効リマインダー時間(秒)
///
/// `Context.delegate`がセットされている時に有効です。
///
/// デフォルトは60秒です。
@property(nonatomic) int remindTimeInSec;

@end

NS_SWIFT_NAME(ContextOptions)
@interface SKWContextOptions : NSObject

/// ログレベル
@property(nonatomic) SKWLogLevel logLevel;

/// 内部向けオプション
@property(nonatomic) SKWContextOptionsRTCAPI* _Nonnull rtcApi;
/// 内部向けオプション
@property(nonatomic) SKWContextOptionsICEParams* _Nonnull iceParams;
/// 内部向けオプション
@property(nonatomic) SKWContextOptionsSignaling* _Nonnull signaling;
/// 内部向けオプション
@property(nonatomic) SKWContextOptionsAnalytics* _Nonnull analytics;
/// WebRTCに関するオプション
@property(nonatomic) SKWContextOptionsRTCConfig* _Nonnull rtcConfig;
/// SkyWayAuthTokenに関するオプション
@property(nonatomic) SKWContextOptionsToken* _Nonnull token;

@end

#endif /* SKWContextOptions_h */
