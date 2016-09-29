//
//  GameViewController.m
//  OSBufferText
//
//  Created by xu jie on 16/9/14.
//  Copyright © 2016年 xujie. All rights reserved.
//

#import "OSDisplayerController.h"
#import <OpenGLES/ES2/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <GLKit/GLKit.h>
#import "OSShaderManager.h"
#import "OSTextBarrage.h"
#import "OSBarrageInfo.h"


#define BUFFER_OFFSET(i) ((char *)NULL + (i))
#define FramesPerSecond 60

// 纹理坐标
static const GLfloat coords[8] = {
    0,0,
    1,0,
    0,1,
    1,1,
    
};



@interface OSDisplayerController ()

{
    GLuint _program;
    GLuint _vertexBuffer;
    GLuint _coordBuffer;
    GLuint _texImageBuffer;
    GLuint _textureBuffer;
    
    
}
@property(nonatomic,strong)UIImageView *imageView;
@property(strong, nonatomic) EAGLContext *context;
@property(nonatomic,strong)NSMutableArray  *textArray;
@property(nonatomic,assign)BOOL textChange;
@property(nonatomic,strong)OSShaderManager *shaderManager;
@property(nonatomic,strong)OSEffect *effect;

@end


@implementation OSDisplayerController



-(NSMutableArray *)textArray{
    
    if(!_textArray){
        _textArray = [NSMutableArray array];
        return _textArray;
    }
    return _textArray;
    
}

//-----------------------------------------------------------
#pragma mark -
#pragma mark - 初始化代码
//-----------------------------------------------------------

-(instancetype)init{
    if (self = [super init]){
        [self configure];
        
    }
    return self;
}


-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]){
        [self configure];
        
    }
    return self;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        [self configure];
        
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // 初始化
    
    
    
}

-(void)setCollisionEnable:(BOOL)collisionEnable{
    if (self.barrageFactory){
        self.barrageFactory.collisionEnable = collisionEnable;
    }
    _collisionEnable = collisionEnable;
}

//-----------------------------------------------------------
#pragma mark -
#pragma mark - 配置界面 设置帧率 颜色格式
//-----------------------------------------------------------
-(void)configure{
    GLKView *view = (GLKView *)self.view;
    view.backgroundColor = [UIColor clearColor];
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    // 设置帧率
    self.preferredFramesPerSecond = FramesPerSecond;
}

//-----------------------------------------------------------
#pragma mark -
#pragma mark - 初始化弹幕厂
//-----------------------------------------------------------
-(void)setupBarrageFactoryWithEffectType:(OSEffectType)effectType{
    self.effect = [OSEffect effectWithType:effectType];
    [self setupGL];
    self.barrageFactory = [OSBarrageFactory barrageFactoryWithBarrageMaxHeight:self.maxBarrageHeight DisplayViewSize:self.disPlayViewSize];
    self.barrageFactory.cachaMaxCount = self.maxCachaBarrage; // 设置最大缓存
    
    // 重新调整弹幕的大小
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.disPlayViewSize.width, self.disPlayViewSize.height);
    
    
}

-(void)setMaxCachaBarrage:(NSUInteger)maxCachaBarrage{
    _maxCachaBarrage = maxCachaBarrage;
    if (self.barrageFactory){
        self.barrageFactory.cachaMaxCount = maxCachaBarrage;
    }
}

//-----------------------------------------------------------
#pragma mark -
#pragma mark - 添加弹幕到弹幕工厂
//-----------------------------------------------------------
-(void)addBarrageInfo:(OSBarrageInfo*)barrageInfo{
    [self.barrageFactory addBarrageInfo:barrageInfo];
}




//-----------------------------------------------------------
#pragma mark -
#pragma mark - 释放资源
//-----------------------------------------------------------
- (void)dealloc
{
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}


//-----------------------------------------------------------
#pragma mark -
#pragma mark - 内存警告清除工作
//-----------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        [self tearDownGL];
        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }
}

