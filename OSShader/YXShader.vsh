//
//  Shader.vsh
//  OSBufferText
//
//  Created by xu jie on 16/9/14.
//  Copyright © 2016年 xujie. All rights reserved.
//
precision mediump float;//mediump
attribute vec4 position;
attribute vec2 texCoord0;
varying  vec2 texCoordVarying;



void main()
{
    
   
    float y  = position.x*position.y;
    texCoordVarying = texCoord0;
    gl_Position = vec4(position.x,y,position.z,1);
}
