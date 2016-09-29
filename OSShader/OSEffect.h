//
//  OSEffective.h
//  OSGPUBarrage
//
//  Created by xu jie on 16/9/26.
//  Copyright © 2016年 xujie. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    OSEffectNo,
    OSEffectSin,
    OSEffectCos,
    OSEffectSin2,
    OSEffectCos2,
    OSEffectXY,
    OSEffectYX,
    OSEffectSin2X,
    OSEffectSinCon2X,
    OSEffectSinCosX,
    OSEffectFadeIn,
    OSEffectFadeOut,
    OSEffectFadeInOut
    
    
} OSEffectType;

@interface OSEffect : NSObject
@property(nonatomic,strong)NSString *vertexShaderName;  // 顶点着色器名称
@property(nonatomic,strong)NSString *fragmentShaderName;// 片段着色器名称

/*
 * @func  生成特效类
 * @param effectType 特效名称
 * @return 特效类
 */

+(OSEffect*)effectWithType:(OSEffectType)effectType;

@end
