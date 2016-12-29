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
#import "UIView+RotateAnimation.h"
#import "LMJScrollTextView.h"
#import "MusicFunctionManger.h"

#import "MusicTabbarVC.h"


#define RowHeight ScreenHeight*0.07
#define RotateSpeed 0.8



typedef NS_ENUM(NSInteger, MusicMode) {
    MusicRepeatModeDefault ,
    MusicRepeatModeOne,
    MusicShuffleModeSongs
};

@interface MusicVC ()<AVAudioPlayerDelegate,MusicTabbarVCDelegate>

@property (nonatomic, strong)LMJScrollTextView *scrollTextView;
@property (weak, nonatomic) IBOutlet UIImageView *albumImageView;

//local
@property (nonatomic, strong) MPMusicPlayerController *playerController;

@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseButton;
@property (weak, nonatomic) IBOutlet UIButton *selectModeButton;
@property (weak, nonatomic) IBOutlet UIView *volumeBackgroudView;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;



@end

@implementation MusicVC
{
    
    //local
    NSArray *_mediaItems;
    NSInteger sessionMusicCount;
    
    BOOL hasMusic;
    BOOL hasTFCard;

    MusicMode currentMode;
    
    
    NSTimer *_progressTimer;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initMusicState];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self synchronizeState];
    
}

-(void)synchronizeState{
    
    [shareMusicOperation() setDeviceSource:DeviceSourceBluetooth];
}





-(void)initMusicState{
    
    
    _mediaItems = [NSArray array];
    [self initMusicPlayerController];
    
    [self loadMediaItems];
    [self initUI];
    [self addObserver];
    
    [self initScrollTextView];
    
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

    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstMusicFunctionLaunch"]) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstMusicFunctionLaunch"];
        
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

    
    _progressSlider.userInteractionEnabled = YES;
    
}


-(void)initUI{
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem  = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    _volumeSlider.value = _playerController.volume;
    
    if (self.playerController.playbackState == MPMusicPlaybackStatePlaying) {
        
        [_playOrPauseButton setBackgroundImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
    }
    
    
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
            
            [JPProgressHUD showMessage:@"列表循环播放"];
            
            break;
            
        case MusicRepeatModeOne:
            [self setMusicModeProperty:MusicRepeatModeOne];
            
            [JPProgressHUD showMessage:@"单曲播放"];
            break;
            
        case MusicShuffleModeSongs:
            [self setMusicModeProperty:MusicShuffleModeSongs];
            
            [JPProgressHUD showMessage:@"随机播放"];
            break;
            
            
        default:
            break;
    }
    
   
    

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
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBackActive:)name:UIApplicationDidBecomeActiveNotification object:nil];
    
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(centeralDisconnectPeripheral:) name:BLEPeripheralDisconnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(centeralDisconnectPeripheral:) name:BLEConnectFailNotification object:nil];
    
    

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
                
                [_albumImageView rotate360DegreeWithImageView:RotateSpeed];
                
                
            }else{
                
                [_playerController pause];
                
                [_albumImageView stopRotate];
                
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
        [self.scrollTextView startScrollWithText:[NSString stringWithFormat:@"%@-%@",_playerController.nowPlayingItem.title,_playerController.nowPlayingItem.artist] textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:17]];
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





-(void)initScrollTextView{

    [self.scrollTextView startScrollWithText:@"艺术家" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:16]];
    
    
}



-(LMJScrollTextView *)scrollTextView{

    if (!_scrollTextView) {
        _scrollTextView = [[LMJScrollTextView alloc] initWithFrame:CGRectMake(20, ScreenHeight * 0.55, ScreenWidth-40, 30) textScrollModel:LMJTextScrollContinuous direction:LMJTextScrollMoveLeft];
        
        [self.view addSubview:self.scrollTextView];
    }
    
    return _scrollTextView;
}










#pragma mark -  APP_Notification
-(void)applicationDidBackActive:(NSNotification *)notification{

    [self loadMediaItems];

}



#pragma mark -  BLE_Notification
-(void)centeralDisconnectPeripheral:(NSNotification *)notification{

    if (_playerController) {
        [_playerController pause];
    }

}






#pragma mark -  MusicTabbarVCDelegate
-(void)pausePlayingMusic{

    if (_playerController) {
        [_playerController pause];
        [_albumImageView stopRotate];
    }


}



@end
