//
//  OnlineMusicVC.m
//  BLEProject
//
//  Created by jp on 2016/11/29.
//  Copyright © 2016年 jp. All rights reserved.
//





#import "OnlineMusicVC.h"
#import "UIViewController+MMDrawerController.h"
#import "OnlineMusicCell.h"
#import "WebviewVC.h"



#define RowHeight ScreenHeight*0.07

typedef NS_ENUM(NSInteger, ChooseMusicPlayMode) {
    LocalMusicMode,
    TFMusicMode,
    OnlineMusicMode
};

@interface OnlineMusicVC ()<UICollectionViewDelegate,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *chooseModeTableView;

@end

@implementation OnlineMusicVC
{

    ChooseMusicPlayMode currentMusicMode;
    
    NSArray *_musicNameArr;
    NSArray *_urlStringArr;
    
    WebviewVC *webBackVC;
    
    //chooseModeTableView
    NSMutableArray *_chooseModeTableViewArr;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    [self initData];
    [self initTableView];
    [self initUI];
    
}




-(void)initData{
    
    _musicNameArr = [NSArray arrayWithObjects:
                     @"QQ音乐",
                     @"百度音乐",
                     @"喜马拉雅",
                     @"酷狗音乐",
                     @"电台",
                     @"幼儿早教",
                     nil];
    
    
    _urlStringArr = [NSArray arrayWithObjects:
                     @"https://y.qq.com",
                     @"http://music.baidu.com",
                     @"http://www.ximalaya.com/explore/",
                     @"http://www.kugou.com",
                     @"http://m.lizhi.fm",
                     @"http://m.ximalaya.com/album-tag/kid",
                     nil];

}

-(void)initUI{
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem  = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

}




#pragma mark -  CollectionView_DataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _musicNameArr.count;
    
    
}



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    OnlineMusicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"onlineMusicCell" forIndexPath:indexPath];
    
    if (ScreenWidth == 320) {
        cell.width = 120;
        cell.height = 150;
    }
    
    
    cell.imageView.image = [UIImage imageNamed:_musicNameArr[indexPath.row]];
    cell.titleLab.text =  _musicNameArr[indexPath.row];
    
    
    return cell;
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (ScreenWidth == 414) {
        return CGSizeMake(150, 180);
    }
    return CGSizeMake(120, 150);
}





#pragma mark -  CollectionView_Delegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    webBackVC.urlString = _urlStringArr[indexPath.row];
    
}




-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"webViewSegue"]) {
        
        webBackVC = (WebviewVC *)segue.destinationViewController;
    }


}










#pragma mark -  ChooseModeTableView

-(void)initTableView{
    
    _chooseModeTableViewArr = [NSMutableArray arrayWithObjects:@"本地音乐",@"TF卡音乐",@"云音乐", nil];
    _chooseModeTableView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth * 0.6, 70, ScreenWidth*0.39, RowHeight * _chooseModeTableViewArr.count+10)];
    _chooseModeTableView.delegate = self;
    _chooseModeTableView.dataSource = self;
    _chooseModeTableView.rowHeight = RowHeight;
    _chooseModeTableView.backgroundColor = [UIColor clearColor];
    _chooseModeTableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"下拉菜单底背景"]];
    _chooseModeTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _chooseModeTableView.width, 10)];
    _chooseModeTableView.scrollEnabled = NO;
    _chooseModeTableView.hidden = YES;
    [_chooseModeTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    [_chooseModeTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    
    [self.view addSubview:_chooseModeTableView];
    
    
}


- (IBAction)showMusicMode:(UIBarButtonItem *)sender {
    
    _chooseModeTableView.hidden = _chooseModeTableView.hidden?NO:YES;
    
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  _chooseModeTableViewArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [_chooseModeTableView dequeueReusableCellWithIdentifier:@"musicCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"musicCell"];
        cell.backgroundColor = [UIColor clearColor];
        
    }
    
    
    
    return cell;
    
    
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell.textLabel.text = _chooseModeTableViewArr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    if (ScreenWidth == 320) {
        cell.textLabel.font = [UIFont systemFontOfSize:11.5];
    }
    cell.imageView.image = [UIImage imageNamed:_chooseModeTableViewArr[indexPath.row]];
    
    
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSString *selectedStr = selectedCell.textLabel.text;
    
    if ([selectedStr isEqualToString:@"本地音乐"]) {
        currentMusicMode = LocalMusicMode;
        
    }else if([selectedStr isEqualToString:@"TF卡音乐"]){
        currentMusicMode = TFMusicMode;
        
    }else if([selectedStr isEqualToString:@"云音乐"]){
        currentMusicMode = OnlineMusicMode;
    }
    
    
    
    
    _chooseModeTableView.hidden = YES;
    
    
    [[NSUserDefaults standardUserDefaults] setInteger:currentMusicMode forKey:@"ChooseMusicPlayMode"];
    
    
    UITableViewController *leftVC = (UITableViewController *)self.mm_drawerController.leftDrawerViewController;
    [leftVC tableView:leftVC.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
    
    
}








@end
