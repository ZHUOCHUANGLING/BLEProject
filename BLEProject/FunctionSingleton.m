//
//  FunctionSingleton.m
//  BLEProject
//
//  Created by jp on 2016/12/2.
//  Copyright © 2016年 jp. All rights reserved.
//

#import "FunctionSingleton.h"

@implementation FunctionSingleton




static  FunctionSingleton*_instance;
+(instancetype)shareFunction{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[FunctionSingleton alloc] init];

    });
    

    return _instance;
    

}


-(instancetype)init{


    self = [super init];
    
    if (self) {
        self.musicOperation = [[MusicFunction alloc] init];
    }

    return self;
}




@end
