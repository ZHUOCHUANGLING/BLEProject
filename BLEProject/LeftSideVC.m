//
//  LeftSideVC.m
//  BLEProject
//
//  Created by jp on 2016/11/15.
//  Copyright © 2016年 jp. All rights reserved.
//

#import "LeftSideVC.h"
#import "UIViewController+MMDrawerController.h"
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger, ChooseMusicPlayMode) {
    LocalMusicMode,
    TFMusicMode,
    OnlineMusicMode
};

NSString *const ProgramInitializedComplete = @"InitializedComplete";

@interface LeftSideVC ()

@property(nonatomic, strong)NSMutableArray *modualIDArr;
@property (nonatomic, strong)NSMutableArray *modualNameArr;



@property (weak, nonatomic) IBOutlet UILabel *connectedLabel;

@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIButton *speakerImageBtn;

@end

@implementation LeftSideVC
{
    NSInteger selectedRow;
    
    ChooseMusicPlayMode musicMode;

}



-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    
    [self refreshUI];

}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self addObserver];

    [self initUI];
}

-(void)initUI{
    
    self.tableView.rowHeight = ROWHEIGHT;
    
   

    
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.view.frame];
    backgroundView.image = [UIImage imageNamed:@"侧背景"];
    
    self.tableView.backgroundView = backgroundView;
    
    selectedRow = -1;
    

    
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
    

}


-(void)addObserver{

    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    //监听A2DP拔插
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangedCallBack:) name:AVAudioSessionRouteChangeNotification object:nil];
    

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(centralReceiveNotFoundCorrespondMsg:) name:BLENotFoundCorrespondMsgNotification object:nil];
}



-(void)refreshUI{

    self.footerView.frame = CGRectMake(self.footerView.x, self.footerView.y, ScreenWidth,ScreenHeight - 160 - _modualIDArr.count*ROWHEIGHT);
    
    self.connectedLabel.text = DataManager.connectedPeripheral.name;
    
    UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0]];
    selectedCell.selected = YES;
    
    
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
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSInteger currentMusicMode =  [[NSUserDefaults standardUserDefaults] integerForKey:@"ChooseMusicPlayMode"];
    
    
    
    if (indexPath.row != selectedRow || musicMode != currentMusicMode) {
        
        NSString *functionID = _modualIDArr[indexPath.row];
        
        
        //MusicMode
        if ([selectedCell.textLabel.text isEqualToString:@"音乐"]) {
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

        
        if ([selectedCell.textLabel.text isEqualToString:@"音乐"]) {
            

            switch (musicMode) {
                case LocalMusicMode:
                    fVC.navigationBar.topItem.title = @"本地音乐";

                    
                    break;
                    
                case TFMusicMode:
                    fVC.navigationBar.topItem.title = @"TF卡音乐";
                    

                    
                    break;
                    
                case OnlineMusicMode:
                    fVC.navigationBar.topItem.title = @"云音乐";
                    break;
                    
                default:
                    break;
            }


            
        }
        
        
        
        [fVC.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19], NSForegroundColorAttributeName:[UIColor whiteColor]}];
        
        [self settingNavBar:fVC];
        
        
        
        UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0]];
        
        selectedCell.selected = NO;
        
        
        
        selectedRow = indexPath.row;
        
 
        
        [self.mm_drawerController closeDrawerAnimated:YES completion:nil];

    }

}











#pragma mark -  侧边栏按钮
-(void)settingNavBar:(UINavigationController *)nav{
    
    MMDrawerBarButtonItem * leftButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftButtonPress:)];
    leftButton.tintColor = [UIColor whiteColor];
    
    [leftButton setImage:[UIImage imageNamed:@"侧边栏图标"]];
    
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




#pragma mark - A2DP


-(void)audioRouteChangedCallBack:(NSNotification *)notification{
    
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    
    
    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
           
            [self.speakerImageBtn setBackgroundImage:[UIImage imageNamed:@"侧音箱连接状态"] forState: UIControlStateNormal];
            //            NSLog(@"耳机插入");
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:

            [self.speakerImageBtn setBackgroundImage:[UIImage imageNamed:@"侧音箱"] forState: UIControlStateNormal];
            //            NSLog(@"耳机拔出，停止播放操作");
            break;
        case AVAudioSessionRouteChangeReasonCategoryChange:
            // 即将播放监听
//            NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
    
    
}





- (IBAction)presentSetting:(UIButton *)sender {
    
    
    
    if (Deviece_Version >= 10) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{UIApplicationOpenURLOptionUniversalLinksOnly:@NO} completionHandler:nil];
    }else{
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        
    }
    
    
    
}




-(void)centralReceiveNotFoundCorrespondMsg:(NSNotification *)notification{

    if ([notification.userInfo[@"characteristic"] isEqualToString:@"FFF1"]) {
        
        
//        NSData *data =notification.userInfo[@"data"];
//        Byte *bytes = (Byte *)[data bytes];
        
        
        
        Byte bytes[] = {0x00,0x00,0x00,0x00,0x00,0x01,0x00,0x01,0x01,0x01,0x01};
        
        _existFuncArr = [NSMutableArray array];
        
        //music mode
        if (bytes[6] || bytes[7]) {
            [_existFuncArr addObject:@(bytes[6])];
            [_existFuncArr addObject:@(bytes[7])];
        }
        
        
        
        for (NSInteger i=_modualIDArr.count-1 ; i>=0; i--) {
            
            if (!bytes[i+5]) {
                
                
                if (i==0) {
                    
                    [_modualIDArr removeObjectAtIndex:i];
                    [_modualNameArr removeObjectAtIndex:i];
                    
                }else if ((i==2)&&(!bytes[6])){
                    
                    [_modualIDArr removeObjectAtIndex:1];
                    [_modualNameArr removeObjectAtIndex:1];
                    
                }else if (i>2){
                    
                    [_modualIDArr removeObjectAtIndex:i-1];
                    [_modualNameArr removeObjectAtIndex:i-1];
                    
                    
                }
                
                
            }
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            selectedRow = -1;
            [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
            
        });
        
    }
    
    
    
  
    [[NSNotificationCenter defaultCenter] postNotificationName:ProgramInitializedComplete object:nil];
    
}

@end
