//
//  MusicTabbarVC.h
//  BLEProject
//
//  Created by jp on 2016/12/24.
//  Copyright © 2016年 jp. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MusicTabbarVCDelegate <NSObject>

@optional

-(void)pausePlayingMusic;

@end


@interface MusicTabbarVC : UITabBarController

@property (nonatomic ,weak) id <MusicTabbarVCDelegate> delegate;

@property (strong, nonatomic) UITableView *chooseModeTableView;

@end
