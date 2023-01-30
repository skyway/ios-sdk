//
//  SKWContext_h
//  SkyWay
//
//  Created by sandabu on 2022/02/04.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWContext_h
#define SKWContext_h

#import <Foundation/Foundation.h>
#import "SKWPlugin.h"
#import "Type.h"

NS_SWIFT_NAME(ContextOptionsRTCAPI)
@interface SKWContextOptionsRTCAPI: NSObject

@property(nonatomic) NSString* _Nullable domain;
@property(nonatomic) BOOL secure;

@end

NS_SWIFT_NAME(ContextOptionsICEParams)
@interface SKWContextOptionsICEParams: NSObject

@property(nonatomic) NSString* _Nullable domain;
@property(nonatomic) int version;
@property(nonatomic) BOOL secure;

@end

NS_SWIFT_NAME(ContextOptionsSignaling)
@interface SKWContextOptionsSignaling: NSObject

@property(nonatomic) NSString* _Nullable domain;
@property(nonatomic) BOOL secure;

@end

/// WebRTCに関するオプション
NS_SWIFT_NAME(ContextOptionsRTCConfig)
@interface SKWContextOptionsRTCConfig: NSObject

@property(nonatomic) SKWTurnPolicy policy;

@end

NS_SWIFT_NAME(ContextOptions)
@interface SKWContextOptions: NSObject

@property(nonatomic) SKWLogLevel logLevel;
@property(nonatomic) SKWContextOptionsRTCAPI* _Nonnull rtcApi;
@property(nonatomic) SKWContextOptionsICEParams* _Nonnull iceParams;
@property(nonatomic) SKWContextOptionsSignaling* _Nonnull signaling;
@property(nonatomic) SKWContextOptionsRTCConfig* _Nonnull rtcConfig;

@end


/// SkyWay全体の設定、取得を行うStaticなコンテキスト
NS_SWIFT_NAME(Context)
@interface SKWContext: NSObject

typedef void (^SKWContextSetupCompletion)(NSError* _Nullable);
typedef void (^SKWChannelDisposeCompletion)(NSError* _Nullable);

@property(class, nonatomic, readonly) NSArray<SKWPlugin*>* _Nonnull plugins;

/// SkyWayの初期化をします。
///
/// SkyWayを利用するためには必ずこのAPIをコールする必要があります。
///
/// @param token JWT形式のAuthトークン 
/// @param options 初期化 オプション
/// @param completion 完了コールバック
+(void)setupWithToken:(NSString* _Nonnull)token options:(SKWContextOptions* _Nullable)options completion:(SKWContextSetupCompletion _Nullable)completion;


/// Authトークンを更新します。
///
/// @param token 新しいAuthトークン
/// @return 更新成功かどうか
+(bool)updateToken:(NSString* _Nonnull)token;

+(void)registerPlugin:(SKWPlugin* _Nonnull)plugin;

/// コンテキストを破棄し、全ての接続を切断します。
///
/// SkyWayの利用が不要になった時にコールしてください。
///
/// Dispose完了後にSDKで生成されたリソースにアクセスしないでください。
///
/// `setup(withToken:options:completion)`を再度コールすることで利用可能になります。
+(void)disposeWithCompletion:(SKWChannelDisposeCompletion _Nullable)completion;

@end

#endif /* SKWContext_h */
