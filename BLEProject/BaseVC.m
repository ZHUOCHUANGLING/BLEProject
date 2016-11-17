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
    
    [self initUI];
    
    [ScanVC presentScanVC];
    
}


-(void)initUI{

    [self settingSideBarMode];
    
    UITableViewController *leftVC = (UITableViewController *)self.mm_drawerController.leftDrawerViewController;
    [leftVC tableView:leftVC.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    

}




#pragma mark -  设置侧边栏
-(void)settingSideBarMode{
    

    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeBezelPanningCenterView;
    self.mm_drawerController.closeDrawerGestureModeMask =MMCloseDrawerGestureModeAll;
    self.mm_drawerController.maximumLeftDrawerWidth = ScreenWidth * 0.6;
//    [self.mm_drawerController setShouldStretchDrawer:NO];
    

}









@end
