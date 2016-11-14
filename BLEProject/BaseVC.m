//
//  BaseVC.m
//  BLEProject
//
//  Created by jp on 2016/11/14.
//  Copyright © 2016年 jp. All rights reserved.
//

#import "BaseVC.h"
#import "MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"

@interface BaseVC ()

@end

@implementation BaseVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self presentScanAction];
    
    [self settingSideBarMode];
    
    
//    MMDrawerBarButtonItem * leftButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftButtonPress:)];
//    [self.navigationItem setLeftBarButtonItem:leftButton animated:YES];
}



//-(void)leftButtonPress:(id)sender{
//    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES
//                                    completion:nil];
//    
//    
//}



#pragma mark -  设置侧边栏
-(void)settingSideBarMode{
    

    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    self.mm_drawerController.closeDrawerGestureModeMask =MMCloseDrawerGestureModeAll;
    self.mm_drawerController.maximumLeftDrawerWidth = 200.0;
    


}














#pragma mark -  跳转搜索界面
-(void)presentScanAction{
    
    [self performSegueWithIdentifier:@"scanSegue" sender:nil];
    
}














@end
