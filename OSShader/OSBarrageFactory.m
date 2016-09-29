//
//  OSBarrageFactory.m
//  OSBufferText
//
//  Created by xu jie on 16/9/22.
//  Copyright © 2016年 xujie. All rights reserved.
//

#import "OSBarrageFactory.h"

#define Take_Barrage_Interval 0.016      // 从缓存中取弹幕的时间间隔 单位:S
@interface OSBarrageFactory()
@property(atomic,strong)NSMutableArray *cachaBarrageInfoArray;
@property(nonatomic,assign)NSUInteger barrageMaxHeight;        // 弹幕最大高度,确定弹道的数量
@property(nonatomic,assign)NSUInteger paths;                   // 弹道数量
@property(nonatomic,assign)CGSize displayViewSize;             // 显示视图的大小
@property(nonatomic,strong)NSTimer *timer1;   // 用于从缓冲区中去弹幕
@property(nonatomic,strong)NSTimer *timer2;   // 用于计算弹幕信息
@property(nonatomic,strong)CADisplayLink *displayLink;


@end

@implementation OSBarrageFactory



//-----------------------------------------------------------
#pragma mark -
#pragma mark - 添加弹幕到缓冲中去 如果缓存满了,则不能继续添加了
//-----------------------------------------------------------
-(OSErrorType)addBarrageInfo:(OSBarrageInfo*)barrageInfo{
    // 调节弹幕显示比例
    barrageInfo.barrage.displayWidth = self.displayViewSize.width;
    barrageInfo.barrage.displayHeight = self.displayViewSize.height;
  
    
    if (self.cachaBarrageInfoArray.count >= self.cachaMaxCount){
        return OSCachaFill;
    }else{
        // 添加弹幕放在异步   // 加锁 其他线程也会用到
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            @synchronized (self.cachaBarrageInfoArray) {
                [self.cachaBarrageInfoArray addObject:barrageInfo];
                NSLog(@"缓存%ld",self.cachaBarrageInfoArray.count);
            }
        });
        
        return OSSuccess;
    }
    
    
    
    
}


//-----------------------------------------------------------
#pragma mark -
#pragma mark - 从缓冲区获取弹幕
//-----------------------------------------------------------

- (void)getBarrageFromCacha:(NSTimer*)timer{
    
    // 从缓冲区中取回弹幕
        OSBarrageInfo *barrageInfo;
        /*给self.cachaBarrageInfoArray 加锁*/
        @synchronized (self.cachaBarrageInfoArray) {
            barrageInfo =  self.cachaBarrageInfoArray.firstObject;
            if (!barrageInfo){
                return ;
            }
            // 如果缓冲从有弹幕再去遍历找到合适的位置
        }
     

            // 创建一个队列
            /*barrageInfo-Begin*/
            if (barrageInfo){
                NSInteger i = 0;
                for (NSMutableArray *path in self.barragePathArray){
                    // 如果缓冲中有弹幕,则做相应的添加弹幕逻辑处理操作
                    // 计算弹幕的初始位置
                     @synchronized (path) {
                    if (path.count == 0){
                        // 如果弹道中没有弹幕,直接忘里面添加
                        barrageInfo.barrage.position = GLKVector3Make(self.displayViewSize.width, self.barrageMaxHeight*i, 0);
                        [path addObject:barrageInfo];
                        [self.barrageArray addObject:barrageInfo];
                        @synchronized (self.cachaBarrageInfoArray) {
                            [self.cachaBarrageInfoArray removeObjectAtIndex:0];
                        }
                        break;
                    }else{
                        // 如果弹道里面有弹幕,先检测最后一个弹幕是不是在视图外边,如果在外边则不添加
                        OSBarrageInfo *lastBarrageInfo = path.lastObject;
                        if (lastBarrageInfo && lastBarrageInfo .barrage.position.x + lastBarrageInfo .barrage.width < self.displayViewSize.width-10){
                            barrageInfo.barrage.position = GLKVector3Make(self.displayViewSize.width, self.barrageMaxHeight*i, 0);
                            [path addObject:barrageInfo];
                            [self.barrageArray addObject:barrageInfo];
                            @synchronized (self.cachaBarrageInfoArray) {
                                [self.cachaBarrageInfoArray  removeObjectAtIndex:0];
                            }
                            break;
                        }
                    }
                    i++;
                 }
                    
                }
            }
}

//-----------------------------------------------------------
#pragma mark -
#pragma mark - 计算弹幕的位置
//-----------------------------------------------------------

