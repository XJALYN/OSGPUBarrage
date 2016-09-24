//
//  OSBarrage.h
//  OSBufferText
//
//  Created by xu jie on 16/9/22.
//  Copyright © 2016年 xujie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <GLKit/GLKit.h>

@interface OSBarrage : NSObject
@property(nonatomic,assign)GLfloat *vertexArray;  // 顶点数组
@property(nonatomic,strong)UIImage *image;        // 文字生成的图片
@property(nonatomic,assign)CGFloat width;         // 弹幕的宽
@property(nonatomic,assign)CGFloat height;        // 弹幕的长
@property(nonatomic,assign)GLKVector3 position;   // 视图中的位置坐标
@property(nonatomic,assign) void* data;           // 纹理数据
@property(nonatomic,assign)CGFloat displayWidth;  // 显示区域的宽度
@property(nonatomic,assign)CGFloat displayHeight; // 显示区域的高度


/*
 * @func  创建顶点数组
 */
-(void)createVerticeArray;


@end
