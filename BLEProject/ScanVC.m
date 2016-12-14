//
//  ScanVC.m
//  BLEProject
//
//  Created by jp on 2016/11/12.
//  Copyright © 2016年 jp. All rights reserved.
//

#import "ScanVC.h"
#import "UIView+RotateAnimation.h"

@interface ScanVC ()<UITableViewDelegate,UITableViewDataSource>


#pragma mark - 属性
@property (nonatomic, strong) NSMutableArray <CBPeripheral *> *dataArr;
@property (nonatomic, assign) CBCentralManager *central;

#pragma mark - 视图
@property (weak, nonatomic) IBOutlet UITableView *peripheralList;

@end

@implementation ScanVC

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}








#pragma mark -  监听断开蓝牙事件
+(void)load{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentScanVC) name:BLEPeripheralDisconnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentScanVC) name:BLEConnectFailNotification object:nil];
    
}






- (void)viewDidLoad {
    [super viewDidLoad];

    [DataManager startScan];
    
    [self initUI];
    
    
}


-(void)initUI{
    
    _peripheralList.delegate = self;
    _peripheralList.dataSource = self;
    _peripheralList.layer.cornerRadius = margin;
    //去掉tableview顶部留白
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
    [self centerStartListening];
}









#pragma mark -  开始监听
-(void)centerStartListening{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CenteralUpdateState:) name:BLECentralStateUpdateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CenteralScanedPeripheral:) name:BLEScanedPeripheralNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CenteralSuccessConnnectPeripher:) name:BLEPeripheralConnectSuccedNotification object:nil];

}




#pragma mark -  收到通知回调方法

//状态改变
- (void)CenteralUpdateState:(NSNotification *)StateNote{
    
    CBCentralManager *manager = StateNote.userInfo[@"centralManager"];
    _central = manager;
    
}

//中心设备搜索到外设
- (void)CenteralScanedPeripheral:(NSNotification *)PeripheralNote
{
    
    //遍历单例中保存的外设
    for (CBPeripheral *peripheral in DataManager.searchedPeripheralArr) {
        if (![self.dataArr containsObject:peripheral]) {
            [self.dataArr addObject:peripheral];
            [self resetDataSource];
        }
    }
    
}

//中心设备连接成功
- (void)CenteralSuccessConnnectPeripher:(NSNotification *)SuccessNote
{
    
#warning -----
//    Byte byte[] = {0xff};
//    [DataManager sendDataWithService:@"FFF0" characteristic:@"FFF1" data:[NSData dataWithBytes:byte length:1]];
    
    [self dismissVC];
    NSLog(@"-->与外设连接成功");
}






#pragma mark -  tableView_DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataArr.count;

}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        //设置文字内缩进
        cell.separatorInset = UIEdgeInsetsMake(0, 20, 0, 0);
        //取消cell选中效果
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CBPeripheral *peripheral = self.dataArr[indexPath.row];
    cell.textLabel.text = peripheral.name;
    cell.textLabel.textColor = [UIColor blackColor];
    
}




#pragma mark -  tableView_Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [DataManager disconnectPeripheral];
    
    DataManager.connectedPeripheral = self.dataArr[indexPath.row];
    
    [DataManager connectPeripheral:DataManager.connectedPeripheral];
    
}





#pragma mark -  搜索按钮
- (IBAction)searchBtn:(UIButton *)sender {
    
    [DataManager stopScan];
    [self.dataArr removeAllObjects];
    [self resetDataSource];
    [DataManager startScan];
    
    sender.userInteractionEnabled = NO;
    [sender setImage:[UIImage imageNamed:@"搜索旋转"] forState:UIControlStateNormal];
    [sender setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [sender.imageView rotate360DegreeWithImageView:5];
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [sender.imageView stopRotate];
        [sender setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"搜索"] forState:UIControlStateNormal];
        sender.userInteractionEnabled = YES;
        [DataManager stopScan];
    });
    
}


#pragma mark -  离开当前界面
-(void)dismissVC{
    
    [DataManager stopScan];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark - 更新数据源
- (void)resetDataSource
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.peripheralList reloadData];
    });
}







#pragma mark -  跳转搜索界面
+(void)presentScanVC{
    
    
    UIViewController * scanVC = [[UIStoryboard storyboardWithName:@"FunctionVC" bundle:nil] instantiateViewControllerWithIdentifier:@"scanVC"];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:scanVC animated:YES completion:nil];
    });
    
    
    
    
    
    [self resetTFSongList];
    
    
}


+(void)resetTFSongList{
    
    NSArray *resetArr;
    [[NSUserDefaults standardUserDefaults] setObject:resetArr forKey:@"tfSongListArr"];
    
}


#warning 第一版上架用

- (IBAction)pullDownClick:(UIButton *)sender {
    
    [self dismissVC];
    
    
}






@end
