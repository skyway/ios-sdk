//
//  SKWRemoteVideoStream_h
//  SkyWay
//
//  Created by sandabu on 2022/03/23.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWRemoteVideoStream_h
#define SKWRemoteVideoStream_h

#import "SKWRemoteStream.h"
#import "SKWVideoView.h"

/// RemoteVideoStream
NS_SWIFT_NAME(RemoteVideoStream)
@interface SKWRemoteVideoStream : SKWRemoteStream <SKWVideoStreamProtocol>

/// VideoStreamの映像をViewに描画します。
///
/// - Parameter view: 描画させるView
- (void)attachView:(SKWVideoView* _Nonnull)view;

/// Viewへの描画を中止します。
///
/// - Parameter view: 中止する描画中のView
- (void)detachView:(SKWVideoView* _Nonnull)view;
@end

#endif /* SKWRemoteVideoStream_h */
