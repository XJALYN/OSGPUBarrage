//
//  OSImageBarrage.h
//  OSGPUBarrage
//
//  Created by xu jie on 16/9/27.
//  Copyright © 2016年 xujie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSBarrage.h"

@interface OSImageBarrage : OSBarrage
/*
 * @func  初始化图片弹幕
 * @param image 图片
 * @return size 设置图片大小
 * @tip  图片的高度尽量不要超过弹道的最大高度
 */
+(OSImageBarrage*)imageBarrageWithImage:(UIImage*)image displaySize:(CGSize)size;
@end
