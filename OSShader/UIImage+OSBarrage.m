//
//  UIImage+OSBarrage.m
//  OSBufferText
//
//  Created by xu jie on 16/9/23.
//  Copyright © 2016年 xujie. All rights reserved.
//

#import "UIImage+OSBarrage.h"

@implementation UIImage (OSBarrage)
-(CGContextRef) createBitmapContext:(int) pixelsWide  pixelsHigh:
(int) pixelsHigh
{
    CGContextRef    context = NULL;  // 定义上下文
    CGColorSpaceRef colorSpace;      // 定义颜色空间
    GLubyte*          bitmapData;      // 定义bitmap数据指针
    int             bitmapByteCount; // 定义bitmap字节数量
    int             bitmapBytesPerRow;// 定义每一行数据
    
    bitmapBytesPerRow   = (pixelsWide * 4);// 设置每个像素的占的字节数
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);// 设置bitmap总字节数
    
    colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);// 创建颜色空间为RGB 类型
    
    bitmapData = (GLubyte*)calloc(bitmapByteCount, sizeof(GLubyte));// malloc( bitmapByteCount );// 申请内存空间
 

    if (bitmapData == NULL)
    {
        fprintf (stderr, "Memory not allocated!");
        return NULL;
    }
    
    // 创建bitmap上下文
    context = CGBitmapContextCreate (bitmapData,// 内存地址
                                     pixelsWide,// 图片的宽度
                                     pixelsHigh,// 图片的高度
                                     8,      // 颜色空间每一部分的位数
                                     bitmapBytesPerRow,// 图片每行占的字节数据
                                     colorSpace,// 颜色空间
                                     kCGImageAlphaPremultipliedLast);
    if (context== NULL)
    {
        free (bitmapData);// 释放内存
        fprintf (stderr, "Context not created!");
        return NULL;
    }
    CGColorSpaceRelease( colorSpace );// 6
    return context;// 7
}

+(UIImage*)imageWithString:(NSString *)string font:(UIFont *)font color:(UIColor *)textColor {
    CGSize size = [string boundingRectWithSize:CGSizeMake(1000, 2000.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size;
    
    //UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width, size.height),NO,0.0);
    UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height));
  
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat color[4] = {0,0,0,0};
    CGContextSetFillColor(context, color);
    CGContextFillRect(context,  CGRectMake(0, 0, size.width, size.height));
    
    [string drawInRect:CGRectMake(0, 0, size.width, size.height) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:textColor}];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
   
    
    return image;
}

-(void*)os_getRGBABuffer{
    // 创建bitmap上下文
    CGContextRef  myBitmapContext = [self createBitmapContext:self.size.width pixelsHigh:self.size.height];
   // CGContextRef myBitmapContext = UIGraphicsGetCurrentContext();
    if (myBitmapContext){
        // 绘制图片
        CGContextDrawImage(myBitmapContext, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
        // 获取位图数据
        char *bitmapData = CGBitmapContextGetData(myBitmapContext);
        
        // 释放掉上下文
        CGContextRelease (myBitmapContext);// 8
        return bitmapData;
    }
    return nil;
}

-(UIImage*)os_getImageBySize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  image;
}
@end
