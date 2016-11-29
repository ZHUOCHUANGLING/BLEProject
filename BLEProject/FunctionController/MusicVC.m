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


typedef NS_ENUM(NSInteger, ChooseMusicPlayMode) {
    LocalMusicMode,
    TFMusicMode
};





@interface MusicVC ()<AVAudioPlayerDelegate>

@property (nonatomic, strong) MPMusicPlayerController *playerController;



@property (weak, nonatomic) IBOutlet UILabel *musicNameLabel;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;


@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;


@property (weak, nonatomic) IBOutlet UIButton *playOrPauseButton;
@property (weak, nonatomic) IBOutlet UIButton *selectModeButton;


@property (weak, nonatomic) IBOutlet UIView *volumeBackgroudView;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;






@property (weak, nonatomic) IBOutlet UIView *chooseModeBGView;





@end

@implementation MusicVC
{
    NSArray *_mediaItems;
    NSInteger sessionMusicCount;
    
    BOOL hasMusic;
    NSTimeInterval currentTime;
    NSTimeInterval totalTime;
    MusicMode currentMode;
    ChooseMusicPlayMode currentMusicMode;
    
    NSTimer *_progressTimer;
    
}














-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    [self loadMediaItems];
    [self initUI];
    [self addObserver];
    
    
    
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _mediaItems = [NSArray array];
    
    [self initMusicPlayerController];
    
    

}





-(void)loadMediaItems{
    

        MPMediaQuery *query = [MPMediaQuery songsQuery];
        _mediaItems = [query items];
        
        hasMusic = [self hasMusic];
    
        sessionMusicCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"sessionMusicCount"];
        //导入歌曲列表
        if ((hasMusic && sessionMusicCount != _mediaItems.count )|| [self isFirstLaunch]) {
            [_playerController setQueueWithItemCollection:[[MPMediaItemCollection alloc] initWithItems:[_mediaItems copy]]];
            sessionMusicCount = _mediaItems.count;
            [[NSUserDefaults standardUserDefaults] setInteger:sessionMusicCount forKey:@"sessionMusicCount"];
        }
    


}



-(BOOL)hasMusic{

    if (_mediaItems.count == 0) {
 
        [SVProgressHUD showInfoWithStatus:@"没有本地歌曲"];
        return NO;
    }
    
    return YES;
}

-(BOOL)isFirstLaunch{

    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstLaunch"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstLaunch"];
        
        return  YES;
    }

    return NO;

}


-(void)initMusicPlayerController{
    
    
    _playerController = [MPMusicPlayerController applicationMusicPlayer];
    [_playerController beginGeneratingPlaybackNotifications];
    
    
    
 
    if (_progressTimer) {
        [_progressTimer invalidate];
    }
    _progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];

    
    
    
    
}


