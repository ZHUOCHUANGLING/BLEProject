//
//  HeartBeatFunction.h
//  BluetoothFoundation
//
//  Created by user on 16/10/26.
//  Copyright © 2016年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^HeartBeatBlock)(NSInteger heartRate);  //心率 bpm

@interface HeartBeatFunction : NSObject

/**
 *  更新心率数据
 */
@property (nonatomic, copy) HeartBeatBlock heartBeat;

@end
