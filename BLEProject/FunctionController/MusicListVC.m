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

@property (nonatomic, copy) NSMutableArray *tfSongListArr;



@property (weak, nonatomic) IBOutlet UIView *touchView;

@end

@implementation MusicListVC
{
    NSArray *_mediaItems;
    BOOL hasMusic;
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self initMusicState];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.touchView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissVC)]];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSUserDefaults standardUserDefaults] setObject:_tfSongListArr forKey:@"tfSongListArr"];
    
}


-(void)initMusicState{

    if (self.musicMode == LocalMusicMode) {
        
        
        [self initController];
        [self loadMediaItems];
    }
    
    
    if (self.musicMode == TFMusicMode) {

        [self initTFMusicState];
    }
    
    
    
    


}






-(void)initTFMusicState{

    
    NSArray *tfSessionArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"tfSongListArr"];
    if (tfSessionArr) {
        _tfSongListArr = [NSMutableArray arrayWithArray:tfSessionArr];
    }else{
        _tfSongListArr = [[NSMutableArray alloc] init];
    }

    
    
    
    [self.musicOperation getSongList];
    
    __weak typeof(self) weakSelf = self;

    
    self.musicOperation.listSongName = ^(NSString *songListName){
        
        
        
        [weakSelf.tfSongListArr addObject:songListName];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.songListTableView reloadData];
        });
        
        
        
        
    };
    
    
    
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
    
    
    if (self.musicMode == LocalMusicMode) {
        return _mediaItems.count;
    }
    
    if (self.musicMode == TFMusicMode) {
        return _tfSongListArr.count;
    }
    
    return 0;

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

    
    if (self.musicMode == LocalMusicMode) {
        MPMediaItem *item = _mediaItems[indexPath.row];
        cell.textLabel.text = item.title;
        cell.detailTextLabel.text = item.artist;
        
        if ([cell.textLabel.text isEqualToString:_playerController.nowPlayingItem.title]) {
            cell.selected = YES;
        }
    }
    
    
    
    if (self.musicMode == TFMusicMode) {
        
        cell.textLabel.text = _tfSongListArr[indexPath.row];
        
        if (indexPath.row == self.currentIndex-1) {
            
            cell.selected = YES;
        }
        else {
            cell.selected = NO;
        }
    }
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    
    if (self.musicMode == LocalMusicMode) {
        _playerController.nowPlayingItem = _mediaItems[indexPath.row];
    }
    
    
    if (self.musicMode == TFMusicMode) {
        
        self.currentIndex = indexPath.row+1;
        
        [self.musicOperation setPlaySongIndex:indexPath.row+1];
    }
    
    
    
    [tableView reloadData];
    
    
}



-(void)dismissVC{

    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });


}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y>=scrollView.contentSize.height-CGRectGetHeight(scrollView.frame)) {
        
        [self.musicOperation getSongList];
    }
}


















@end
