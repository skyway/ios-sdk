//
//  NSString+NotificationString.h
//  SkyWay
//
//  Created by sandabu on 2022/05/13.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef NSString_NotificationString_h
#define NSString_NotificationString_h

#import <Foundation/Foundation.h>

@interface NSString(NotificationString)

@property(class, nonatomic, readonly) NSNotificationName _Nonnull SKWCustomFrameVideoSourceDidUpdateFrame;
@property(class, nonatomic, readonly) NSString* _Nonnull SKWCustomFrameVideoSourceDidUpdateFrameKeyForFrame;

@end

#endif /* NSString_NotificationString_h */
