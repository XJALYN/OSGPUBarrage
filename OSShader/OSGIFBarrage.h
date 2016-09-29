//
//  OSGIFBarrage.h
//  OSGPUBarrage
//
//  Created by xu jie on 16/9/29.
//  Copyright © 2016年 xujie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSBarrage.h"

@interface OSGIFBarrage : OSBarrage


+(OSGIFBarrage*)gifBarrageWithImages:(NSArray<UIImage*>*)images displaySize:(CGSize)size AnimationDuration:(NSTimeInterval)duration;

@end
