//
//  GameViewController.h
//  OSBufferText
//
//  Created by xu jie on 16/9/14.
//  Copyright © 2016年 xujie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "OSTextBarrage.h"
#import "OSBarrageInfo.h"

@interface OSDisplayerController : GLKViewController
@property(nonatomic,assign)CGFloat maxBarrageHeight;    // 设置弹幕最大的高度
@property(nonatomic,assign)CGSize disPlayViewSize;      // 弹幕视图的大小 这个要设置的默认为是自己屏幕的大小
@property(nonatomic,assign)NSUInteger maxCachaBarrage;  // 设置最大能缓冲多少个弹幕 默认为 100;
@property(nonatomic,assign)BOOL collisionEnable;        // YES 开启碰撞检测 NO 关闭碰撞检测


-(void)setupBarrageFactory;
-(void)addBarrageInfo:(OSBarrageInfo*)barrageInfo;

@end
