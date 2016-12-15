//
//  LEDFunction.h
//  ModelManagerTestProj
//
//  Created by user on 16/8/5.
//  Copyright © 2016年 user. All rights reserved.
//

/**
 *  LED灯控制模块
    包含控制接口：
    设置LED灯色彩亮度
    设置灯光场景模式
 *
 */

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,LEDSenceType) {
    
    LEDSenceTypeSingle = 0x01, //LED灯 单色
    LEDSenceTypeColourful   //LED灯 彩色
};

typedef NS_ENUM(NSInteger,LEDSenceTransModel) {
    
    LEDSenceTransModelNormal = 0x01, //只可用于 LEDSenceTypeSingle
    LEDSenceTransModelTwinkle,    //只可用于 LEDSenceTypeColourful
    LEDSenceTransModelBreath,     //都可使用
    LEDSenceTransModelGradually   //只可用于 LEDSenceTypeColourful
};

@interface LEDFunction : NSObject

/**
 *  设置彩灯颜色
 *
 *  @param red   红色 0~255
 *  @param green 绿色 0~255
 *  @param blue  蓝色 0~255
 *  @param white 白色 0~255
 */
- (void)setLightColorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue white:(NSInteger)white;

/**
 *  设置场景模式
 *
 *  @param index 场景模式目录 1~9为预设场景 10为自定义场景
 *  @param type  灯光色彩类型 自定义场景下使用 否则为0
 *  @param trans 灯光变化方式 自定义场景下使用 否则为0
 */
- (void)setLightSenceWithIndex:(NSInteger)index andType:(LEDSenceType)type andTrans:(LEDSenceTransModel)trans;

@end
