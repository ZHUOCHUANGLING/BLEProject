//
//  TFMusicVC.m
//  BLEProject
//
//  Created by jp on 2016/12/27.
//  Copyright © 2016年 jp. All rights reserved.
//

#import "TFMusicVC.h"
#import "UIView+RotateAnimation.h"
#import "LMJScrollTextView.h"
#import "MusicFunctionManger.h"
#import "TFMusicListVC.h"


#import "MusicTabbarVC.h"

#define RowHeight ScreenHeight*0.07
#define RotateSpeed 0.8


typedef NS_ENUM(NSInteger, TFMusicPlayMode){
    TFMusicRepeatModeDefault = 0x01,
    TFMusicRepeatModeOne,
    TFMusicShuffleModeSongs
    
};



@interface TFMusicVC ()<MusicTabbarVCDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *albumImageView;
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseButton;
@property (weak, nonatomic) IBOutlet UIButton *previousButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *songListButton;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;
@property (weak, nonatomic) IBOutlet UIView *volumeBackgroudView;
@property (weak, nonatomic) IBOutlet UIButton *selectModeButton;


@property (nonatomic, strong)LMJScrollTextView *scrollTextView;


@property (nonatomic, strong)MusicFunction *musicOperation;
@property (nonatomic, assign)NSInteger nowTime;
@property (nonatomic, assign)NSInteger totalTime;

@end

@implementation TFMusicVC
{
    
    NSTimer *_currentTimer;
    NSInteger nowIndex;
    NSInteger totalNumber;
//    NSMutableArray *_tfSongListArr;
    
    TFMusicPlayMode currentTFPlayMode;
    
}


-(LMJScrollTextView *)scrollTextView{
    
    if (!_scrollTextView) {
        _scrollTextView = [[LMJScrollTextView alloc] initWithFrame:CGRectMake(20, ScreenHeight * 0.55, ScreenWidth-40, 30) textScrollModel:LMJTextScrollContinuous direction:LMJTextScrollMoveLeft];
        
        [self.view addSubview:_scrollTextView];
    }
    
    return _scrollTextView;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTFFunction];
    [self initUI];
    
    
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self synchronizeState];
    [self synchronizeVolumeValue];
}



-(void)synchronizeState{
    
    [shareMusicOperation() setDeviceSource:DeviceSourceSDCard];
}


-(void)synchronizeVolumeValue{
    
    shareMainManager().volumeOperation.currentVolBlock = ^(NSInteger currentVol){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _volumeSlider.value = currentVol;
        });
        
        
    };
}




-(void)initTFFunction{

//    _songListButton.userInteractionEnabled = NO;

    [shareMainManager().controlOperation enterMusic];
    
    [self initTimer];
    [self initTFState];

    currentTFPlayMode = TFMusicRepeatModeDefault;
    
}

-(void)initUI{
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem  = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
}



-(void)initTFState{

    __weak typeof(_currentTimer) weakTFTimer = _currentTimer;
    __weak typeof(self) weakSelf = self;
    
    
    

    
    
    
    shareMusicOperation().currentMusicState = ^(NSInteger currentIndex,NSInteger totalNum,NSInteger currentTime,NSInteger totalTime,BOOL isPlay){
        
        
        nowIndex = currentIndex;
        totalNumber = totalNum;
        
        
        if (!weakSelf.nowTime) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.currentTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",currentTime/60,currentTime%60];
            });
        }
        weakSelf.nowTime = currentTime;
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.progressSlider.value = currentTime / (CGFloat) totalTime;
            weakSelf.totalTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",totalTime/60,totalTime%60];
        });
        weakSelf.totalTime = totalTime;
        
        
        if (isPlay) {
            [weakSelf playMusicEvent];
        } else {
            [weakSelf pauseMusicEvent];
        }
        
        
//        weakSelf.songListButton.userInteractionEnabled = YES;
        
        
    };
    
    
    

    
    [shareMusicOperation() getSongList];
    shareMusicOperation().listSongName = ^(NSString *songListName){
        
        [shareTFSongListArr() addObject:songListName];
        
    };
    
    
    
    shareMusicOperation().currentSongName = ^(NSString *songName){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf.scrollTextView startScrollWithText:songName textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:17]];
            
        });
        
    };
    
    
    
    
    
    shareMusicOperation().currentSource = ^(DeviceSource currentSource){
        
        if (currentSource == DeviceSourceBluetooth) {
            [weakTFTimer setFireDate:[NSDate distantFuture]];
        }
        
        
    };
    
    
    
    
    
    
}





