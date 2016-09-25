//
//  OSBarrageFactory.m
//  OSBufferText
//
//  Created by xu jie on 16/9/22.
//  Copyright © 2016年 xujie. All rights reserved.
//

#import "OSBarrageFactory.h"

#define Take_Barrage_Interval 0.1      // 从缓存中取弹幕的时间间隔 单位:S
#define Caluate_Barrage_Interval 0.016 // 计算弹幕的位置 单位S:
@interface OSBarrageFactory()
@property(nonatomic,strong)NSMutableArray *cachaBarrageInfoArray;
@property(nonatomic,assign)NSUInteger barrageMaxHeight;        // 弹幕最大高度,确定弹道的数量
@property(nonatomic,assign)NSUInteger paths;                   // 弹道数量
@property(nonatomic,assign)CGSize displayViewSize;             // 显示视图的大小
@property(nonatomic,strong)NSTimer *timer1;   // 用于从缓冲区中去弹幕
@property(nonatomic,strong)NSTimer *timer2;   // 用于计算弹幕信息
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
    
   __block BOOL isSuccess = true;
    /*给self.barragePathArray - 加锁*/
    @synchronized (self.barragePathArray) {
       
            /*barrageInfo-Begin*/
            if (barrageInfo){
               
                [self.barragePathArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSMutableArray *path = obj;
                    // 如果缓冲中有弹幕,则做相应的添加弹幕逻辑处理操作
                    // 计算弹幕的初始位置
                    if (path.count == 0){
                        // 如果弹道中没有弹幕,直接向里面添加
                        barrageInfo.barrage.position = GLKVector3Make(self.displayViewSize.width, self.barrageMaxHeight*idx, 0);
                        [path addObject:barrageInfo];
                         @synchronized (self.barrageArray) {
                           [self.barrageArray addObject:barrageInfo];
                         }
                        isSuccess = true;
                        *stop = true;
                      
                        
                    }else{
                        // 如果弹道里面有弹幕,先检测最后一个弹幕是不是在视图外边,如果在外边则不添加
                        OSBarrageInfo *lastBarrageInfo = path.lastObject;
                        if (lastBarrageInfo .barrage.position.x + lastBarrageInfo .barrage.width < self.displayViewSize.width-10){
                            barrageInfo.barrage.position = GLKVector3Make(self.displayViewSize.width, self.barrageMaxHeight*idx, 0);
                            [path addObject:barrageInfo];
                             @synchronized (self.barrageArray) {
                               [self.barrageArray addObject:barrageInfo];
                             }
                            isSuccess = true;
                            *stop = true;
                            
                        }
                    }
                }];
            }
        
        /*barrageInfo-End*/

    }
    if (isSuccess){
         return OSSuccess;
    }
    
   
    /*给self.barragePathArray - 加锁*/
    @synchronized (self.cachaBarrageInfoArray) {
    if (self.cachaBarrageInfoArray.count >= self.cachaMaxCount){
        return OSCachaFill;
    }else{
            // 添加弹幕放在异步   // 加锁 其他线程也会用到
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [self.cachaBarrageInfoArray addObject:barrageInfo];
                [self.cachaBarrageInfoArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    if (self.sortType == OSSortTime){
                        
                        return [obj1 valueForKey:@"timeStamp"] >= [obj2 valueForKey:@"timeStamp"];
                    }else if (self.sortType == OSSortRank){
                        return [obj1 valueForKey:@"userRank"] >= [obj2 valueForKey:@"userRank"];
                    }else{
                        return 1;
                        
                    }
                }];
            });
    
        return OSSuccess;
      }
    }
    
}

