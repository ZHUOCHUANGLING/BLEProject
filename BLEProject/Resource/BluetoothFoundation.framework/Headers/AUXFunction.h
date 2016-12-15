//
//  AUXFunction.h
//  ModelManagerTestProj
//
//  Created by user on 16/8/12.
//  Copyright © 2016年 user. All rights reserved.
//

/**
 *  AUX功能模块 主要功能之一
    配合控制模块使用
 *
 */
#import <Foundation/Foundation.h>

typedef void(^getAuxStateBlock)(BOOL state);
typedef void(^getAuxVolBlock)(NSInteger vol);

@interface AUXFunction : NSObject

/**
 *  AUX模式状态 switch为是否接入 00为未接入 01为已接入
 */
@property (nonatomic, copy) getAuxStateBlock getAuxState;

/**
 *  AUX模式内容 vol表示当前音量级数 0~15 该接口存在局限
    最好使用volume模块的音量接口
 */
@property (nonatomic, copy) getAuxVolBlock getAuxVol;


@end
