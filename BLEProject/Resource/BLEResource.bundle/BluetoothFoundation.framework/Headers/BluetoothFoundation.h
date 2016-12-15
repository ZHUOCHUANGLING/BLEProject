//
//  BluetoothFoundation.h
//  BluetoothFoundation
//
//  Created by user on 16/8/8.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
    蓝牙控制管理器
 */
#import "DataStreamManager.h"

/**
 *  各功能模块 使用init进行初始化 
    但仅有最后创建的一个同类模块对象可获取回调
    先创建的同类模块对象会被覆盖 无法获取回调
    建议使用单例对象创建和管理功能模块
 */
#import "AlarmFunction.h"
#import "AUXFunction.h"
#import "ControlFunction.h"
#import "FMFunction.h"
#import "LEDFunction.h"
#import "MusicFunction.h"
#import "OTAFunction.h"
#import "ShakeFunction.h"
#import "VolumeFunction.h"
#import "VerifyFunction.h"
#import "EQFunction.h"
#import "StepFunction.h"
#import "HeartBeatFunction.h"

FOUNDATION_EXPORT double BluetoothFoundationVersionNumber;
FOUNDATION_EXPORT const unsigned char BluetoothFoundationVersionString[];



