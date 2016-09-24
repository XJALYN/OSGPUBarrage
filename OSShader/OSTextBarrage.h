//
//  OSTextBarrage.h
//  OSBufferText
//
//  Created by xu jie on 16/9/23.
//  Copyright © 2016年 xujie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSBarrage.h"

@interface OSTextBarrage : OSBarrage
/*
 * 生成文字对象
 * string 文字
 * font 文字的属性
 * color  颜色
 * position 文字在视图中的位置
 */
+(OSTextBarrage *)textInfoWithString:(NSString *)string font:(UIFont *)font color:(UIColor *)textColor ;
@end
