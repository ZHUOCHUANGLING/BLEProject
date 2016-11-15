 //
//  OTAFunction.h
//  ModelManagerTestProj
//
//  Created by user on 16/8/11.
//  Copyright © 2016年 user. All rights reserved.
//

/**
 *  OTA升级模块 包含接口：
    第一次握手
    第一次握手回调
    传输数据接口 传输数据时需保持屏幕常亮 即应用存在于前台
    完成数据传输
    完成数据传输回调
 *
 */

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,OTAUpdatePolicy) {
    
    OTAUpdatePolicyOnlyMP3 = 0x01,  //只升级mp3模块
    OTAUpdatePolicyBluetoothAndMP3, //升级蓝牙和mp3模块
    OTAUpdatePolicyAll              //完整升级
};

typedef void(^startResponseBlock)(BOOL isPrepared);
typedef void(^finishResponseBlock)(BOOL isSucced);
typedef void(^sendDataProgressBlock)(CGFloat progress);
typedef void(^completeBlock)();

@interface OTAFunction : NSObject

/**
 *  开始握手应答 外设是否准备完毕
 */
@property (copy,nonatomic) startResponseBlock startResponse;

/**
 *  结束握手应答 数据是否传输成功
 */
@property (copy,nonatomic) finishResponseBlock finishResponse;

/**
 *  传输开始握手
 *
 *  @param policy OTA升级策略
 */
- (void)startOTAHandleWithPolicy:(OTAUpdatePolicy)policy;

/**
 *  将升级数据导入获取验证信息进行验证
 *
 *  @param data 用于OTA升级的数据
 */
- (void)finishOTAUpdateWithData:(NSData *)data;

/**
 *  发送OTA升级文件 该方法会在全局队列中异步执行
 *
 *  @param data          OTA升级文件
 *  @param progressBlock 进度block
 *  @param completeBlock 传输完成block
 */
- (void)sendOTADataWithData:(NSData *)data andProgressBlock:(sendDataProgressBlock)progressBlock andCompleteBlock:(completeBlock)completeBlock;

@end
