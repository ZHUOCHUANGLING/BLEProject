//
//  MainControlSingleton.h
//  BLEProject
//
//  Created by jp on 2016/12/27.
//  Copyright © 2016年 jp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainControlSingleton : NSObject

extern MainControlSingleton* shareMainManager();



@property(nonatomic, strong)ControlFunction *controlOperation;
@property(nonatomic, strong)VolumeFunction *volumeOperation;



@end
