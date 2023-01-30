//
//  SKWCameraPreviewView.h
//  SkyWay
//
//  Created by Naoto Takahashi on 2022/09/12.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWCameraPreviewView_h
#define SKWCameraPreviewView_h

#import <UIKit/UIKit.h>


/// カメラプレビュー用View
///
/// 描画するためには`SKWCameraVideoSource`の`attachView(_)`に引数を渡してください。
///
/// StoryboardのCustom Classを利用する場合は`CameraPreviewView`ではなく`SKWCameraPreviewView`を指定して下さい。
NS_SWIFT_NAME(CameraPreviewView)
@interface SKWCameraPreviewView : UIView

/// Wrapしているレンダラービュー
///
/// ViewはSourceへAttachされた後に生成されアクセスできます。
///
/// 映像は`AVCaptureVideoPreviewLayer`で描画しています。
@property(nonatomic, readonly) UIView* _Nullable rendererView;

/// 映像の描画モード
///
/// デフォルトは`ResizeAspect`がセットされます。
@property(nonatomic) AVLayerVideoGravity _Nonnull videoGravity;

@end

#endif /* SKWCameraPreviewView_h */
