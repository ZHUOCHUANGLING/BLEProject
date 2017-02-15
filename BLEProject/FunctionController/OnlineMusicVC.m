//
//  OnlineMusicVC.m
//  BLEProject
//
//  Created by jp on 2016/11/29.
//  Copyright © 2016年 jp. All rights reserved.
//





#import "OnlineMusicVC.h"
#import "OnlineMusicCell.h"
#import "WebviewVC.h"

#import "MusicTabbarVC.h"
#import "MusicFunctionManger.h"
#import "UILabel+Extension.h"


#define RowHeight ScreenHeight*0.07


@interface OnlineMusicVC ()<UICollectionViewDelegate,UICollectionViewDelegate,MusicTabbarVCDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *onlineCollectionView;


@end

@implementation OnlineMusicVC
{

    NSArray *_musicNameArr;
    NSArray *_urlStringArr;
    
    WebviewVC *webBackVC;
    

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    [self initData];
    [self initUI];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self synchronizeState];
    
    
    [self recoverNavigationBar];
}


-(void)recoverNavigationBar{

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"顶背景"] forBarMetrics:UIBarMetricsDefault];
    
}



-(void)synchronizeState{
    
    [shareMusicOperation() setDeviceSource:DeviceSourceBluetooth];
    
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
    
    
    if (Device_IsPhone) {
        
    }else{
        //标题颜色和字体
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:25],NSForegroundColorAttributeName:[UIColor whiteColor]}];
        
    }

    
//    self.navigationItem.backBarButtonItem  = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

}




#pragma mark -  CollectionView_DataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _musicNameArr.count;
    
    
}



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    OnlineMusicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"onlineMusicCell" forIndexPath:indexPath];
    
    if (Device_IsPhone) {
        cell.width = ScreenWidth/3.5;
        cell.height = ScreenHeight/4.5;
        
    }else{
        
        cell.width =ScreenWidth/5;
        cell.height =ScreenHeight/4;
        [cell.titleLab adjustFontSizeWithSize:17];
    }
    
    
    cell.imageView.image = [UIImage imageNamed:_musicNameArr[indexPath.row]];
    cell.titleLab.text =  _musicNameArr[indexPath.row];
    
    
    return cell;
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (ScreenWidth == 414) {
    //        return CGSizeMake(150, 180);
    //    }
    //    return CGSizeMake(120, 150);
    
    
    if (Device_IsPhone) {
        
        
    }else{
        
        return CGSizeMake(ScreenWidth/3.5,ScreenHeight/4.5);
        
    }
    
    return CGSizeMake(ScreenWidth/4, ScreenHeight/3.5);
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


//上左下右边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    if (Device_IsPhone) {
        
        
        
//        return UIEdgeInsetsMake(30, 50, 150, 80);
    }else{
        return UIEdgeInsetsMake(135, 150, 0, 80);
    }
    
    return UIEdgeInsetsMake(ScreenHeight/20, ScreenWidth/8, ScreenWidth/10, ScreenWidth/5.4);
    
}



#pragma mark -  MusicTabbarVC_Delegate
-(void)pausePlayingMusic{
    webBackVC.urlString = @"about:blank";
    
}



- (IBAction)hiddenAllSuspensionView:(UITapGestureRecognizer *)sender {
    MusicTabbarVC *superVC = (MusicTabbarVC *)self.tabBarController;
    superVC.chooseModeTableView.hidden = YES;
}



@end

