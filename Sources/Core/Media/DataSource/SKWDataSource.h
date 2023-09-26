//
//  SKWDataSource.h
//  SkyWay
//
//  Created by sandabu on 2022/06/07.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWDataSource_h
#define SKWDataSource_h

#import <Foundation/Foundation.h>

@class SKWLocalDataStream;

/// データ入力ソース
NS_SWIFT_NAME(DataSource)
@interface SKWDataSource : NSObject

/// ストリームを作成します。
- (SKWLocalDataStream* _Nonnull)createStream;

@end

#endif /* SKWDataSource_h */
