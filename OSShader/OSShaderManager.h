//
//  OSShaderManager.h
//  VR 视频播放器
//
//  Created by xu jie on 16/8/12.
//  Copyright © 2016年 xu jie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import <OpenGLES/ES2/glext.h>
#import <OpenGLES/ES2/gl.h>
/**
 *  次对象专门负责管理
 */

@interface OSShaderManager : NSObject
@property GLuint program;
/**
 *  编译shader程序
 *
 *  @param shader shader名称
 *  @param type   shader 类型
 *  @param URL    shader 本地路径
 *
 *  @return 是否编译成功
 */
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type URL:(NSURL *)URL;

/**
 *  连接程序
 *  @return 连接程序是否成功
 */
- (BOOL)linkProgram;

/**
 *  验证程序是否成功
 *
 *  @param prog 程序标示
 *
 *  @return 返回是否成功标志
 */
- (BOOL)validateProgram;

/**
 *  绑定着色器的属性
 *  @param index 属性在shader 程序的索引位置
 *  @param name  属性名称
 */
- (void)bindAttribLocation:(GLuint)index andAttribName:(GLchar*)name;

/**
 *  删除shader
 */
- (void)deleteShader:(GLuint*)shader;


/**
 *  获取属性值索引位置
 *
 *  @param name 属性名称
 *
 *  @return 返回索引位置
 */
- (GLint)getUniformLocation:(const GLchar*) name;

/**
 * 释放, 删除shader
 *  @param shader 着色器名称
 */

-(void)detachAndDeleteShader:(GLuint*)shader;

/**
 *  使用程序
 */
-(void)useProgram;

@end
