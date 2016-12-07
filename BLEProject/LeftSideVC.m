//
//  LeftSideVC.m
//  BLEProject
//
//  Created by jp on 2016/11/15.
//  Copyright © 2016年 jp. All rights reserved.
//

#import "LeftSideVC.h"
#import "UIViewController+MMDrawerController.h"

typedef NS_ENUM(NSInteger, ChooseMusicPlayMode) {
    LocalMusicMode,
    TFMusicMode,
    OnlineMusicMode
};



@interface LeftSideVC ()

@property(nonatomic, strong)NSMutableArray *modualIDArr;

@property (nonatomic, strong)NSMutableArray *modualNameArr;
@property (weak, nonatomic) IBOutlet UILabel *connectedLabel;

@property (weak, nonatomic) IBOutlet UIView *footerView;

@end

@implementation LeftSideVC
{
    NSInteger selectedRow;
    
    ChooseMusicPlayMode musicMode;

}



-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    
    
    UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0]];
    
    selectedCell.selected = YES;
  
    
    
    self.connectedLabel.text = DataManager.connectedPeripheral.name;
    

}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initData];
    
    
    
}

-(void)initUI{
    
    self.tableView.rowHeight = ROWHEIGHT;
    
    
    self.footerView.frame = CGRectMake(0, 0, ScreenWidth,ScreenHeight - 160 - 6*ROWHEIGHT);


    
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.view.frame];
    backgroundView.image = [UIImage imageNamed:@"侧背景"];
    
    self.tableView.backgroundView = backgroundView;
    

 

}

-(void)initData{
    
    selectedRow = -1;
    
    
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

}






#pragma mark -  tableView_Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _modualIDArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    cell.textLabel.text = _modualNameArr[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.imageView.image = [UIImage imageNamed:_modualNameArr[indexPath.row]];
    
    
    
    cell.selectedBackgroundView = [UIView new];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:40.f/255.f green:60.f/255.f blue:111.f/255.f alpha:1];
    
    
    
    return cell;
    
    
}



#pragma mark -  tableView_Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSInteger currentMusicMode =  [[NSUserDefaults standardUserDefaults] integerForKey:@"ChooseMusicPlayMode"];
    
    if (indexPath.row != selectedRow || musicMode != currentMusicMode) {
        NSString *functionID = _modualIDArr[indexPath.row];
        
        
        //MusicMode
        if (indexPath.row == 1) {
            musicMode = currentMusicMode;
            
            
            switch (musicMode) {
                case LocalMusicMode:
                    functionID = @"musicVC";
                    break;
                    
                case TFMusicMode:
                    functionID = @"musicVC";
                    break;
                    
                case OnlineMusicMode:
                    functionID = @"OnlineMusicVC";
                    break;
                    
                default:
                    break;
            }
            
        }
        
        
        
        UINavigationController * fVC = [[UIStoryboard storyboardWithName:@"FunctionVC" bundle:nil] instantiateViewControllerWithIdentifier:functionID];
        
        self.mm_drawerController.centerViewController = fVC;

        
        
        fVC.navigationBar.topItem.title = _modualNameArr[indexPath.row];
        
        if (indexPath.row == 1) {
            

            switch (musicMode) {
                case LocalMusicMode:
                    fVC.navigationBar.topItem.title = @"本地音乐";

                    
                    break;
                    
                case TFMusicMode:
                    fVC.navigationBar.topItem.title = @"TF卡音乐";
                    

                    
                    break;
                    
                case OnlineMusicMode:
                    fVC.navigationBar.topItem.title = @"在线音乐";
                    break;
                    
                default:
                    break;
            }


            
        }
        
        
        
        [fVC.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18], NSForegroundColorAttributeName:[UIColor whiteColor]}];
        

        [self settingNavBar:fVC];
        
        
        
        UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0]];
        
        selectedCell.selected = NO;
        
        
        
        selectedRow = indexPath.row;
        
 
        
        [self.mm_drawerController closeDrawerAnimated:YES completion:nil];

    }

}




- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

  
}








#pragma mark -  侧边栏按钮
-(void)settingNavBar:(UINavigationController *)nav{
    
    MMDrawerBarButtonItem * leftButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftButtonPress:)];
    leftButton.tintColor = [UIColor whiteColor];
    [nav.navigationBar.topItem setLeftBarButtonItem:leftButton animated:YES];
    
}

-(void)leftButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES
                                    completion:nil];
    
    
}






#pragma mark -  DisConnectDevice


- (IBAction)disConnectDevice:(UIButton *)sender {
    
    [DataManager disconnectPeripheral];
    
    
#warning 第一版上架用
    UIViewController * scanVC = [[UIStoryboard storyboardWithName:@"FunctionVC" bundle:nil] instantiateViewControllerWithIdentifier:@"scanVC"];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:scanVC animated:YES completion:nil];
    });
    
}






#pragma mark -  connectA2DP




- (IBAction)presentSetting:(UIButton *)sender {
    
    
    
    if (Deviece_Version >= 10) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{UIApplicationOpenURLOptionUniversalLinksOnly:@NO} completionHandler:nil];
    }else{
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        
    }
    
    
    
}



@end
