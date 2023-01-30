//
//  SKWSubscriptionOptions.mm
//  SkyWay
//
//  Created by Naoto Takahashi on 2022/09/01.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#import "SKWSubscriptionOptions+Internal.h"
#import "NSString+StdString.h"

@implementation SKWSubscriptionOptions

-(id)init{
    if(self = [super init]) {
//        _isEnabled = true;
    }
    return self;
}

-(NativeSubscriptionOptions)nativeSubscriptionOptions {
    NativeSubscriptionOptions nativeOptions;
    if(_preferredEncodingId) {
        nativeOptions.preferred_encoding_id = [NSString stdStringForString:_preferredEncodingId];
    }
    return nativeOptions;
}

@end
