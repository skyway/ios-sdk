//
//  SKWSubscriptionOptions.h
//  SkyWay
//
//  Created by Naoto Takahashi on 2022/09/01.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWSubscriptionOptions_h
#define SKWSubscriptionOptions_h

#import <Foundation/Foundation.h>

NS_SWIFT_NAME(SubscriptionOptions)
@interface SKWSubscriptionOptions : NSObject

//@property BOOL isEnabled;
@property(nonatomic) NSString* _Nullable preferredEncodingId;

@end

#endif /* SKWSubscriptionOptions_h */
