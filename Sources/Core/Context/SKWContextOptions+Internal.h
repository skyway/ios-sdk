//
//  SKWContextOptions+Internal.h
//  SkyWay
//
//  Created by Naoto Takahashi on 2023/02/03.
//  Copyright © 2023 NTT Communications. All rights reserved.
//

#ifndef SKWContextOptions_Internal_h
#define SKWContextOptions_Internal_h

#import <skyway/core/context.hpp>

@interface SKWContextOptions()
-(skyway::core::ContextOptions)nativeOptions;
@end
#endif /* SKWContextOptions_Internal_h */
