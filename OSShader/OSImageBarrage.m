//
//  OSImageBarrage.m
//  OSGPUBarrage
//
//  Created by xu jie on 16/9/27.
//  Copyright © 2016年 xujie. All rights reserved.
//

#import "OSImageBarrage.h"

@implementation OSImageBarrage

//-----------------------------------------------------------
#pragma mark -
#pragma mark - 工厂方法创建图片弹幕
//-----------------------------------------------------------
+(OSImageBarrage*)imageBarrageWithImage:(UIImage*)image displaySize:(CGSize)size{
    return [[OSImageBarrage alloc]initWithImage:image displaySize:size];

}

//-----------------------------------------------------------
#pragma mark -
#pragma mark - 初始化弹幕
//-----------------------------------------------------------
-(instancetype)initWithImage:(UIImage*)image displaySize:(CGSize)size{
    if (self = [super init]){
       
        self.image = [image os_getImageBySize:size];
        self.width = self.image.size.width;
        self.height = self.image.size.height;
        self.data = [self.image os_getRGBABuffer];
        
        [self createVerticeArray]; // 初始化顶点数组
        
    }
    return self;
}

@end
