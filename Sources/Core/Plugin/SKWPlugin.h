//
//  SKWPlugin.h
//  SkyWay
//
//  Created by sandabu on 2022/03/30.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

#ifndef SKWPlugin_h
#define SKWPlugin_h

#import "SKWRemoteMember.h"

/// プラグイン基底クラス
NS_SWIFT_NAME(Plugin)
@interface SKWPlugin : NSObject

/// Botタイプ
@property(nonatomic, readonly) NSString* _Nonnull subtype;

- (id _Nonnull)init NS_UNAVAILABLE;

@end

#endif /* SKWPlugin_h */
