//
//  DispatchMainSync.mm
//  SkyWay
//
//  Created by Naoto Takahashi on 2023/04/27.
//  Copyright © 2023 NTT Communications. All rights reserved.
//

#import "DispatchMainSync.h"

void dispatch_main_sync(dispatch_block_t block) {
    if([NSThread isMainThread]) {
        block();
    }else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}


