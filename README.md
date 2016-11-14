
#### 基于GPU渲染的弹幕框架

* 支持文字弹幕
* 支持图片弹幕
* 支持GIF动画弹幕
* 支持用户等级排序(暂未实现)
* 支持弹幕碰撞效果和重叠效果
* 支持自定义字体大小和颜色
* 支持多种特效弹幕


#### 使用方法
* 1.创建对象添加到界面上去


    
    
    self.displayVC = [[OSDisplayerController alloc]init];

    [self addChildViewController:self.displayVC];

    [self.view addSubview:self.displayVC.view];

    self.view.backgroundColor = [UIColor blackColor];

*  2.设置展示视图的大小,默认为上面self.displayVC的View的大小


    self.displayVC.disPlayViewSize = CGSizeMake(100, 200);

*  3.初始化弹幕工厂


    [self.displayVC setupBarrageFactory];

*  4.设置缓存弹幕的数量


    self.displayVC.maxCachaBarrage = 1000;

*  5.开启碰撞检测


    self.displayVC.collisionEnable = true;

*  6.创建文字弹幕弹幕


    OSBarrageInfo *barrageInfo = [OSBarrageInfo barrageInfoWithString:@"我是弹幕" font:[UIFont systemFontOfSize:arc4random_uniform(15)+15] color:color];

    barrageInfo.rate = arc4random_uniform(4)+2; // 设置弹幕速度1-5

* 7 创建图片弹幕方法


    OSBarrageInfo *imageBarrage = [OSBarrageInfo barrageInfoWithImage:[UIImage imageNamed:@"image.png"] DisplaySize:CGSizeMake(30, 30)];

    imageBarrage.rate = arc4random_uniform(5)+1;

* 8. 创建GIF弹幕方法


    OSBarrageInfo *gifBarrage = [OSBarrageInfo barrageInfoGif:@[[UIImage imageNamed:@"飙泪_1.png"],[UIImage imageNamed:@"飙泪_2.png"],[UIImage imageNamed:@"飙泪_2.png"]] DisplaySize:CGSizeMake(50, 50) AnimationDuration:0.3];

    gifBarrage.rate = arc4random_uniform(5)+1;

* 9.添加弹幕到渲染控制器


    [self.self.displayVC addBarrageInfo:barrageInfo];

#### 展示图

![让学习成为一种习惯](http://upload-images.jianshu.io/upload_images/1594482-8b9d9ad879d02481.gif?imageMogr2/auto-orient/strip)

![只是其中一种](http://upload-images.jianshu.io/upload_images/1594482-35bf4a943fb94b8f.gif?imageMogr2/auto-orient/strip)
