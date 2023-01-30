//
//  SKWLocalVideoStream_h
//  SkyWay
//
//  Created by sandabu on 2022/03/22.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWLocalVideoStream_h
#define SKWLocalVideoStream_h

#import <AVFoundation/AVFoundation.h>

#import "SKWLocalStream.h"
#import "SKWVideoSource.h"
#import "SKWVideoView.h"


/// LocalVideoStreamクラス
///
/// 各種VideoSourceの`createStream()`から生成してください。
NS_SWIFT_NAME(LocalVideoStream)
@interface SKWLocalVideoStream : SKWLocalStream <SKWVideoStreamProtocol>

/// 映像ソース
@property(nonatomic, readonly) SKWVideoSource* _Nonnull source;

/// VideoStreamの映像をViewに描画します。
///
/// - Parameter view: 描画させるView
-(void)attachView:(SKWVideoView* _Nonnull)view;


/// Viewへの描画を中止します。
///
/// - Parameter view: 中止する描画中のView
-(void)detachView:(SKWVideoView* _Nonnull)view;

@end

#endif /* SKWLocalVideoStream_h */
