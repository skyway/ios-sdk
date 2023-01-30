//
//  SKWStream_h
//  SkyWay
//
//  Created by sandabu on 2022/02/04.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWStream_h
#define SKWStream_h

#import <Foundation/Foundation.h>
#import "SKWVideoView.h"
#import "Type.h"

NS_SWIFT_NAME(VideoStreamProtocol)
@protocol SKWVideoStreamProtocol <NSObject>
-(void)attachView:(SKWVideoView* _Nonnull)view;
-(void)detachView:(SKWVideoView* _Nonnull)view;
@end

NS_SWIFT_NAME(Stream)
@interface SKWStream: NSObject
@property(nonatomic, readonly) NSString* _Nonnull id;
@property(nonatomic, readonly) SKWSide side;
@property(nonatomic, readonly) SKWContentType contentType;
@end

#endif /* SKWStream_h */