-(void)initUI{
    
    _volumeSlider.value = _playerController.volume;

    
    if(_playerController.nowPlayingItem.title){
        self.musicNameLabel.text = [NSString stringWithFormat:@"%@-%@",_playerController.nowPlayingItem.title,_playerController.nowPlayingItem.artist];
    }
    
 
    
    if (self.playerController.playbackState == MPMusicPlaybackStatePlaying) {
        
        [_playOrPauseButton setBackgroundImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
    }
    
    
    
    
    //设置当前播放模式
    currentMode = [[NSUserDefaults standardUserDefaults] integerForKey:@"musicMode"];
    
    if (currentMode) {
        [self setMusicModeProperty:currentMode];
    }else{
        [self setMusicModeProperty:MusicRepeatModeDefault];

    }
    
    
    
}


-(void)settingMusicMode:(MusicMode)musicMode{

    switch (musicMode) {
        case MusicRepeatModeDefault:
            [self setMusicModeProperty:MusicRepeatModeDefault];
            
            [SVProgressHUD showSuccessWithStatus:@"列表循环播放"];
            break;
            
        case MusicRepeatModeOne:
            [self setMusicModeProperty:MusicRepeatModeOne];
            
            [SVProgressHUD showSuccessWithStatus:@"单曲播放"];
            break;
            
        case MusicShuffleModeSongs:
            [self setMusicModeProperty:MusicShuffleModeSongs];
            
            [SVProgressHUD showSuccessWithStatus:@"随机播放"];
            break;
            
            
        default:
            break;
    }
    
   
    [[NSUserDefaults standardUserDefaults] setInteger:musicMode forKey:@"musicMode"];
    

}





-(void)setMusicModeProperty:(MusicMode)musicMode{

    switch (musicMode) {
        case MusicRepeatModeDefault:
            _playerController.repeatMode = MPMusicRepeatModeAll;
            _playerController.shuffleMode = MPMusicShuffleModeOff;
            
            
            [_selectModeButton setImage:[UIImage imageNamed:@"顺序"] forState:UIControlStateNormal];
            
            break;
            
        case MusicRepeatModeOne:
            _playerController.repeatMode = MPMusicRepeatModeOne;
            _playerController.shuffleMode = MPMusicShuffleModeOff;
            
            
            [_selectModeButton setImage:[UIImage imageNamed:@"单曲循环"] forState:UIControlStateNormal];
            
            break;
            
        case MusicShuffleModeSongs:
            _playerController.repeatMode = MPMusicRepeatModeAll;
            _playerController.shuffleMode = MPMusicShuffleModeSongs;
            
            [_selectModeButton setImage:[UIImage imageNamed:@"随机"] forState:UIControlStateNormal];
            
            break;
            
            
        default:
            break;
    }



}





-(void)addObserver{
    

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
    
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        if(_playerController){

            if (self.playerController.playbackState != MPMusicPlaybackStatePlaying) {
                
                [_playerController play];
                
            }else{
                
                [_playerController pause];
                
            }
            
        }
        
        
        
        
    });
    
    

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
    
    _chooseModeBGView.hidden = _chooseModeBGView.hidden?NO:YES;
    
    
    
}



- (IBAction)musicProgressBarEvent:(UISlider *)sender {
    
    
    [_playerController setCurrentPlaybackTime:_progressSlider.value * _playerController.nowPlayingItem.playbackDuration];
    
    
    
}



- (IBAction)showVolumeSlide:(UIButton *)sender {
    
    
    _volumeBackgroudView.hidden = _volumeBackgroudView.isHidden ? NO : YES ;
    
}



- (IBAction)changeVolume:(UISlider *)sender {
    
    
    _playerController.volume = sender.value;
    
    
}






#pragma mark -  MPMusicPlayerController NotificationMethod

-(void)MPMusicPlayerControllerStateDidChangeNotification:(NSNotification *)notification{

    if (_playerController.playbackState == MPMoviePlaybackStatePlaying) {
        [_playOrPauseButton setBackgroundImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
        
    }else{
        [_playOrPauseButton setBackgroundImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
    
    }
    
    
    

}



-(void)MPMusicPlayerControllerNowPlayingItemDidChangeNotification:(NSNotification *)notification{

    
    if(_playerController.nowPlayingItem.title){
          self.musicNameLabel.text = [NSString stringWithFormat:@"%@-%@",_playerController.nowPlayingItem.title,_playerController.nowPlayingItem.artist];
    }
    
    
    
    self.totalTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",((NSInteger)_playerController.nowPlayingItem.playbackDuration / 60) ,((NSInteger)_playerController.nowPlayingItem.playbackDuration % 60)];

    
}



-(void)MPMusicPlayerControllerVolumeDidChangeNotification:(NSNotification *)notification{

    _volumeSlider.value = _playerController.volume;

}






-(void)updateProgress{


    self.currentTimeLabel.text = [NSString stringWithTimeInteral:self.playerController.currentPlaybackTime];
    
   
    _progressSlider.value = _playerController.currentPlaybackTime/_playerController.nowPlayingItem.playbackDuration;
    
    

}



- (IBAction)openMelodyMode:(UIButton *)sender {
    
    LEDFunction *ledOpration = [LEDFunction new];
    [ledOpration setLightSenceWithIndex:5 andType:0 andTrans:0];
}









- (IBAction)chooseMusicPlayMode:(UIButton *)sender {

    currentMusicMode = sender.tag;
    switch (currentMusicMode) {
        case LocalMusicMode:
            self.navigationItem.title = @"本地音乐";
            break;

        case TFMusicMode:
            self.navigationItem.title = @"TF卡音乐";
            break;
        default:
            break;
    }
   
    _chooseModeBGView.hidden = YES;
    

}




@end
