//
//  SKWVideoView.h
//  SkyWay
//
//  Created by sandabu on 2022/03/23.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWVideoView_h
#define SKWVideoView_h

#import <UIKit/UIKit.h>

/// Videoを描画するView
///
/// 描画するためには`SKWLocalVideoStream`または`SKWRemoteVideoStream`の`attach(_:)`に引数を渡してください。
///
/// StoryboardのCustom Classを利用する場合は`VideoView`ではなく`SKWVideoView`を指定して下さい。
///
/// グラフィックスAPIはMetalを利用しています。
NS_SWIFT_NAME(VideoView)
@interface SKWVideoView : UIView

/// 映像をWrapしているレンダラービュー
///
/// ViewはStreamからAttachされた後に生成されアクセスできます。
/// 
/// このViewも更に内部ではMTKViewをWrapしています。
@property(nonatomic, readonly) UIView* _Nullable rendererView;

/// 描画するVideoのContentMode
@property(nonatomic) UIViewContentMode videoContentMode;


@end

#endif /* SKWVideoView_h */
