//
//  OSGIFBarrage.m
//  OSGPUBarrage
//
//  Created by xu jie on 16/9/29.
//  Copyright © 2016年 xujie. All rights reserved.
//

#import "OSGIFBarrage.h"

@interface OSGIFBarrage()
@property(nonatomic,assign)NSTimeInterval interval;
@property(nonatomic,strong)NSMutableArray *datas;
@property(nonatomic,strong)CADisplayLink *displayLink;
@end

@implementation OSGIFBarrage

+(OSGIFBarrage*)gifBarrageWithImages:(NSArray<UIImage*>*)images displaySize:(CGSize)size AnimationDuration:(NSTimeInterval)duration{
    return [[OSGIFBarrage alloc]initWithImages:images displaySize:size AnimationDuration:duration];
}

-(instancetype)initWithImages:(NSArray<UIImage*>*)images displaySize:(CGSize)size AnimationDuration:(NSTimeInterval)duration{
    if (self = [super init]){
        self.datas = [NSMutableArray array];
        for (UIImage *image in images){
            void *bitmapData = [[image os_getImageBySize:size] os_getRGBABuffer];
           NSData *data = [NSData dataWithBytes:bitmapData length:size.width*size.height*4];
            free(bitmapData);
            [self.datas addObject:data];
        }
       
        
        NSData *data1 = self.datas.firstObject;
        self.data = (void*)data1.bytes;
        self.width = size.width;
        self.height = size.height;
        [self createVerticeArray]; // 必须初始化的，因为我用的是指针的方式
        self.interval = duration/images.count;
        // 创建定时器
        [self createDisplayLink];
    }
    return self;
}

//-----------------------------------------------------------
#pragma mark -
#pragma mark - 创建帧同步定时器
//-----------------------------------------------------------
-(void)createDisplayLink{
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(animation:)];
        self.displayLink.frameInterval = (NSInteger)1/self.interval;
        [self.displayLink  addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];


}

//-----------------------------------------------------------
#pragma mark -
#pragma mark - 定时器触发事件 && 更换图片数据
//-----------------------------------------------------------
-(void)animation:(CADisplayLink*)displayLink{
    static int i = 0;
    NSData *data = self.datas[i];
    if (data){
       
        self.data = (void*)data.bytes;
    }

    i++;
    if (i >= self.datas.count){
        i = 0;
    }

}
//-----------------------------------------------------------
#pragma mark -
#pragma mark - 释放帧同步定时器 - 由于CADisplayLink 不释放内存对象释放不了,所以只能在这里释放了
//-----------------------------------------------------------
-(void)setPosition:(GLKVector3)position{
    [super setPosition:position];
    if (position.x - self.width < 0){
         [self.displayLink invalidate];
    }
}

-(void)dealloc{
    [self.datas removeAllObjects];

    self.data = 0;
    
}



@end
