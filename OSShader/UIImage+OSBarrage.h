//
//  UIImage+OSBarrage.h
//  OSBufferText
//
//  Created by xu jie on 16/9/23.
//  Copyright © 2016年 xujie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (OSBarrage)

/*
 * @func  文字生成图片
 * @param string 字符串
 * @param font 文字大小和字体
 * @param textColor 文字颜色
 * @return 图片对象
 */
+(UIImage*)imageWithString:(NSString *)string font:(UIFont *)font color:(UIColor *)textColor;


/*
 * @func  获取图片RGBA 字节流
 * @return 字节流
 */
-(void*)os_getRGBABuffer;

/*
 * @func  获取指定尺寸大小的图片
 * @param size 图片大小
 * @return 调整后的图片
 */

-(UIImage*)os_getImageBySize:(CGSize)size;
@end
