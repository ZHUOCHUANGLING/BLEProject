//
//  MusicListVC.m
//  BLEProject
//
//  Created by jp on 2016/11/17.
//  Copyright © 2016年 jp. All rights reserved.
//

#import "MusicListVC.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MusicListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *songListTableView;

@property (nonatomic, strong) MPMusicPlayerController *playerController;

@property (weak, nonatomic) IBOutlet UIView *touchView;

@end

@implementation MusicListVC
{
    NSArray *_mediaItems;
    BOOL hasMusic;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initMusicState];

}


-(void)initMusicState{

    
    [self.touchView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissVC)]];
    
    [self initController];
    [self loadMediaItems];
    

}


-(void)initController{

    _playerController = [MPMusicPlayerController applicationMusicPlayer];

}


-(void)loadMediaItems{

    MPMediaQuery *query = [MPMediaQuery songsQuery];
    _mediaItems = [query items];
    hasMusic = [self hasMusic];

}

-(BOOL)hasMusic{
    
    if (_mediaItems.count == 0) {
        
        [SVProgressHUD showInfoWithStatus:@"没有本地歌曲"];
        return NO;
    }
    
    return YES;
}




#pragma mark -  tableView_DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    
    return _mediaItems.count;
    
    


}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor clearColor];
        
        
        
        
        cell.selectedBackgroundView = [UIView new];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:26.f/255.f green:161.f/255.f blue:230.f/255.f alpha:1];
        cell.textLabel.highlightedTextColor = [UIColor whiteColor];
        cell.detailTextLabel.highlightedTextColor = [UIColor whiteColor];
    }
    
    
    
    
    return cell;

}


#pragma mark -  tableView_Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    
    
        MPMediaItem *item = _mediaItems[indexPath.row];
        cell.textLabel.text = item.title;
        cell.detailTextLabel.text = item.artist;
        
        if ([cell.textLabel.text isEqualToString:_playerController.nowPlayingItem.title]) {
            cell.selected = YES;
        }
    
    
    
    

    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    _playerController.nowPlayingItem = _mediaItems[indexPath.row];
    
    
    [tableView reloadData];
    
    
}



-(void)dismissVC{


    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
  

}





@end
