//
//  SKWCodec.h
//  SkyWay
//
//  Created by sandabu on 2022/04/01.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWCodec_h
#define SKWCodec_h

#import <Foundation/Foundation.h>


/// コーデック設定
NS_SWIFT_NAME(Codec)
@interface SKWCodec: NSObject

-(id _Nonnull)initWithMimeType:(NSString* _Nonnull)mimeType;


/// コーデックのmimeType
///
/// サポートしているコーデックは公式サイトをご確認ください。
///
/// ex. `video/h264`, `audio/opus`
@property NSString* _Nonnull mimeType;

@end

#endif /* SKWCodec_h */
