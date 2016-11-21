//
//  BaseVC.m
//  BLEProject
//
//  Created by jp on 2016/11/14.
//  Copyright © 2016年 jp. All rights reserved.
//

#import "BaseVC.h"
#import "ScanVC.h"

@interface BaseVC ()
@end

@implementation BaseVC



- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self initFunction];
    [self initUI];
    
    
    [self initFirstViewController];
    [ScanVC presentScanVC];
    
}



-(void)initFunction{

    //让app支持接受远程控制事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}



-(void)initUI{

    [self settingSideBarMode];
    
}




#pragma mark -  设置侧边栏
-(void)settingSideBarMode{
    

    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeBezelPanningCenterView;
    self.mm_drawerController.closeDrawerGestureModeMask =MMCloseDrawerGestureModeAll;
    self.mm_drawerController.maximumLeftDrawerWidth = ScreenWidth * 0.6;
//    [self.mm_drawerController setShouldStretchDrawer:NO];
    

}


#pragma mark -  弹出第一个功能界面
-(void)initFirstViewController{

    UITableViewController *leftVC = (UITableViewController *)self.mm_drawerController.leftDrawerViewController;
    [leftVC tableView:leftVC.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];

}





@end
