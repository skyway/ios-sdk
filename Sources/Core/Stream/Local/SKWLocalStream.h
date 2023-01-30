//
//  SKWLocalStream_h
//  SkyWay
//
//  Created by sandabu on 2022/02/04.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWLocalStream_h
#define SKWLocalStream_h

#import "SKWStream.h"


/// 抽象LocalStreamクラス
///
/// LocalPersonはLocalStreamをSourceから作成し、Publishすることができます。
///
/// 同じLocalStreamインスタンスを複数回Publishすることはできません。
NS_SWIFT_NAME(LocalStream)
@interface SKWLocalStream: SKWStream

-(id _Nonnull)init NS_UNAVAILABLE;

@end

#endif /* SKWLocalStream_h */
