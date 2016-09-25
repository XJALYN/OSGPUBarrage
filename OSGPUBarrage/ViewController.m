//
//  ViewController.m
//  OSBufferText
//
//  Created by xu jie on 16/9/21.
//  Copyright © 2016年 xujie. All rights reserved.
//

#import "ViewController.h"
#import "OSDisplayerController.h"
#import <SceneKit/SceneKit.h>

@interface ViewController ()
@property(nonatomic,strong)OSDisplayerController *displayVC;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.创建对象添加到界面上去
    self.displayVC = [[OSDisplayerController alloc]init];
    [self addChildViewController:self.displayVC];
    [self.view addSubview:self.displayVC.view];
    self.view.backgroundColor = [UIColor blackColor];
    
    // 2.设置展示视图的大小,默认为上面self.displayVC的View的大小
    //self.displayVC.disPlayViewSize = CGSizeMake(100, 200);
    
    // 3.初始化弹幕工厂
    [self.displayVC setupBarrageFactory];
    
    // 4.设置缓存弹幕的数量
    self.displayVC.maxCachaBarrage = 100;
    
    // 5.开启碰撞检测
    self.displayVC.collisionEnable = true;
    
    [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(generateText:) userInfo:nil repeats:true];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-----------------------------------------------------------
#pragma mark -
#pragma mark - 定时产生弹幕对象
//-----------------------------------------------------------
-(void)generateText:(NSTimer*)timer{
    
    UIColor *color = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
  
    OSBarrageInfo *barrageInfo = [OSBarrageInfo barrageInfoWithString:@"我是弹幕啊" font:[UIFont systemFontOfSize:arc4random_uniform(15)+15] color:color];
    barrageInfo.rate = arc4random_uniform(4)+2;
    [self.self.displayVC addBarrageInfo:barrageInfo];
    
}

@end
