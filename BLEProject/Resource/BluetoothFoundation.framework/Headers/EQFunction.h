//
//  EQFunction.h
//  EQframework
//
//  Created by user on 16/9/4.
//  Copyright © 2016年 user. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, EQEffectType) {
    EQ_NORMAL = 0,  //无EQ效果
    EQ_POP,         //流行
    EQ_ROCK,        //摇滚
    EQ_JAZZ,        //爵士
    EQ_CLASSIC,     //古典
    EQ_COUNTRY,     //乡村
    EQ_CUSTOM       //自定义
};

typedef void(^getEQInfoBlock)(EQEffectType type);

typedef void(^getUserEQBlock)(NSDictionary *dict);
@interface EQFunction : NSObject

/**
 *  当前外设EQ信息的回调
 */
@property (nonatomic, copy)getEQInfoBlock getEQ;

@property (nonatomic, copy) getUserEQBlock getUserEQ;
/**
 *  同步当前EQ状态
 */
- (void)synchronizeEQState;
/**
 *  设置EQ的效果
 *
 *  @param effcet 效果的枚举
 */
- (void)setEQWithEffect:(EQEffectType) effcet;

/**
 *  设置自定义音效
 */
- (void)setUserEQ:(NSDictionary *)dict;

@end
