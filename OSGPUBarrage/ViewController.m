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
    
   // self.displayVC.maxBarrageHeight = 100;
    
    // 3.初始化弹幕工厂
    [self.displayVC setupBarrageFactoryWithEffectType:OSEffectNo];
    
    // 4.设置缓存弹幕的数量
    self.displayVC.maxCachaBarrage = 50;
    
    // 5.开启碰撞检测
   // self.displayVC.collisionEnable = true;
    
    [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(generateText:) userInfo:nil repeats:true];
    
    
    
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
    static int i = 0;
    i++;
    UIColor *color = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (i%2 == 0){
            // 创建文字弹幕
            OSBarrageInfo *textBarrage = [OSBarrageInfo barrageInfoWithString:@"弹幕" font:[UIFont systemFontOfSize:30] color:color];
            textBarrage.rate = arc4random_uniform(5)+1;
             [self.self.displayVC addBarrageInfo:textBarrage];
        }else if (i%3 ==1){
             //创建图片弹幕
            OSBarrageInfo *imageBarrage = [OSBarrageInfo barrageInfoWithImage:[UIImage imageNamed:@"image.png"] DisplaySize:CGSizeMake(40, 40)];
            imageBarrage.rate = arc4random_uniform(5)+1;
            [self.displayVC addBarrageInfo:imageBarrage];
        }else{
            OSBarrageInfo *gifBarrage = [OSBarrageInfo barrageInfoGif:@[[UIImage imageNamed:@"飙泪_1.png"],[UIImage imageNamed:@"飙泪_2.png"],[UIImage imageNamed:@"飙泪_2.png"]] DisplaySize:CGSizeMake(50, 50) AnimationDuration:0.3];
            gifBarrage.rate = arc4random_uniform(5)+1;
            [self.displayVC addBarrageInfo:gifBarrage];
        }
    

    
    
        
   });
}



@end
