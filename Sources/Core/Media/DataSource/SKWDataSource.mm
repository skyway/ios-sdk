//
//  SKWDataSource.mm
//  SkyWayRoom
//
//  Created by sandabu on 2022/06/07.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#import "SKWDataSource.h"

#import "SKWLocalDataStream+Internal.h"

@implementation SKWDataSource

- (SKWLocalDataStream* _Nonnull)createStream {
    return [[SKWLocalDataStream alloc] initWithVoid];
}

@end
