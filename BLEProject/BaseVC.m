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
    
    [self addCenterListening];
    
    [self initUI];
    
}


-(void)initUI{

    

    [self settingSideBarMode];
    
    UITableViewController *leftVC = (UITableViewController *)self.mm_drawerController.leftDrawerViewController;
    [leftVC tableView:leftVC.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
//    self.mm_drawerController.centerViewController = [[UIStoryboard storyboardWithName:@"FunctionVC" bundle:nil] instantiateViewControllerWithIdentifier:@"lampVC"];
    
}




#pragma mark -  设置侧边栏
-(void)settingSideBarMode{
    

    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    self.mm_drawerController.closeDrawerGestureModeMask =MMCloseDrawerGestureModeAll;
    self.mm_drawerController.maximumLeftDrawerWidth = ScreenWidth * 0.6;
//    [self.mm_drawerController setShouldStretchDrawer:NO];
    
    
    
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






#pragma mark -  添加监听
-(void)addCenterListening{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CenteralFailConnectPeripher:) name:BLEConnectFailNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CenteralDisconnetPeripheral:) name:BLEPeripheralDisconnectNotification object:nil];
}






#pragma mark -  连接失败
- (void)CenteralFailConnectPeripher:(NSNotification *)FailNote
{
    [self presentScanAction];
}

#pragma mark -  断开连接
- (void)CenteralDisconnetPeripheral:(NSNotification *)disConnectNote
{
    [self presentScanAction];
}






#pragma mark -  跳转搜索界面
-(void)presentScanAction{
    
    [self performSegueWithIdentifier:@"scanSegue" sender:nil];
    
}





@end
