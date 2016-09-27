//
//  Shader.fsh
//  OSBufferText
//
//  Created by xu jie on 16/9/14.
//  Copyright © 2016年 xujie. All rights reserved.
//
precision mediump float;//mediump
uniform sampler2D texture1;
varying  vec2 texCoordVarying;
void main()
{
//    lowp vec4 tet = ;
 
//    if (tet.r <= 0.5 && tet.g <= 0.5 && tet.b <= 0.5){
//        tet.a = 0.0;
//    }else{
//        tet.a = 0.5;
//    }

        gl_FragColor = texture2D(texture1,texCoordVarying).rgba;
   
    
    
    
}
