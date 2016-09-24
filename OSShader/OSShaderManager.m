//
//  OSShaderManager.m
//  VR 视频播放器
//
//  Created by xu jie on 16/8/12.
//  Copyright © 2016年 xu jie. All rights reserved.
//

#import "OSShaderManager.h"
@interface OSShaderManager()

@end

@implementation OSShaderManager
-(instancetype)init{
    if (self = [super init]){
        // 创建一个程序
        self.program = glCreateProgram();
    }
    return self;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type URL:(NSURL *)URL
{
    NSError *error;
    NSString *sourceString = [[NSString alloc] initWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:&error];
    if (sourceString == nil) {
        NSLog(@"Failed to load vertex shader: %@", [error localizedDescription]);
        return NO;
    }
    
    GLint status;
    const GLchar *source;
    source = (GLchar *)[sourceString UTF8String];
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    // 编译成功后，吸附到程序中去
    glAttachShader(self.program, *shader);
    
    return YES;
}

- (BOOL)linkProgram
{
    GLint status;
    glLinkProgram(_program);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(_program, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(_program, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(_program, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

- (BOOL)validateProgram
{
    GLint logLength, status;
    
    glValidateProgram(_program);
    glGetProgramiv(_program, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(_program, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(_program, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

- (void)bindAttribLocation:(GLuint)index andAttribName:(GLchar*)name{
    glBindAttribLocation(self.program, index, name);
   
}

- (void)deleteShader:(GLuint*)shader{
    if (*shader){
        glDeleteShader(*shader);
        *shader = 0;
    }
}

- (GLint)getUniformLocation:(const GLchar*) name{
   return  glGetUniformLocation(self.program, name);
}

-(void)detachAndDeleteShader:(GLuint *)shader{
    if (*shader){
        glDetachShader(self.program, *shader);
        glDeleteShader(*shader);
        *shader = 0;
    }
    
}

-(void)deleteProgram{
    if (self.program){
        glDeleteProgram(self.program);
        self.program = 0;
    }
    
}

-(void)useProgram{
    glUseProgram(self.program);

}

-(void)dealloc{
    [self deleteProgram];
}
@end
