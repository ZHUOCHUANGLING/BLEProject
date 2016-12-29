//
//  OnlineMusicVC.m
//  BLEProject
//
//  Created by jp on 2016/11/29.
//  Copyright © 2016年 jp. All rights reserved.
//





#import "OnlineMusicVC.h"
//#import "UIViewController+MMDrawerController.h"
#import "OnlineMusicCell.h"
#import "WebviewVC.h"
//#import "LeftSideVC.h"


#define RowHeight ScreenHeight*0.07


@interface OnlineMusicVC ()<UICollectionViewDelegate,UICollectionViewDelegate>



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
    
    
//    self.navigationItem.backBarButtonItem  = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

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










@end
