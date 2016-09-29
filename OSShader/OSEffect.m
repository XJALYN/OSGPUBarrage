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
        case OSEffectXY:
            effect.vertexShaderName = @"XYShader";
            break;
        case OSEffectYX:
            effect.vertexShaderName = @"YXShader";
            break;
        case OSEffectSin2X:
            effect.vertexShaderName = @"Sin2xShader";
            break;
        case OSEffectSinCosX:
            effect.vertexShaderName = @"SinCosXShader";
            break;
        case OSEffectSinCon2X:
            effect.vertexShaderName = @"SinCon2XShader";
            break;
        case OSEffectFadeIn:
            effect.fragmentShaderName = @"FadeInShader";
            break;
        case OSEffectFadeOut:
            effect.fragmentShaderName = @"FadeOutShader";
            break;
        case OSEffectFadeInOut:
            effect.fragmentShaderName = @"FadeInOutShader";
            break;
        default:
            break;
    }
    return effect;
    
}
@end
