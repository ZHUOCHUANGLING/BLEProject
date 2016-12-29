//
//  MainControlSingleton.m
//  BLEProject
//
//  Created by jp on 2016/12/27.
//  Copyright © 2016年 jp. All rights reserved.
//

#import "MainControlSingleton.h"

static MainControlSingleton *_instance;

inline MainControlSingleton* shareMainManager() {
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[MainControlSingleton alloc] init];
    });
    
    return _instance;
    
}




@implementation MainControlSingleton


-(instancetype)init{

    self = [super init];
    
    if (self) {
        self.controlOperation = [[ControlFunction alloc] init];
        self.volumeOperation = [[VolumeFunction alloc] init];
    }
    return self;



}









@end
