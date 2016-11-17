//
//  MusicVC.m
//  BLEProject
//
//  Created by jp on 2016/11/16.
//  Copyright © 2016年 jp. All rights reserved.
//

#import "MusicVC.h"

@interface MusicVC ()

@end

@implementation MusicVC
{
    NSMutableArray *_songListArr;
}

- (NSMutableArray *)songListArr{
    
    if (!_songListArr) {
        _songListArr = [NSMutableArray array];
    }
    return _songListArr;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
}



@end
