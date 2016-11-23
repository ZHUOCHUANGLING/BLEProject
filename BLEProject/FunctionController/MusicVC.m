//
//  MusicVC.m
//  BLEProject
//
//  Created by jp on 2016/11/16.
//  Copyright © 2016年 jp. All rights reserved.
//

#import "MusicVC.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>


typedef NS_ENUM(NSInteger, MusicMode) {
    MusicRepeatModeDefault,
    MusicRepeatModeOne,
    MusicShuffleModeSongs
};






@interface MusicVC ()<AVAudioPlayerDelegate>

@property (nonatomic, strong) MPMusicPlayerController *playerController;



@property (weak, nonatomic) IBOutlet UILabel *musicNameLabel;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;

@property (weak, nonatomic) IBOutlet UIView *musicVolumeBG;

@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;

@end

@implementation MusicVC
{
    NSArray *_mediaItems;
    NSInteger sessionMusicCount;
    
    BOOL hasMusic;
    NSTimeInterval currentTime;
    NSTimeInterval totalTime;
    MusicMode currentMode;
    
    
    NSTimer *_progressTimer;
    
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    [self loadMediaItems];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    _mediaItems = [NSArray array];
    
    [self initMusicPlayerController];
    

    [self addObserver];
    
    [self initUI];
    
    
}



-(void)loadMediaItems{
    
    
    
        MPMediaQuery *query = [MPMediaQuery songsQuery];
        _mediaItems = [query items];
        
        hasMusic = [self hasMusic];
    
    
        //导入歌曲列表
        if (hasMusic && sessionMusicCount != _mediaItems.count) {
            [_playerController setQueueWithItemCollection:[[MPMediaItemCollection alloc] initWithItems:[_mediaItems copy]]];
            sessionMusicCount = _mediaItems.count;
        }
    


}

-(BOOL)hasMusic{

    if (_mediaItems.count == 0) {
 
        [SVProgressHUD showInfoWithStatus:@"没有本地歌曲"];
        return NO;
    }
    
    return YES;
}




-(void)initMusicPlayerController{
    
    _playerController = [MPMusicPlayerController systemMusicPlayer];
    [_playerController beginGeneratingPlaybackNotifications];
    
    
    
    //initMusicMode
    _playerController.repeatMode = MPMusicRepeatModeAll;
    
    
    if (_progressTimer) {
        [_progressTimer invalidate];
    }
    _progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];


}



-(void)initUI{
    
    MPVolumeView *volumeSlide = [[MPVolumeView alloc] initWithFrame:_musicVolumeBG.bounds];
    volumeSlide.showsRouteButton = NO;
    [_musicVolumeBG addSubview:volumeSlide];
    [volumeSlide sizeToFit];
    
    

}




-(void)settingMusicMode:(MusicMode)musicMode{

    switch (musicMode) {
        case MusicRepeatModeDefault:
            _playerController.repeatMode = MPMusicRepeatModeAll;
            _playerController.shuffleMode = MPMusicRepeatModeNone;

            
            [SVProgressHUD showSuccessWithStatus:@"列表循环播放"];
            break;
            
        case MusicRepeatModeOne:
            _playerController.repeatMode = MPMusicRepeatModeOne;
            _playerController.shuffleMode = MPMusicRepeatModeNone;
            
            [SVProgressHUD showSuccessWithStatus:@"单曲播放"];
            
            
            break;
            
        case MusicShuffleModeSongs:
            _playerController.repeatMode = MPMusicRepeatModeAll;
            _playerController.shuffleMode = MPMusicShuffleModeSongs;

            [SVProgressHUD showSuccessWithStatus:@"随机播放"];
            break;
            
            
        default:
            break;
    }
    

}


-(void)addObserver{

    
    //BLE Notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didConnectFailedPeripheralNotification:) name:BLEPeripheralDisconnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didConnectFailedPeripheralNotification:) name:BLEConnectFailNotification object:nil];
    
    
    
    
    //playerController Notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MPMusicPlayerControllerStateDidChangeNotification:) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MPMusicPlayerControllerNowPlayingItemDidChangeNotification:) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MPMusicPlayerControllerVolumeDidChangeNotification:) name:MPMusicPlayerControllerVolumeDidChangeNotification object:nil];

}






- (IBAction)prev:(UIButton *)sender {
    
    if (_playerController) {
        
        [_playerController skipToPreviousItem];
     
        
        
    }
    
    
}



- (IBAction)play:(UIButton *)sender {
    
    if(_playerController){

    
        if (self.playerController.playbackState != MPMusicPlaybackStatePlaying) {
            
            [_playerController play];
            
        }else{
        
            [_playerController pause];
        
        }
    
    
    
    }

}



- (IBAction)next:(id)sender {
    
    
    if (_playerController) {
    
        [_playerController skipToNextItem];
    
        
    }

}














#pragma mark -  选择模式
- (IBAction)chooseMode:(UIButton *)sender {
    
    currentMode = currentMode<2?++currentMode:0;
    
    [self settingMusicMode:currentMode];
    

}


- (IBAction)chooseTFOrLocalMode:(UIBarButtonItem *)sender {
    
}



- (IBAction)musicProgressBarEvent:(UISlider *)sender {
    
    
    [_playerController setCurrentPlaybackTime:_progressSlider.value * _playerController.nowPlayingItem.playbackDuration];
    

    
}



- (IBAction)showVolumeSlide:(UIButton *)sender {
    
    
    _musicVolumeBG.hidden = _musicVolumeBG.isHidden ? NO : YES ;
    
}









#pragma mark -  MPMusicPlayerController NotificationMethod

-(void)MPMusicPlayerControllerStateDidChangeNotification:(NSNotification *)notification{

    if (_playerController.playbackState == MPMoviePlaybackStatePlaying) {
        
        
      

        
    }
    
    

}



-(void)MPMusicPlayerControllerNowPlayingItemDidChangeNotification:(NSNotification *)notification{

    
    

    
    self.musicNameLabel.text = [NSString stringWithFormat:@"%@-%@",_playerController.nowPlayingItem.title,_playerController.nowPlayingItem.artist];
    
    self.totalTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",((NSInteger)_playerController.nowPlayingItem.playbackDuration / 60) ,((NSInteger)_playerController.nowPlayingItem.playbackDuration % 60)];

    
}



-(void)MPMusicPlayerControllerVolumeDidChangeNotification:(NSNotification *)notification{


}






-(void)updateProgress{


    self.currentTimeLabel.text = [NSString stringWithTimeInteral:self.playerController.currentPlaybackTime];
    _progressSlider.value = _playerController.currentPlaybackTime/_playerController.nowPlayingItem.playbackDuration;
    

}




#pragma mark -  BLE NotificationMethod
- (void)didConnectFailedPeripheralNotification:(NSNotification*)notification{
    
    
    
    
}





-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    


}











@end
