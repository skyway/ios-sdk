//
//  SKWCameraVideoSource.h
//  SkyWay
//
//  Created by sandabu on 2022/05/11.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWCameraVideoSource_h
#define SKWCameraVideoSource_h

#import <AVFoundation/AVFoundation.h>

#import "SKWVideoSource.h"
#import "SKWCameraPreviewView.h"


/// カメラキャプチャオプション
///
/// それぞれのプロパティから`AVCaptureDeviceFormat`を決定するために利用されます。
NS_SWIFT_NAME(CameraCaptureOptions)
@interface SKWCameraCaptureOptions: NSObject
/// 最大Width
///
/// デフォルト値は1280です。
@property(nonatomic) int preferredMaxWidth;

/// 最大Height
///
/// デフォルトは720です。
@property(nonatomic) int preferredMaxHeight;

/// 最大フレームレート数
///
/// デフォルトは30です。
@property(nonatomic) int preferredMaxFrameRate;
@end

/// カメラ映像入力ソース
///
/// 他の映像入力ソースとは異なり、シングルトンインスタンスを利用してください。
///
/// インスタンスは`SKWCameraVideoSource.shared()`から取得できます。
/// 
/// Streamは`createStream()`より作成できますが、実際に映像を描画するためには`startCapturing(with:options:completion:)`でキャプチャを開始する必要があります。
NS_SWIFT_NAME(CameraVideoSource)
@interface SKWCameraVideoSource : SKWVideoSource

typedef void (^SKWCameraVideoSourceStartCapturingCompletion)(NSError* _Nullable error);
typedef void (^SKWCameraVideoSourceSetCameraCompletion)(NSError* _Nullable error);
typedef void (^SKWCameraVideoSourceChangeDeviceCompletion)(NSError* _Nullable error);

-(id _Nonnull)init NS_UNAVAILABLE;

/// 現在キャプチャーしているカメラデバイス
@property(nonatomic, readonly) AVCaptureDevice* _Nullable camera;

/// SDKがサポートしているカメラデバイス一覧
+(NSArray<AVCaptureDevice*>* _Nonnull)supportedCameras;

/// シングルトンインスタンス
+(instancetype _Nonnull)shared;

/// カメラのプレビューを`SKWCameraPreviewView`に描画します。
///
/// 映像を表示するためには`startCapturing(with:options:completion:)`をコールする必要があります。
/// @param view 描画を行うView
-(void)attachView:(SKWCameraPreviewView* _Nonnull)view;

/// Viewへの描画を中止します。
///
/// - Parameter view: 中止する描画中のView
-(void)detachView:(SKWCameraPreviewView* _Nonnull)view;

/// キャプチャを開始します。
///
/// キャプチャを開始後にカメラのパーミッション取得ダイアログが表示され、承認された後にカメラ利用インジケータが表示開始されます。
///
/// @param device 利用するカメラデバイス
/// @param options キャプチャオプション
/// @param completion 完了コールバック
-(void)startCapturingWithDevice:(AVCaptureDevice* _Nonnull)device
                        options:(SKWCameraCaptureOptions* _Nullable)options
                     completion:(SKWCameraVideoSourceStartCapturingCompletion _Nullable)completion
NS_SWIFT_NAME(startCapturing(with:options:completion:));


/// カメラデバイスを切り替えます。
///
/// この切り替えはキャプチャ中でも可能です。
///
/// @param device 切り替え先のカメラデバイス
/// @param completion 完了コールバック
-(void)changeDevice:(AVCaptureDevice* _Nonnull)device completion:(SKWCameraVideoSourceChangeDeviceCompletion _Nullable)completion
NS_SWIFT_NAME(change(_:completion:));

/// キャプチャを停止します。
///
/// このAPIコール後にカメラ利用インジケータが消えます。
-(void)stopCapturing;

// Override
/// Streamを作成します。
///
/// Streamの作成後にキャプチャ開始でも機能します。
-(SKWLocalVideoStream* _Nonnull)createStream;

@end

#endif /* SKWCameraVideoSource_h */
