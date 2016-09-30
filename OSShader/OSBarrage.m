//
//  OSBarrage.m
//  OSBufferText
//
//  Created by xu jie on 16/9/22.
//  Copyright © 2016年 xujie. All rights reserved.
//

#import "OSBarrage.h"
#import "OSBarrageInfo.h"

@implementation OSBarrage

//-----------------------------------------------------------
#pragma mark -
#pragma mark - 释放内存
//-----------------------------------------------------------
-(void)dealloc{
    if(self.vertexArray){
        free(_vertexArray);
        _vertexArray = 0;
    }
    if (self.data){
        free(_data);
        _data = 0;
    }
    self.image = nil;
    
}

//-----------------------------------------------------------
#pragma mark -
#pragma mark - 创建并且计算顶点数据
//-----------------------------------------------------------
-(void)createVerticeArray{
    CGFloat maxWidth = self.displayWidth;
    CGFloat maxHeight = self.displayHeight;
    //self.vertexArray = (GLfloat*)(malloc(sizeof(GLfloat)*12));
   // memset(_vertexArray, 0,sizeof(GLfloat)*12);
    self.vertexArray = (GLfloat*)calloc(12, sizeof(CGFloat));
    
    *_vertexArray = -1 + _position.x / maxWidth*2;
    *(_vertexArray+1)= 1 - _position.y / maxHeight*2;
    *(_vertexArray+2)= _position.z;
    
    *(_vertexArray+3)= -1 + (_position.x+self.width) /maxWidth*2;
    *(_vertexArray+4)= 1 - _position.y /maxHeight*2;
    *(_vertexArray+5)= _position.z;
    
    *(_vertexArray+6)= -1 + _position.x / maxWidth*2;
    *(_vertexArray+7)= 1 - (_position.y + self.height) / maxHeight*2;
    *(_vertexArray+8)= _position.z;
    
    *(_vertexArray+9)= -1 + (_position.x+self.width) /maxWidth*2;
    *(_vertexArray+10)= 1 - (_position.y + self.height) / maxHeight*2;
    *(_vertexArray+11)= _position.z;
}

-(void)setPosition:(GLKVector3)position{
    CGFloat maxWidth = self.displayWidth;
    CGFloat maxHeight = self.displayHeight;
    if (position.x != _position.x){
        *_vertexArray = -1 + position.x / maxWidth*2;
        *(_vertexArray+3)= -1 + (position.x+_width) /  maxWidth*2;
        *(_vertexArray+6)= -1 + position.x / maxWidth*2;
        *(_vertexArray+9)= -1 + (position.x+_width) / maxWidth*2;
    }
    if (position.y != _position.y){
        *(_vertexArray+1)= 1 - position.y /maxHeight*2;
        *(_vertexArray+4)= 1 - position.y / maxHeight*2;
        *(_vertexArray+7)= 1 - (position.y + _height) / maxHeight*2;
        *(_vertexArray+10)= 1 - (position.y + _height)/ maxHeight*2;
    }
    if (position.z != _position.z){
        *(_vertexArray+2)= position.z;
        *(_vertexArray+5)= position.z;
        *(_vertexArray+8)= position.z;
        *(_vertexArray+11)= position.z;
    }
    // TEST
    _position = position;
}
-(instancetype)init{
    if (self = [super init]){
        self.displayHeight = [UIScreen mainScreen].bounds.size.height;
        self.displayWidth = [UIScreen mainScreen].bounds.size.width;
    }
    return self;
}

@end
