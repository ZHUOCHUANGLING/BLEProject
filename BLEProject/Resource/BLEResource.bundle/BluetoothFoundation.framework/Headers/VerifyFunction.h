//
//  VerifyFunction.h
//  ModelManagerTestProj
//
//  Created by user on 16/8/5.
//  Copyright © 2016年 user. All rights reserved.
//

/**
 *  预留 验证模块
 */
#import <Foundation/Foundation.h>

typedef void(^peripheralInfoBlock)(NSInteger com,
                              NSInteger chip,
                              NSInteger mainVersion,
                              NSInteger subVersion
                              );
@interface VerifyFunction : NSObject

@property (copy,nonatomic) peripheralInfoBlock peripheralInfo;

- (void)getPeripheralInfo;

@end
