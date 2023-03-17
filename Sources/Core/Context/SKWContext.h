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
#import "SKWContextOptions.h"
#import "Type.h"


/// SkyWay全体の設定、取得を行うStaticなコンテキスト
NS_SWIFT_NAME(Context)
@interface SKWContext: NSObject

typedef void (^SKWContextSetupCompletion)(NSError* _Nullable);
typedef void (^SKWChannelDisposeCompletion)(NSError* _Nullable);

@property(class, nonatomic, readonly) NSArray<SKWPlugin*>* _Nonnull plugins;

-(id _Nonnull)init NS_UNAVAILABLE;

/// SkyWayの初期化をします。
///
/// SkyWayを利用するためには必ずこのAPIをコールする必要があります。
///
/// @param token JWT形式のSkyWayAuthToken
/// @param options 初期化 オプション
/// @param completion 完了コールバック
+(void)setupWithToken:(NSString* _Nonnull)token options:(SKWContextOptions* _Nullable)options completion:(SKWContextSetupCompletion _Nullable)completion;



/// SkyWayAuthTokenを更新します。
///
/// @param token 新しいSkyWayAuthToken
/// @return 更新成功かどうか
+(bool)updateToken:(NSString* _Nonnull)token;


/// [内部向けAPI]
///
/// このAPIは内部向けのものであり、サポート対象外です。
+(void)_updateRTCConfig:(SKWContextOptionsRTCConfig* _Nonnull)config;

/// プラグインを登録します。
///
/// @param plugin プラグイン
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

// Channelイベントデリゲート
NS_SWIFT_NAME(ContextDelegate)
@protocol SKWContextDelegate <NSObject>
@optional

/// SkyWayサーバと再接続開始後にコールされるイベント
-(void)startReconnecting;

/// SkyWayサーバと再接続成功後にコールされるイベント
-(void)reconnectingSucceeded;

/// トークンが期限切れにより失効した後にコールされるイベント
- (void)tokenExpired;

/// トークンの失効が切れる前にコールされるイベント
///
/// このイベントがどの程度前にコールされるかの時間は`ContextOptions`の`token`から設定できます。
- (void)shouldUpdateToken;

/// SkyWay内部で回復不能なエラーが発生した後にコールされるイベント
///
/// 再度ご利用いただくためには、インターネット接続状況を確認した上で`dispose(completion:)`をコールして完了コールバックを待った後、再度`setup(withToken:options:completion:)`をコールし直してください。
///
/// また、`dispose(completion:)`をコール後はそれまでSDKで生成されたリソースにアクセスしないでください。クラッシュする可能性があります。
///
- (void)fatalErrorOccurred:(NSError* _Nonnull)error;

@end

@interface SKWContext()

/// イベントデリゲート
@property (class, weak, nonatomic) id<SKWContextDelegate> _Nullable delegate;

@end


#endif /* SKWContext_h */
