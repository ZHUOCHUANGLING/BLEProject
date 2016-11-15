//
//  BaseVC.m
//  BLEProject
//
//  Created by jp on 2016/11/14.
//  Copyright © 2016年 jp. All rights reserved.
//

#import "BaseVC.h"


@interface BaseVC ()




@end

@implementation BaseVC



- (void)viewDidLoad {
    [super viewDidLoad];

    [self presentScanAction];
    
    [self settingSideBarMode];
    
    
    
}







#pragma mark -  设置侧边栏
-(void)settingSideBarMode{
    

    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    self.mm_drawerController.closeDrawerGestureModeMask =MMCloseDrawerGestureModeAll;
    self.mm_drawerController.maximumLeftDrawerWidth = ScreenWidth * 0.4;
    [self.mm_drawerController setShouldStretchDrawer:NO];
    
    
    
    
    
    [self settingTabbarBtn];

}









#pragma mark -  侧边栏按钮
-(void)settingTabbarBtn{

    MMDrawerBarButtonItem * leftButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftButton animated:YES];


}

-(void)leftButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES
                                    completion:nil];
    
    
}













#pragma mark -  跳转搜索界面
-(void)presentScanAction{
    
//    [self performSegueWithIdentifier:@"scanSegue" sender:nil];
    
}














@end
