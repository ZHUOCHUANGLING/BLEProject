//
//  MusicFunctionManger.m
//  BLEProject
//
//  Created by jp on 2016/12/28.
//  Copyright © 2016年 jp. All rights reserved.
//

#import "MusicFunctionManger.h"


static MusicFunction *_instance;
inline MusicFunction* shareMusicOperation() {
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[MusicFunction alloc] init];
    });
    
    return _instance;
    
}



static NSMutableArray *_arrInstance;
inline NSMutableArray *shareTFSongListArr() {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _arrInstance = [NSMutableArray array];
    });
    
    return _arrInstance;
}





@implementation MusicFunctionManger


@end