- (void)getBarrageFromCacha:(NSTimer*)timer{
    
    // 从缓冲区中取回弹幕
 
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        OSBarrageInfo *barrageInfo;
        /*给self.cachaBarrageInfoArray 加锁*/
        @synchronized (self.cachaBarrageInfoArray) {
            barrageInfo =  self.cachaBarrageInfoArray.firstObject;
            // 如果缓冲从有弹幕再去遍历找到合适的位置
        }
        /*给self.cachaBarrageInfoArray 加锁*/
            /*给self.barragePathArray - 加锁*/
            @synchronized (self.barragePathArray) {
                
                /*barrageInfo-Begin*/
                if (barrageInfo){
                    [self.barragePathArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSMutableArray *path = obj;
                        // 如果缓冲中有弹幕,则做相应的添加弹幕逻辑处理操作
                        // 计算弹幕的初始位置
                        if (path.count == 0){
                            // 如果弹道中没有弹幕,直接忘里面添加
                            barrageInfo.barrage.position = GLKVector3Make(self.displayViewSize.width, self.barrageMaxHeight*idx, 0);
                            [path addObject:barrageInfo];
                            @synchronized (self.barrageArray) {
                             [self.barrageArray addObject:barrageInfo];
                            }
                            @synchronized (self.cachaBarrageInfoArray) {
                              [self.cachaBarrageInfoArray removeObjectAtIndex:0];
                            }
                            *stop = true;
                        }else{
                            // 如果弹道里面有弹幕,先检测最后一个弹幕是不是在视图外边,如果在外边则不添加
                            OSBarrageInfo *lastBarrageInfo = path.lastObject;
                            if (lastBarrageInfo .barrage.position.x + lastBarrageInfo .barrage.width < self.displayViewSize.width-10){
                                barrageInfo.barrage.position = GLKVector3Make(self.displayViewSize.width, self.barrageMaxHeight*idx, 0);
                                [path addObject:barrageInfo];
                                @synchronized (self.barrageArray) {
                                    [self.barrageArray addObject:barrageInfo];
                                }
                                @synchronized (self.cachaBarrageInfoArray) {
                                    [self.cachaBarrageInfoArray removeObjectAtIndex:0];
                                }
                                *stop = true;
                                
                            }
                        }
                    }];
                }
                }
                /*barrageInfo-End*/
        /*给self.barragePathArray - 加锁*/
            
      
    });
   

    
}

-(void)caluateBarragePosition:(NSTimer*)timer{
    static NSInteger rate = 1;
    rate++;
    if (rate >= 6){
        rate = 1;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
   
   // @synchronized (self.barragePathArray) {
    /*self.barragePathArray-Begin*/
    // 便利一遍弹幕,看有没有出界的弹幕 并且调整弹幕的位置
    
    [self.barragePathArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *path = obj;
        [path  enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx1, BOOL * _Nonnull stop) {
            // 检测有没有弹幕出界
            OSBarrageInfo *barrageInfo = obj;
            // 开启碰撞检测 获取上一个弹幕,如果距离小于5，则后一个弹幕的速度和前一个相同
            if (self.collisionEnable){
                if (idx1  >0){
                    OSBarrageInfo *lastBarrageInfo = path[idx1-1];
                    if (lastBarrageInfo && lastBarrageInfo.barrage.position.x + lastBarrageInfo.barrage.width > barrageInfo.barrage.position.x - 10){
                        barrageInfo.rate = lastBarrageInfo.rate;
                    }
                }
            }
            
            
            // 根据弹幕的不同速度,设置其偏移量
            if (barrageInfo.rate >= rate){
                barrageInfo.barrage.position = GLKVector3Make(barrageInfo.barrage.position.x-0.5, barrageInfo.barrage.position.y, 0.5-idx1/1000.0);
                
            }
            
            // 将移除屏幕的弹幕移除掉
            if (barrageInfo.barrage.position.x + barrageInfo.barrage.width < 0){
                [path removeObject:barrageInfo];
                @synchronized (self.barrageArray) {
                    [self.barrageArray removeObject:barrageInfo];
                }
                
            }
            
        }];
    }];
    
    
    /*self.barragePathArray-Begin*/
   // }
});
    
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
        // 设置默认缓存数量
        self.cachaMaxCount = 100;
        
        // 创建弹道
        _barrageMaxHeight = barrageMaxHeight;
        _displayViewSize = viewSize;
        // 初始化弹幕数组
        _barrageArray = [NSMutableArray array];
        _cachaBarrageInfoArray = [NSMutableArray arrayWithCapacity:100];
        _barragePathArray = [NSMutableArray array];
        
        
        // 创建弹幕路径
        [self createBarragePaths];
          self.timer1 = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(getBarrageFromCacha:) userInfo:nil repeats:true];
         self.timer2 = [NSTimer scheduledTimerWithTimeInterval:0.002 target:self selector:@selector(caluateBarragePosition:) userInfo:nil repeats:true];
        
        
        
        
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
