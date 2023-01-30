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
typedef NS_ENUM(NSUInteger, SKWLogLevel) {
    SKWLogLevelError,
    SKWLogLevelWarn,
    SKWLogLevelInfo,
    SKWLogLevelDebug,
    SKWLogLevelTrace,
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
    SKWTurnPolicyEnable,
    SKWTurnPolicyDisable,
    SKWTurnPolicyTurnOnly,
} NS_SWIFT_NAME(TurnPolicy);

#endif /* Type_h */
