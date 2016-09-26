//
//  OSEffective.m
//  OSGPUBarrage
//
//  Created by xu jie on 16/9/26.
//  Copyright © 2016年 xujie. All rights reserved.
//

#import "OSEffect.h"

@implementation OSEffect
+(OSEffect*)effectWithType:(OSEffectType)effectType{
    OSEffect *effect = [[OSEffect alloc]init];
             effect.fragmentShaderName = @"Shader";
               effect.vertexShaderName = @"Shader";
    switch (effectType) {
        case OSEffectSin:
            effect.vertexShaderName = @"SinShader";

            break;
        case OSEffectSin2:
            effect.vertexShaderName = @"Sin2Shader";
            break;
        case OSEffectCos:
            effect.vertexShaderName = @"CosShader";
            break;
        case OSEffectCos2:
            effect.vertexShaderName = @"Cos2Shader";
            break;
        default:
           
            break;
    }
    return effect;
    
}
@end