-(void)playMusicEvent{

    _playOrPauseButton.selected = YES;
    
    [_currentTimer setFireDate:[NSDate date]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_playOrPauseButton setBackgroundImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
        [_albumImageView rotate360DegreeWithImageView:RotateSpeed];
        
        
    });

}




-(void)pauseMusicEvent{
    
    _playOrPauseButton.selected = NO;
    
    [_currentTimer setFireDate:[NSDate distantFuture]];
    
    dispatch_async(dispatch_get_main_queue(), ^{

        [_playOrPauseButton setBackgroundImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
        [_albumImageView stopRotate];
    });

}






-(void)initTimer{

    __weak typeof(self) weakSelf = self;
    _currentTimer = [NSTimer timerWithTimeInterval:1.0f target:weakSelf selector:@selector(updateProgressSlider) userInfo:nil repeats:YES];
    
    
    __weak typeof(_currentTimer) weakTimer = _currentTimer;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        [weakTimer setFireDate:[NSDate distantFuture]];
        
        [[NSRunLoop currentRunLoop] addTimer:weakTimer forMode:NSRunLoopCommonModes];
        [[NSRunLoop currentRunLoop] run];
        
    });

}



-(void)updateProgressSlider{
    
    self.nowTime ++ ;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _currentTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",self.nowTime/60,self.nowTime%60];
        
        _progressSlider.value = self.nowTime / (CGFloat)self.totalTime;

        
    });

}






-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"TFListSegue"]) {

        TFMusicListVC *vc = segue.destinationViewController;
        vc.currentIndex = nowIndex;

    }

}




- (IBAction)openSceneClick:(UIButton *)sender {
    
    LEDFunction *ledOpration = [LEDFunction new];
    [ledOpration setLightSenceWithIndex:5 andType:0 andTrans:0];
    
}


- (IBAction)choosePlayMode:(UIButton *)sender {
    
    
    currentTFPlayMode = currentTFPlayMode<3?++currentTFPlayMode:1;
    
    [self showProgressHUD:currentTFPlayMode];
    
}



- (IBAction)volumeBGViewHiddenClick:(UIButton *)sender {
    _volumeBackgroudView.hidden = _volumeBackgroudView.isHidden ? NO : YES ;
    
}



- (IBAction)changeVolume:(UISlider *)sender {
    
    [shareMainManager().volumeOperation setDeviceVolumeWithRank:sender.value];
}



- (IBAction)previousMusic:(UIButton *)sender {
    
    [shareMusicOperation() prev];
}


- (IBAction)playOrPauseClick:(UIButton *)sender {
    
    
    sender.selected = !sender.selected;
    
    [shareMusicOperation() setIsPlay:sender.selected];
    
    
    
}


- (IBAction)nextMusic:(UIButton *)sender {
    
    [shareMusicOperation() next];
    
}





-(void)showProgressHUD:(TFMusicPlayMode)mode{
    
    switch (mode) {
        case TFMusicRepeatModeDefault:
            
            
            [JPProgressHUD showMessage:@"列表循环播放"];
            break;
            
        case TFMusicRepeatModeOne:
            
            
            [JPProgressHUD showMessage:@"单曲播放"];
            break;
            
        case TFMusicShuffleModeSongs:
            
            
            [JPProgressHUD showMessage:@"随机播放"];
            break;
        default:
            break;
    }
    
    
    [self setTFMusicPlayMode:mode];
}



-(void)setTFMusicPlayMode:(TFMusicPlayMode)mode{
    
    
    switch (mode) {
        case TFMusicRepeatModeDefault:
            
            [self.musicOperation setDevicePlayMode:MusicPlayModeAllPlay];
            
            [_selectModeButton setImage:[UIImage imageNamed:@"顺序"] forState:UIControlStateNormal];
            
            
            break;
            
        case TFMusicRepeatModeOne:
            [self.musicOperation setDevicePlayMode:MusicPlayModeSinglePlay];
            
            [_selectModeButton setImage:[UIImage imageNamed:@"单曲循环"] forState:UIControlStateNormal];
            
            
            break;
            
        case TFMusicShuffleModeSongs:
            [self.musicOperation setDevicePlayMode:MusicPlayModeRandomPlay];
            
            
            [_selectModeButton setImage:[UIImage imageNamed:@"随机"] forState:UIControlStateNormal];
            
            break;
        default:
            break;
    }
    
    
    

    
}


-(void)pausePlayingMusic{

    if (_playOrPauseButton.selected) {
        
        dispatch_main_async_safe(^{
            [self playOrPauseClick:_playOrPauseButton];
        });
        
    }
    

}






@end
