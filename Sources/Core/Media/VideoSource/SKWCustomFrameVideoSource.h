//
//  SKWCustomFrameVideoSource.h
//  SkyWay
//
//  Created by sandabu on 2022/05/12.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWCustomFrameVideoSource_h
#define SKWCustomFrameVideoSource_h

#import <CoreMedia/CoreMedia.h>

#import "SKWVideoSource.h"

/// 画像フレームの映像入力ソース
///
/// `CMSampleBuffer`の画像フレームをループ内からアップデートして描画を行います。
///
/// ReplayKitと組み合わせることでアプリの画面をソースにして画面共有が行えます。
///
/// ```swift
/// let source: CustomFrameVideoSource = .init()
/// RPScreenRecorder.shared().startCapture { buffer, _, err in
///     guard err == nil else {
///         return
///     }
///     source.updateFrame(with: buffer)
/// } completionHandler: { _ in }
///
/// let stream = source.createStream()
/// ```
NS_SWIFT_NAME(CustomFrameVideoSource)
@interface SKWCustomFrameVideoSource : SKWVideoSource

- (id _Nonnull)init;

/// 画像のサンプルバッファを更新します。
///
/// @param sampleBuffer 更新する画像フレームのサンプルバッファ
- (void)updateFrameWithSampleBuffer:(CMSampleBufferRef _Nonnull)sampleBuffer;
@end

#endif /* SKWCustomFrameVideoSource_h */
