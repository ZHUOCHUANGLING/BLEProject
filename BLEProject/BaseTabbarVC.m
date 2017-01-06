//
//  BaseTabbarVC.m
//  BLEProject
//
//  Created by jp on 2016/12/22.
//  Copyright © 2016年 jp. All rights reserved.
//

#import "BaseTabbarVC.h"
#import "UIViewController+MMDrawerController.h"
#import "ScanVC.h"
#import "FunctionDataManager.h"


//NSString *const MusicFunctionArr = @"MusicFunctionArray";

@interface BaseTabbarVC ()

@property(nonatomic, strong)NSMutableArray *modualIDArr;
@property (nonatomic, strong)NSMutableArray *modualNameArr;

@end

@implementation BaseTabbarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [ScanVC presentScanVC];
    
    
    [self initFunction];
    [self settingSideBarMode];
    
    [self initData];
    [self addViewControllers];
    [self settingMoreNavigationController];
    
    [self registerLocalNotification];
    
    
    [self addObserver];
}






-(void)initData{
    
    
    _modualIDArr = [NSMutableArray arrayWithObjects:
                    @"lampVC",
                    @"musicVC",
                    @"fmVC",
                    @"auxVC",
                    @"timingVC",
                    @"settingVC", nil];
    
    _modualNameArr = [NSMutableArray arrayWithObjects:
                      @"彩灯",
                      @"音乐",
                      @"收音机",
                      @"AUX",
                      @"定时",
                      @"设置", nil];
    
    self.selectedIndex = 0;
    
}





-(void)addViewControllers{
    
    NSMutableArray *viewControllers = [NSMutableArray array];
    
    for (NSInteger i=0;i<_modualIDArr.count;i++) {
        
        NSString *functionID = _modualIDArr[i];
        
        UINavigationController * fVC = [[UIStoryboard storyboardWithName:@"FunctionVC" bundle:nil] instantiateViewControllerWithIdentifier:functionID];
        
        fVC.navigationBar.topItem.title = _modualNameArr[i];
        
     
        [self settingNavBar:fVC];
        
        [viewControllers addObject:fVC];
        
        
    }
    
    [self setViewControllers:viewControllers];
    
}



-(void)addObserver{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTabbarModualData:) name:DataInitializedCompleted object:nil];
}


#pragma mark -  设置侧边栏
-(void)settingSideBarMode{
    

    self.mm_drawerController.maximumLeftDrawerWidth = Device_IsPhone ? ScreenWidth * 0.7 : ScreenWidth * 0.6;
    
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeBezelPanningCenterView;
    self.mm_drawerController.closeDrawerGestureModeMask =MMCloseDrawerGestureModeAll;
    
    
}




#pragma mark -  侧边栏按钮
-(void)settingNavBar:(UINavigationController *)nav{

    
    MMDrawerBarButtonItem * leftButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftButtonPress:)];
    leftButton.tintColor = [UIColor whiteColor];
    
    [leftButton setImage:[UIImage imageNamed:@"侧边栏图标"]];
    
    [nav.navigationBar.topItem setLeftBarButtonItem:leftButton animated:YES];
    [nav.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
}

-(void)leftButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES
                                    completion:nil];
    
    
}


-(void)settingMoreNavigationController{
    
    self.moreNavigationController.interactivePopGestureRecognizer.enabled = NO;
    self.moreNavigationController.navigationItem.hidesBackButton = YES;
    self.moreNavigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:19], NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.moreNavigationController.navigationBar.barTintColor = [UIColor colorWithRed:26/255.f green:161/255.f blue:230/255.f alpha:1];
    
}




-(void)registerLocalNotification{
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
    
}





-(void)initFunction{
    
    //让app支持接受远程控制事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isFirstMusicFunctionLaunch"];
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isFirstSendCustomFunction"];
    
}



-(void)setSelectedIndex:(NSUInteger)selectedIndex{
    [super setSelectedIndex:selectedIndex];
    self.tabBar.hidden = YES;
    
    
}




-(void)reloadTabbarModualData:(NSNotification *)notification{

    NSDictionary *modualArrDic = notification.userInfo;
    
    
    
    [_modualIDArr removeAllObjects];
    [_modualNameArr removeAllObjects];
    
    [_modualIDArr addObjectsFromArray: modualArrDic[@"modualIDArr"]];
    [_modualNameArr addObjectsFromArray: modualArrDic[@"modualNameArr"]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self filterTabbarViewControllers];
    });
    
}






-(void)filterTabbarViewControllers{
    
    NSMutableArray *viewControllers =[NSMutableArray arrayWithArray:self.viewControllers];
    
    NSEnumerator *reverseArrayEnum = [viewControllers reverseObjectEnumerator];
    
    for (UINavigationController *modualNav in reverseArrayEnum) {
        

        NSString *modualName = modualNav.navigationBar.topItem.title;
        
        if ([modualName containsString:@"音乐"]) {
            modualName = @"音乐";
        }
        
        if (![_modualNameArr containsObject:modualName]) {
            
            
            
            [viewControllers removeObject:modualNav];
            
        };
    }
    
    
    
    dispatch_main_async_safe(^{
        [self setViewControllers:viewControllers];
    });
    

}






@end