//-----------------------------------------------------------
#pragma mark -
#pragma mark - 初始化OpenGL
//-----------------------------------------------------------

- (void)setupGL
{
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    ((GLKView*)self.view).context = self.context;
    // 设置深度格式
    
    
    // 设置上下文
    [EAGLContext setCurrentContext:self.context];
    // 导入着色器程序
    if (!self.effect){
        
        self.effect = [OSEffect effectWithType:OSEffectNo];
    }
    [self createShaderProgramVertexShaderName:self.effect.vertexShaderName FragmentShaderName:self.effect.fragmentShaderName];
    
    
    // 启用着色器
    [self.shaderManager useProgram];
    glEnable(GL_DEPTH_TEST);
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    glUniform1i(_textureBuffer, 0); // 0 代表GL_TEXTURE0
    
    //    // 启动深度测试
    glEnable(GL_DEPTH_TEST);
    glFrustumf(1.0, 1.0, 1.0, 1.0, 0.1, 30.0);
    
    
    
    // 绑定纹理坐标
    glGenBuffers(1, &_coordBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _coordBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(coords), coords, GL_STATIC_DRAW);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 8, NULL);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    
    // 设置默认最大弹幕的高度
    self.maxBarrageHeight = 50;
    self.disPlayViewSize = self.view.frame.size;
    self.maxCachaBarrage = 100;
    self.collisionEnable = true;
    
}


//-----------------------------------------------------------
#pragma mark -
#pragma mark - 创建着色器程序
//-----------------------------------------------------------
-(void)createShaderProgramVertexShaderName:(NSString*)vshName FragmentShaderName:(NSString*)fshName{
    self.shaderManager = [[OSShaderManager alloc]init];
    // 编译连个shader 文件
    GLuint vertexShader,fragmentShader;
    NSURL *vertexShaderPath = [[NSBundle mainBundle]URLForResource:vshName withExtension:@"vsh"];
    NSURL *fragmentShaderPath = [[NSBundle mainBundle]URLForResource:fshName withExtension:@"fsh"];
    if (![self.shaderManager compileShader:&vertexShader type:GL_VERTEX_SHADER URL:vertexShaderPath]||![self.shaderManager compileShader:&fragmentShader type:GL_FRAGMENT_SHADER URL:fragmentShaderPath]){
        return ;
    }
    
    // 注意获取绑定属性要在连接程序之前 location 随便你写
    [self.shaderManager bindAttribLocation:GLKVertexAttribPosition andAttribName:"position"];
    [self.shaderManager bindAttribLocation:GLKVertexAttribTexCoord0 andAttribName:"texCoord0"];
    
    // 将编译好的两个对象和着色器程序进行连接
    if(![self.shaderManager linkProgram]){
        [self.shaderManager deleteShader:&vertexShader];
        [self.shaderManager deleteShader:&fragmentShader];
    }
    _texImageBuffer = glGetUniformLocation(_program, "texture1");
    
    [self.shaderManager detachAndDeleteShader:&vertexShader];
    [self.shaderManager detachAndDeleteShader:&fragmentShader];
    
    
}


//-----------------------------------------------------------
#pragma mark -
#pragma mark - 清理工作
//-----------------------------------------------------------

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    glDeleteBuffers(1, &_vertexBuffer);
    if (_program) {
        glDeleteProgram(_program);
        _program = 0;
    }
}

#pragma mark - GLKView and GLKViewController delegate methods


//-----------------------------------------------------------
#pragma mark -
#pragma mark - 渲染屏幕
//-----------------------------------------------------------

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    // 渲染弹幕
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
  
    for (OSBarrageInfo *barrageInfo in self.barrageFactory.barrageArray){
           [barrageInfo drawToGPU];
        if (barrageInfo.isDelete){
            barrageInfo.canDelete = true;
            [barrageInfo deleteVertexAndTextureFromGPU];
        }
    }
       
  
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}







@end
