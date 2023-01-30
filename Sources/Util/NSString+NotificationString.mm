//
//  NSString+NotificationString.mm
//  SkyWayRoom
//
//  Created by sandabu on 2022/05/13.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#import "NSString+NotificationString.h"

@implementation NSString(NotificationString)

+(NSNotificationName)SKWCustomFrameVideoSourceDidUpdateFrame{
    return @"SKWCustomFrameVideoSourceDidUpdateFrame";
}

+(NSString* _Nonnull)SKWCustomFrameVideoSourceDidUpdateFrameKeyForFrame{
    return @"SKWCustomFrameVideoSourceDidUpdateFrameKeyForFrame";
}

@end
