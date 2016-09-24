//
//  OSTextBarrage.m
//  OSBufferText
//
//  Created by xu jie on 16/9/23.
//  Copyright © 2016年 xujie. All rights reserved.
//

#import "OSTextBarrage.h"
#import "UIImage+OSBarrage.h"

@implementation OSTextBarrage

//-----------------------------------------------------------
#pragma mark -
#pragma mark - 工厂方法创建文字对象
//-----------------------------------------------------------
+(OSTextBarrage *)textInfoWithString:(NSString *)string font:(UIFont *)font color:(UIColor *)textColor {
    return [[OSTextBarrage alloc]initWithString:string font:font color:textColor ];
}

//-----------------------------------------------------------
#pragma mark -
#pragma mark - 初始化文字弹幕对象
//-----------------------------------------------------------
-(instancetype)initWithString:(NSString *)string font:(UIFont *)font color:(UIColor *)textColor {
    if (self = [super init]){
        self.image = [UIImage imageWithString:string font:font color:textColor];
        self.data = [self.image getRGBABuffer];
        self.width = self.image.size.width;
        self.height = self.image.size.height;
        [self createVerticeArray]; // 必须初始化的，因为我用的是指针的方式
        
        
    }
    return self;
}




@end
