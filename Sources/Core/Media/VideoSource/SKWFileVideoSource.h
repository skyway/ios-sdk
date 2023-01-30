//
//  SKWFileVideoSource.h
//  SkyWay
//
//  Created by sandabu on 2022/05/12.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWFileVideoSource_h
#define SKWFileVideoSource_h

#import "SKWVideoSource.h"


/// 動画ファイル入力ソース
/// 
/// ファイルに音声が含まれる場合でも、映像のみ扱われることに注意してください。
NS_SWIFT_NAME(FileVideoSource)
@interface SKWFileVideoSource : SKWVideoSource

typedef void (^SKWFileVideoSourceStartCapturingOnError)(NSError* _Nullable error);

@property(nonatomic, readonly) NSString* _Nonnull filename;


-(id _Nonnull)init NS_UNAVAILABLE;

/// イニシャライザ
///
/// @param filename ファイル名(拡張子含む)
-(id _Nonnull)initWithFilename:(NSString* _Nonnull)filename;


/// キャプチャを開始します。
///
/// @param onError エラーハンドラ
-(void)startCapturingOnError:(SKWFileVideoSourceStartCapturingOnError _Nullable)onError;

/// キャプチャを中止します。
-(void)stopCapturing;

@end

#endif /* SKWFileVideoSource_h */
