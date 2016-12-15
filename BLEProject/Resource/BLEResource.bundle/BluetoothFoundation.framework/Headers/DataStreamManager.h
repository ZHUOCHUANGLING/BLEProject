//
//  DataStreamManager.h
//  ModelManagerTestProj
//
//  Created by user on 16/8/1.
//  Copyright © 2016年 user. All rights reserved.
//
/**
 *  蓝牙控制管理单例
    包含蓝牙控制对应接口
    通知内容在userInfo中
 */
#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
/**
 *  中心设备状态更新通知
 */
extern NSString *const BLECentralStateUpdateNotification;

/**
 *  搜索到外设通知
 */
extern NSString *const BLEScanedPeripheralNotification;

/**
 *  连接外设成功通知
 */
extern NSString *const BLEPeripheralConnectSuccedNotification;

/**
 *  连接外设失败通知
 */
extern NSString *const BLEConnectFailNotification;

/**
 *  断开外设连接通知
 */
extern NSString *const BLEPeripheralDisconnectNotification;

/**
 *  订阅通知完成 此时才可对外设进行操作
 */
extern NSString *const BLEPeripheralSetNotificationCompelete;

/**
 *  获取到未识别的外设数据通知 订阅该通知用于获取自定义通知数据
 */
extern NSString *const BLENotFoundCorrespondMsgNotification;


@interface DataStreamManager : NSObject

@property (weak,nonatomic) NSMutableArray <CBPeripheral *> *searchedPeripheralArr;

@property (weak,nonatomic) CBPeripheral *connectedPeripheral;
/**
 *  单例管理对象
 *
 */
+ (instancetype)sharedManager;

/**
 *  开始搜索
 */
- (void)startScan;

/**
 *  停止搜索
 */
- (void)stopScan;

/**
 *  连接指定外设
 *
 *  @param peripheral 指定外设
 */
- (void)connectPeripheral:(CBPeripheral *)peripheral;

/**
 *  断开已连接的外设
 */
- (void)disconnectPeripheral;

/**
 *  发送数据至指定特征
 *
 *  @param serviceUUID        服务UUID
 *  @param characteristicUUID 特征UUID
 *  @param data               数据
 */
- (void)sendDataWithService:(NSString *)serviceUUID characteristic:(NSString *)characteristicUUID data:(NSData *)data;
/**
 *  读取指定特征数据
 *
 *  @param serviceUUID        服务UUID
 *  @param characteristicUUID 特征UUID
 */
- (void)readValueWithService:(NSString *)serviceUUID characteristic:(NSString *)characteristicUUID;

- (void)loadTransModelFileWithDictionary:(NSDictionary *)dict;

@end
