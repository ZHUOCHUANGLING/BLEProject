//
//  ShakeFunction.h
//  ModelManagerTestProj
//
//  Created by user on 16/8/12.
//  Copyright © 2016年 user. All rights reserved.
//

/**
 *  摇一摇控制接口
    使用加速针框架来调用以下接口 实现对应功能
 *
 */
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ShakeFunctionType) {
    ShakeChangeMusic = 1, //随机改变当前播放的音乐
    ShakeChangeColor,     //随机改变灯光颜色
    ShakeChangeModule,    //随机改变模式，可选项有FM,AUX,Music
};

@interface ShakeFunction : NSObject

/**
 *  设置摇一摇触发的事件
 *
 *  @param rank 1为音乐，2为颜色，3为模式
 */
- (void)setShakeWithRank:(ShakeFunctionType) module;

@end
