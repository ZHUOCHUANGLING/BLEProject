//
//  AlarmFunction.h
//  ModelManagerTestProj
//
//  Created by user on 16/8/11.
//  Copyright © 2016年 user. All rights reserved.
//

/**
 *  闹钟功能模块，包含接口：
    设置闹钟
    删除闹钟
    获取闹钟列表
    同步手机时间
 *
 */

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,AlarmRepeatWeekday) {
    
    AlarmRepeatWeekdayNoRepeat  = 0,
    AlarmRepeatWeekdaySaturday  = 1 << 0,   //周六0
    AlarmRepeatWeekdayFriday    = 1 << 1,   //周五2
    AlarmRepeatWeekdayThursday  = 1 << 2,   //周四4
    AlarmRepeatWeekdayWednesday = 1 << 3,   //周三8
    AlarmRepeatWeekdayTuesday   = 1 << 4,   //周二16
    AlarmRepeatWeekdayMonday    = 1 << 5,   //周一32
    AlarmRepeatWeekdaySunday    = 1 << 6    //周日64
};

typedef NS_ENUM(NSInteger,AlarmTaskType) {
    
    AlarmTaskTypeNone = 0x00,  //无任务
    AlarmTaskTypeClock,     //闹钟
    AlarmTaskTypeMusicMode, //打开音乐模式
    AlarmTaskTypeFMMode,    //打开FM模式
    AlarmTaskTypeClose      //关机
};

typedef void(^getAlarmInfoBlock)(NSInteger index,//闹钟索引目录 范围 1~3
                                 BOOL open,//闹钟是否开启
                                 NSInteger hour,//小时
                                 NSInteger minute,//分钟
                                 AlarmRepeatWeekday repeat,//重复时间
                                 AlarmTaskType task,//任务
                                 NSInteger scene,//场景模式 只支持预设场景 1~9
                                 CGFloat channelRate//进入FM模式时 可预设频点 101.0
                                 );
typedef void(^bellStateBlock)(BOOL isBell);

@interface AlarmFunction : NSObject

/**
 *  获取闹钟信息block
 */
@property (copy,nonatomic) getAlarmInfoBlock getAlarmInfo;

/**
 *  响铃状态block
 */
@property (copy,nonatomic) bellStateBlock bellState;

/**
 *  同步手机时间至外设
 */
- (void)calibrateCurrentTime;
/**
 *  获取闹钟列表
 */
- (void)getAlarmList;
/**
 *  添加/设置闹钟
 *
 *  @param index       闹钟目录
 *  @param hour        时
 *  @param minute      分
 *  @param isOpen      是否开启闹钟
 *  @param repeatTime  重复时间(星期)
 *  @param task        任务
 *  @param scene       场景模式
 *  @param channelRate fm任务下可设置频点
 */
- (void)addAlarmWithIndex:(NSInteger)index
                     hour:(NSInteger)hour
                   minute:(NSInteger)minute
                   isOpen:(BOOL)isOpen
               repeatTime:(AlarmRepeatWeekday)repeatTime
                     task:(AlarmTaskType)task
                    scene:(NSInteger)scene
            fmChannelRate:(CGFloat)channelRate;

/**
 *  移除闹钟 之后闹钟顺序会更新 需重新获取闹钟列表
 *
 *  @param index 要移除闹钟的目录
 */
- (void)removeAlarmAtIndex:(NSInteger)index;

@end
