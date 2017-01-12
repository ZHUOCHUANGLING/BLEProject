//
//  MusicFunction.h
//  ModelManagerTestProj
//
//  Created by user on 16/8/11.
//  Copyright © 2016年 user. All rights reserved.
//

/**
 *  MUSIC控制模块 主要模块之一 配合控制模块使用 进入时需调用同步接口
 *
 */
#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger,DeviceSource) {
    
    DeviceSourceBluetooth = 0x01,   //蓝牙连接设备
    DeviceSourceSDCard,             //SD卡
    DeviceSourceUDisk               //U盘
};

typedef NS_ENUM(NSInteger,MusicPlayMode) {
    
    MusicPlayModeAllPlay = 0x01,    //全曲播放
    MusicPlayModeSinglePlay,        //单曲播放
    MusicPlayModeRandomPlay         //随机播放
};

typedef NS_ENUM(NSInteger,DeviceControlType) {
    
    DeviceControlTypePrev = 0x01,   //上一曲
    DeviceControlTypePlayOrPause,   //播放或暂停
    DeviceControlTypeNext           //下一曲
};

typedef void(^musicStateBlock)(BOOL isOpen);
typedef void(^deviceSourceOpenBlock)(DeviceSource openSource);
typedef void(^deviceSourceCloseBlock)(DeviceSource closeSource);
typedef void(^currentSourceStateBlock)(DeviceSource currentSource);
typedef void(^currentMusicStateBlock)(NSInteger currentIndex,
                                      //当前歌曲索引 从1开始
                                      NSInteger totalNum,
                                      //歌曲总索引
                                      NSInteger currentTime,
                                      //歌曲当前时间 单位s
                                      NSInteger totalTime,
                                      //歌曲总时间 单位s
                                      BOOL isPlay
                                      //歌曲是否在播放
                                      );

typedef void(^currentSongNameBlock)(NSString *currentSongName);
typedef void(^deviceControlBlock)(DeviceControlType deviceControl);
typedef void(^getSongListNameBlock)(NSString *songListName);


@interface MusicFunction : NSObject

/**
 *  当前音乐状态回调block
 */
@property (copy,nonatomic) musicStateBlock musicState;

/**
 *  歌曲播放设备源开启block
 */
@property (copy,nonatomic) deviceSourceOpenBlock sourceOpen;

/**
 *  歌曲播放设备源关闭block
 */
@property (copy,nonatomic) deviceSourceCloseBlock sourceClose;

/**
 *  当前歌曲播放设备源block
 */
@property (copy,nonatomic) currentSourceStateBlock currentSource;

/**
 *  当前歌曲播放状态block
 */
@property (copy,nonatomic) currentMusicStateBlock currentMusicState;

/**
 *  当前歌曲名回调block
 */
@property (copy,nonatomic) currentSongNameBlock currentSongName;

/**
 *  外设在bluetooth模式下返回控制指令block
 */
@property (copy,nonatomic) deviceControlBlock deviceControl;

/**
 *  歌曲列表名block 返回一首歌曲名 
 */
@property (copy,nonatomic) getSongListNameBlock listSongName;

/**
 *  上一曲
 */
- (void)prev;

/**
 *  下一曲
 */
- (void)next;

/**
 *  设置是否播放
 *
 *  @param isPlay 是否播放 YES为播放 NO为暂停
 */
- (void)setIsPlay:(BOOL)isPlay;

/**
 *  设置外设歌曲播放设备
 *
 *  @param source 外设歌曲播放设备
 */
- (void)setDeviceSource:(DeviceSource)source;

/**
 *  获取歌曲列表指令 获得5条歌曲列表名称
 */
- (void)getSongList;

/**
 *  设置外设播放模式
 *
 *  @param playMode 播放模式
 */
- (void)setDevicePlayMode:(MusicPlayMode)playMode;

/**
 *  设置播放曲目索引目录 从1开始
 *
 *  @param index 曲目目录
 */
- (void)setPlaySongIndex:(NSInteger)index;

/**
 *  设置灯光音乐律动开关
 *
 *  @param isOpen 是否开启音乐律动
 */
- (void)setLightRhythmIsOpen:(BOOL)isOpen;

@end
