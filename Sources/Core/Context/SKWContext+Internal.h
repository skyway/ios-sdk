//
//  SKWContext+Internal.h
//  SkyWay
//
//  Created by sandabu on 2022/03/29.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWContext_Internal_h
#define SKWContext_Internal_h

#import <WebRTC/WebRTC.h>

#import "SKWContext.h"


@interface SKWContext()

@property(class, nonatomic, readonly) RTCPeerConnectionFactory* _Nullable pcFactory;

@end


#endif /* SKWContext_Internal_h */