-(void)caluateBarragePosition:(NSTimer*)timer{

    // 创建一个队列
   
        NSMutableArray *deleteBarrage = [NSMutableArray array];
        for  (NSMutableArray *path in self.barragePathArray){
            // 获取弹道
            NSInteger index = 0;
            @synchronized (path) {
                for (OSBarrageInfo *barrageInfo in path){
                    // 开启碰撞检测 获取上一个弹幕,如果距离小于5，则后一个弹幕的速度和前一个相同
                    if (self.collisionEnable){
                        if (index  >0){
                            OSBarrageInfo *lastBarrageInfo = path[index-1];
                            if (lastBarrageInfo && barrageInfo && lastBarrageInfo.barrage.position.x + lastBarrageInfo.barrage.width > barrageInfo.barrage.position.x - 10){
                                barrageInfo.rate = lastBarrageInfo.rate;
                            }
                        }
                    }
                    
                    
                    // 根据弹幕的不同速度,设置其偏移量
                    barrageInfo.barrage.position = GLKVector3Make(barrageInfo.barrage.position.x-barrageInfo.rate, barrageInfo.barrage.position.y, 0.5-index/10000.0);
                    
                    
                    // 将移除屏幕的弹幕移除掉
                    if ( barrageInfo && barrageInfo.barrage.position.x + barrageInfo.barrage.width < 0 ){
                        if (barrageInfo.canDelete){
                            [deleteBarrage addObject:barrageInfo];
                        }
                        barrageInfo.isDelete = true;
                    }
                    index++;
                    
                }
               
                    [self.barrageArray removeObjectsInArray:deleteBarrage];
                    [path removeObjectsInArray:deleteBarrage];
              
            }
        }

  
    
    
}

//-----------------------------------------------------------
#pragma mark -
#pragma mark - 清除缓存中所有弹幕
//-----------------------------------------------------------
-(void)clearAllBarrageInCacha{
    @synchronized (self.cachaBarrageInfoArray) {
        [self.cachaBarrageInfoArray removeAllObjects];
    };
    
}

//-----------------------------------------------------------
#pragma mark -
#pragma mark - 清除屏幕中所有弹幕
//-----------------------------------------------------------
-(void)clearAllBarrageInDisplay{
    @synchronized (self.barragePathArray) {
        [self.barragePathArray removeAllObjects];
    };
    
}

//-----------------------------------------------------------
#pragma mark -
#pragma mark - 清除缓存和屏幕中的弹幕
//-----------------------------------------------------------
-(void)clearAllBarrage{
    [self clearAllBarrageInDisplay];
    [self clearAllBarrageInCacha];
    
}
//-----------------------------------------------------------
#pragma mark -
#pragma mark -  初始化对象
//-----------------------------------------------------------
-(instancetype)initWithBarrageMaxHeight:(NSUInteger)barrageMaxHeight DisplayViewSize:(CGSize)viewSize{
    if (self = [super init]){
        // 创建弹道
        _barrageMaxHeight = barrageMaxHeight;
        _displayViewSize = viewSize;
        // 初始化弹幕数组
        _barrageArray = [NSMutableArray array];
        _cachaBarrageInfoArray = [NSMutableArray array];
        _barragePathArray = [NSMutableArray array];
        
        
        // 创建弹幕路径
        [self createBarragePaths];
        self.timer1 = [NSTimer scheduledTimerWithTimeInterval:Take_Barrage_Interval target:self selector:@selector(getBarrageFromCacha:) userInfo:nil repeats:true];
        //
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(caluateBarragePosition:)];
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        
        
    }
    return self;
}

//-----------------------------------------------------------
#pragma mark -
#pragma mark - 动态生成弹道数组
//-----------------------------------------------------------
-(void)createBarragePaths{
    
    // 计算弹道数量
    self.paths = (NSUInteger)self.displayViewSize.height/self.barrageMaxHeight;
    
    // 动态创建弹道数组
    for(NSUInteger i =0; i < self.paths;i++){
        NSMutableArray *path = [NSMutableArray array];
        [self.barragePathArray addObject:path];
    }
    
}

//-----------------------------------------------------------
#pragma mark -
#pragma mark - 类方法创建对象
//-----------------------------------------------------------

+(OSBarrageFactory *)barrageFactoryWithBarrageMaxHeight:(NSUInteger)barrageMaxHeight DisplayViewSize:(CGSize)viewSize{
    return [[OSBarrageFactory alloc]initWithBarrageMaxHeight:barrageMaxHeight DisplayViewSize:viewSize];
    
}


@end
