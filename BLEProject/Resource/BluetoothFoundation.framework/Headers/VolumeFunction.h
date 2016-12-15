//
//  VolumeFunction.h
//  ModelManagerTestProj
//
//  Created by user on 16/8/10.
//  Copyright © 2016年 user. All rights reserved.
//

/**
 *  全局音量模块
    用于控制全局音量
    包含接口：
    音量设置
    当前音量回调
 *
 */
#import <Foundation/Foundation.h>


typedef void(^getCurrentVolBlock)(NSInteger currentVol);
@interface VolumeFunction : NSObject

/**
 *  当前音量 回调Block
 */
@property (copy,nonatomic) getCurrentVolBlock currentVolBlock;

/**
 *  设置当前音量级数
 *
 *  @param rank 音量级数  0~15
 */
- (void)setDeviceVolumeWithRank:(NSInteger)rank;

@end
