//
//  SKWVideoSource.h
//  SkyWay
//
//  Created by sandabu on 2022/05/11.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWVideoSource_h
#define SKWVideoSource_h

#import <Foundation/Foundation.h>

@class SKWLocalVideoStream;

/// 映像入力ソースの抽象クラス
NS_SWIFT_NAME(VideoSource)
@interface SKWVideoSource: NSObject

typedef void (^SKWVideoSourceStartCapturingCompletion)(NSError* _Nullable error);
typedef void (^SKWVideoSourceCapturingOnError)(NSError* _Nullable error);

-(id _Nonnull)init NS_UNAVAILABLE;

/// ストリームを作成します。
-(SKWLocalVideoStream* _Nonnull)createStream;

@end

#endif /* SKWVideoSource_h */
