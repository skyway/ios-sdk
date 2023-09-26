//
//  Type.h
//  SkyWay
//
//  Created by sandabu on 2022/03/31.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef Type_h
#define Type_h

#import <Foundation/Foundation.h>

///
/// ログのレベル一覧
///
typedef NS_ENUM(NSUInteger, SKWLogLevel) {
    ///
    /// デフォルト値。異常に関する情報を出力します。このエラーが発生したメソッドからは無効値が返されます。
    ///
    SKWLogLevelError,

    ///
    /// SDK内部で発生した一時的なエラーに関する情報を出力します。
    ///
    SKWLogLevelWarn,

    ///
    /// SDK が提供しているメソッドの呼び出しに関する情報を出力します。
    ///
    SKWLogLevelInfo,

    ///
    /// イベントの発火やリクエスト・レスポンスに関する情報など、デバッグ時に参考となる情報を出力します。
    ///
    SKWLogLevelDebug,

    ///
    /// メモリの破棄など、最も詳細なログを出力します。
    ///
    SKWLogLevelTrace,

    ///
    /// ログを出力しません。
    ///
    SKWLogLevelOff,
} NS_SWIFT_NAME(LogLevel);

typedef NS_ENUM(NSUInteger, SKWSide) {
    SKWSideLocal,
    SKWSideRemote,
} NS_SWIFT_NAME(Side);

typedef NS_ENUM(NSUInteger, SKWMemberType) {
    SKWMemberTypePerson,
    SKWMemberTypeBot,
} NS_SWIFT_NAME(MemberType);

typedef NS_ENUM(NSUInteger, SKWContentType) {
    SKWContentTypeAudio,
    SKWContentTypeVideo,
    SKWContentTypeData,
} NS_SWIFT_NAME(ContentType);

typedef NS_ENUM(NSUInteger, SKWRoomType) {
    SKWRoomTypeP2P,
    SKWRoomTypeSFU,
} NS_SWIFT_NAME(RoomType);

typedef NS_ENUM(NSUInteger, SKWRoomState) {
    SKWRoomStateOpened,
    SKWRoomStateClosed,
} NS_SWIFT_NAME(RoomState);

typedef NS_ENUM(NSUInteger, SKWTurnPolicy) {
    /// TURNが有効なモード
    ///
    /// SkyWay Auth Tokenのturnが有効のとき、TURNサーバが利用されることがあります。
    ///
    /// TURNについてはこちらをご覧ください。
    ///
    /// https://skyway.ntt.com/ja/docs/user-guide/turn/
    SKWTurnPolicyEnable,
    /// TURNが無効なモード
    ///
    /// SkyWay Auth Tokenのturnが有効であっても、TURNサーバ経由で通信されません。
    ///
    /// TURNについてはこちらをご覧ください。
    ///
    /// https://skyway.ntt.com/ja/docs/user-guide/turn/
    SKWTurnPolicyDisable,
    /// TURNサーバ経由を強制するモード
    ///
    /// TURNについてはこちらをご覧ください。
    ///
    /// https://skyway.ntt.com/ja/docs/user-guide/turn/
    SKWTurnPolicyTurnOnly,
} NS_SWIFT_NAME(TurnPolicy);

typedef NS_ENUM(NSUInteger, SKWConnectionState) {
    SKWNew,
    SKWConnecting,
    SKWConnected,
    SKWReconnecting,
    SKWDisconnected,
} NS_SWIFT_NAME(ConnectionState);

#endif /* Type_h */
