//
//  ControlFunction.h
//  ModelManagerTestProj
//
//  Created by user on 16/8/11.
//  Copyright © 2016年 user. All rights reserved.
//

/**
 *  主功能控制模块
    使外设进入不同的主要模式
    使用同步状态接口来获取当前当前外设模式和其他信息
 *
 */
#import <Foundation/Foundation.h>

//当前外设模式
typedef NS_ENUM(NSInteger,DeviceCurrentState) {
    
    DeviceCurrentStateFM = 0x01,    //FM模式
    DeviceCurrentStateAUX,          //AUX模式
    DeviceCurrentStateMUSIC         //MUSIC模式
};

typedef void(^synchronizeFinishBlock)();
typedef void(^getDeviceCurrentStateBlock)(DeviceCurrentState state);

@interface ControlFunction : NSObject

/**
 *  外设当前状态回调block
 */
@property (copy,nonatomic) getDeviceCurrentStateBlock getDeviceCurrentState;

/**
 *  外设状态同步完成block
 */
@property (copy,nonatomic) synchronizeFinishBlock synchronizeFinish;

/**
 *  同步外设状态
 */
- (void)synchronizeState;

/**
 *  进入FM模式/获取FM信息
 */
- (void)enterFM;
/**
 *  进入音乐模式/获取音乐信息
 */
- (void)enterMusic;
/**
 *  进入AUX模式/获取AUX信息
 */
- (void)enterAUX;

@end
