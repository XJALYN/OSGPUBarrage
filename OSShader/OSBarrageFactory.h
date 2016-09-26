//
//  OSBarrageFactory.h
//  OSBufferText
//
//  Created by xu jie on 16/9/22.
//  Copyright © 2016年 xujie. All rights reserved.
//
//------------------------------------------------
// 弹幕工厂类
// 主要任务:生成文字弹幕和图片弹幕,自动计算弹幕的位置,根据优先级排序,设置最大缓存数量
//------------------------------------------------

#import <Foundation/Foundation.h>
#import "OSBarrageInfo.h"

typedef enum : NSUInteger {
    OSSortRank,  // 等级排序
    OSSortTime,  // 时间排序
} OSSortType;

/// 添加弹幕错误类型
typedef enum : NSUInteger {
    OSCachaFill,
    OSSuccess,
    OSError,
} OSErrorType;

@interface OSBarrageFactory : NSObject
@property(atomic,strong)NSMutableArray *barragePathArray;  // 弹道数组,弹道中放的是弹幕
@property(atomic,strong)NSMutableArray *barrageArray;
@property(nonatomic,assign)NSInteger displayMaxCount;         // 显示弹幕的最大数量 如果不设置,默认为满屏
@property(nonatomic,assign)NSInteger cachaMaxCount;           // 缓冲区弹幕的数量
@property(nonatomic,assign)OSSortType  sortType;              // 排序类型
@property(nonatomic,assign)BOOL collisionEnable;              // YES 开启碰撞检测 NO 关闭碰撞检测

/*
 * @func  添加弹幕到缓冲区
 * @return 弹幕是否添加成功的状态
 */
-(OSErrorType)addBarrageInfo:(OSBarrageInfo*)barrageInfo;

/*
 * @func  清除缓冲区中所有弹幕
 */
-(void)clearAllBarrageInCacha;

/*
 * @func  清除显示区域的所有弹幕
 */
-(void)clearAllBarrageInDisplay;

/*
 * @func  清除缓冲区和显示区域的所有弹幕
 */
-(void)clearAllBarrage;

/*
 * @func  类方法创建弹幕工厂对象
 * @param  barrageMaxHeight 弹幕最大的高度
 * @param DisplayViewSize 显示区域的大小
 * @return 弹幕工厂类
 */
+(OSBarrageFactory*)barrageFactoryWithBarrageMaxHeight:(NSUInteger)barrageMaxHeight DisplayViewSize:(CGSize)viewSize;



@end
