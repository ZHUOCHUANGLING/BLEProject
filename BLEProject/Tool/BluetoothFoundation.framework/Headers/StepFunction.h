//
//  StepFunction.h
//  BluetoothFoundation
//
//  Created by user on 16/10/26.
//  Copyright © 2016年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^StepDataBlock)(NSInteger speed,           //速度 cm/s
                             NSInteger stepLength,      //步长 cm
                             NSInteger cadence,         //步数每分钟
                             NSInteger totalStep,       //总步数
                             NSUInteger totalDistance);  //总路程 cm

@interface StepFunction : NSObject

/**
 *  更新计步数据
 */
@property (nonatomic, copy) StepDataBlock stepData;


@end
