//
//  OnlineMusicVC.m
//  BLEProject
//
//  Created by jp on 2016/11/29.
//  Copyright © 2016年 jp. All rights reserved.
//





#import "OnlineMusicVC.h"
#import "UIViewController+MMDrawerController.h"

typedef NS_ENUM(NSInteger, ChooseMusicPlayMode) {
    LocalMusicMode,
    TFMusicMode,
    OnlineMusicMode
};

@interface OnlineMusicVC ()
@property (weak, nonatomic) IBOutlet UIView *chooseModeBGView;

@end

@implementation OnlineMusicVC
{

    ChooseMusicPlayMode currentMusicMode;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}





- (IBAction)showMusicMode:(UIBarButtonItem *)sender {

    _chooseModeBGView.hidden = _chooseModeBGView.hidden?NO:YES;
    
    
}


- (IBAction)chooseMusicMode:(UIButton *)sender {
    
    currentMusicMode = sender.tag;
    
    switch (currentMusicMode) {
        case LocalMusicMode:
            self.navigationItem.title = @"本地音乐";
            
            break;
            
        case TFMusicMode:{
            self.navigationItem.title = @"TF卡音乐";
            
            
            
            break;
            
        }
            
        case OnlineMusicMode:
            self.navigationItem.title = @"在线音乐";
            
            
            break;
            
        default:
            break;
    }
    
    
    
    
    
    _chooseModeBGView.hidden = YES;
    
    [[NSUserDefaults standardUserDefaults] setInteger:currentMusicMode forKey:@"ChooseMusicPlayMode"];
    
    
    UITableViewController *leftVC = (UITableViewController *)self.mm_drawerController.leftDrawerViewController;
    [leftVC tableView:leftVC.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
    
    
}














@end
