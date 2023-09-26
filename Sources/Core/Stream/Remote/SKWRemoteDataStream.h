//
//  SKWRemoteDataStream_h
//  SkyWay
//
//  Created by sandabu on 2022/03/22.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWRemoteDataStream_h
#define SKWRemoteDataStream_h

#import "SKWRemoteStream.h"

/// RemoteDataStreamクラス
NS_SWIFT_NAME(RemoteDataStream)
@interface SKWRemoteDataStream : SKWRemoteStream

@end

/// RemoteDataStreamイベントデリゲート
NS_SWIFT_NAME(RemoteDataStreamDelegate)
@protocol SKWRemoteDataStreamDelegate <NSObject>

/// 文字列情報を受信した時にコールされるイベント
///
/// - Parameters:
///   - dataStream: 対象のDataStream
///   - string: 受信した文字列
@optional
- (void)dataStream:(SKWRemoteDataStream* _Nonnull)dataStream
    didReceiveString:(NSString* _Nonnull)string;

/// バイナリを受信した時にコールされるイベント
///
/// - Parameters:
///   - dataStream:対象のDataStream
///   - data: 受信したデータ
@optional
- (void)dataStream:(SKWRemoteDataStream* _Nonnull)dataStream didReceiveData:(NSData* _Nonnull)data;
@end

@interface SKWRemoteDataStream ()

/// イベントデリゲート
@property(weak, nonatomic) id<SKWRemoteDataStreamDelegate> _Nullable delegate;

@end

#endif /* SKWRemoteDataStream_h */
