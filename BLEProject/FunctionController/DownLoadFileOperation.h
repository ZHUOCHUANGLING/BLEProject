//
//  DownLoadFileOperation.h
//  BLEProject
//
//  Created by jp on 2017/1/9.
//  Copyright © 2017年 jp. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const DownLoadFirmwareFileCompleted;

@interface DownLoadFileOperation : NSObject

-(void)startDownLoadWithVersion:(NSString *)version;


@end
