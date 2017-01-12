//
//  FMFunction.h
//  ModelManagerTestProj
//
//  Created by user on 16/8/10.
//  Copyright © 2016年 user. All rights reserved.
//

/**
 *  FM控制模块 主要功能模块之一
    包含控制接口：
    上一台
    下一台
    搜索
    设置频点
 
    搜索状态回调
    FM当前频点状态回调
 *
 */
#import <UIKit/UIKit.h>

typedef void(^channelResponseBlock)(NSInteger currentChannel,   //当前频点目录
                                    NSInteger totalChannel,     //总频点目录
                                    CGFloat channelRate         //当前频点
                                    );

typedef void(^searchStateBlock)(BOOL isSearch);

@interface FMFunction : NSObject

/**
 *  FM当前频点状态回调
 */
@property (copy,nonatomic) channelResponseBlock channelResponse;

/**
 *  频点搜索状态回调
 */
@property (copy,nonatomic) searchStateBlock searchState;

/**
 *  下一台
 */
- (void)pervStation;
/**
 *  上一台
 */
- (void)nextStation;
/**
 *  搜索或停止搜索
 */
- (void)startOrStopSearchStation;

/**
 *  设置指定频点
 *
 *  @param rate 频点 范围 87.5~108.0
 */
- (void)setStationChannelWithRate:(CGFloat)rate;

@end
