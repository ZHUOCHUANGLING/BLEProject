//
//  MusicListVC.h
//  BLEProject
//
//  Created by jp on 2016/11/17.
//  Copyright © 2016年 jp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicVC.h"

@interface MusicListVC : UIViewController


@property (nonatomic, assign) ChooseMusicPlayMode musicMode;

@property(nonatomic, strong) MusicFunction *musicOperation;

@property (nonatomic, assign) NSInteger totalNum;
@property (nonatomic, assign) NSInteger currentIndex;

@end
