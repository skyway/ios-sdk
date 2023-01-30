//
//  SKWSFUBotPlugin_h
//  SkyWay
//
//  Created by sandabu on 2022/03/23.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWSFUBotPlugin_h
#define SKWSFUBotPlugin_h

#import <SkyWayCore/SkyWayCore.h>

#import "SKWSFUBotMember.h"

/// SFUBotPluginオプション
NS_SWIFT_NAME(SFUBotPluginOptions)
@interface SKWSFUBotPluginOptions: NSObject

@property(nonatomic) NSString* _Nullable apiUrl;

@end

/// SFU Bot プラグイン
///
/// Contextに登録することでSFU Botを利用することができます。
///
/// ```swift
/// let sfu: SFUBotPlugin = .init(options: nil)
/// Context.registerPlugin(sfu)
/// ```
///
/// SFU Botに関しては公式ホームページの開発ドキュメントをご確認ください。
NS_SWIFT_NAME(SFUBotPlugin)
@interface SKWSFUBotPlugin : SKWPlugin


/// コンストラクタ
///
/// - Parameter options: オプション
-(id _Nonnull)initWithOptions:(SKWSFUBotPluginOptions* _Nullable)options;

typedef void (^SKWSFUBotPluginCreateBotOnChannelCompletion)(SKWSFUBotMember* _Nullable, NSError* _Nullable error);


/// SFUBotを作成し、Channelに入室させます。
///
/// - Parameters:
///   - channel: 入室させるChannel
///   - completion: 完了コールバック
-(void)createBotOnChannel:(SKWChannel* _Nonnull)channel completion:(SKWSFUBotPluginCreateBotOnChannelCompletion _Nullable)completion;
@end

#endif /* SKWSFUBotPlugin_h */
