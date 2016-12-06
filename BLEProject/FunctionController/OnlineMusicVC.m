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

typedef NS_ENUM(NSInteger, ChooseMusicPlayMode) {
    LocalMusicMode,
    TFMusicMode,
    OnlineMusicMode
};

@interface OnlineMusicVC ()<UICollectionViewDelegate,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *chooseModeBGView;

@end

@implementation OnlineMusicVC
{

    ChooseMusicPlayMode currentMusicMode;
    
    NSArray *_musicNameArr;
    NSArray *_urlStringArr;
    
    WebviewVC *webBackVC;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    [self initData];
    
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




#pragma mark -  CollectionView_DataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _musicNameArr.count;
    
    
}



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    OnlineMusicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"onlineMusicCell" forIndexPath:indexPath];
    
    cell.imageView.image = [UIImage imageNamed:_musicNameArr[indexPath.row]];
    cell.titleLab.text =  _musicNameArr[indexPath.row];
    

    return cell;
    
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





- (IBAction)showMusicMode:(UIBarButtonItem *)sender {

    _chooseModeBGView.hidden = _chooseModeBGView.hidden?NO:YES;
    
    
}


- (IBAction)chooseMusicMode:(UIButton *)sender {
    
    currentMusicMode = sender.tag;
    
    switch (currentMusicMode) {
        case LocalMusicMode:
            self.navigationItem.title = @"本地音乐";
            
            break;
            
        case TFMusicMode:{
            self.navigationItem.title = @"TF卡音乐";
            
            
            
            break;
            
        }
            
        case OnlineMusicMode:
            self.navigationItem.title = @"在线音乐";
            
            
            break;
            
        default:
            break;
    }
    
    
    
    
    
    _chooseModeBGView.hidden = YES;
    
    [[NSUserDefaults standardUserDefaults] setInteger:currentMusicMode forKey:@"ChooseMusicPlayMode"];
    
    
    UITableViewController *leftVC = (UITableViewController *)self.mm_drawerController.leftDrawerViewController;
    [leftVC tableView:leftVC.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
    
    
}











@end
