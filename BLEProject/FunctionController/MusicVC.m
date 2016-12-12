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
#import "UIViewController+MMDrawerController.h"




#import "FunctionSingleton.h"
#import "MusicListVC.h"


#define RowHeight ScreenHeight*0.07

typedef NS_ENUM(NSInteger, MusicMode) {
    MusicRepeatModeDefault ,
    MusicRepeatModeOne,
    MusicShuffleModeSongs
};


typedef NS_ENUM(NSInteger, TFMusicPlayMode){
    TFMusicRepeatModeDefault = 0x01,
    TFMusicRepeatModeOne,
    TFMusicShuffleModeSongs


};



@interface MusicVC ()<AVAudioPlayerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)ControlFunction *controlOperation;


//local
@property (nonatomic, strong) MPMusicPlayerController *playerController;


//TF
@property (nonatomic, strong) MusicFunction *musicOperation;
@property (nonatomic, strong) VolumeFunction *volumeOperation;
@property (nonatomic, assign) NSInteger nowTime;
@property (nonatomic, assign) NSInteger totalTime;



@property (weak, nonatomic) IBOutlet UILabel *musicNameLabel;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;


@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;


@property (weak, nonatomic) IBOutlet UIButton *playOrPauseButton;
@property (weak, nonatomic) IBOutlet UIButton *selectModeButton;


@property (weak, nonatomic) IBOutlet UIView *volumeBackgroudView;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;




@property (strong, nonatomic) UITableView *chooseModeTableView;



@end

@implementation MusicVC
{
    
    //local
    NSArray *_mediaItems;
    NSInteger sessionMusicCount;
    
    BOOL hasMusic;

    MusicMode currentMode;
    ChooseMusicPlayMode currentMusicMode;
    
    NSTimer *_progressTimer;
    NSTimer *_tfMusicTimer;
    
    
    
    //TF
    NSInteger nowIndex;
    TFMusicPlayMode currentTFPlayMode;
    NSInteger totalNumber;
    
    
    
    //chooseModeTableView
    NSMutableArray *_chooseModeTableViewArr;
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    currentMusicMode = [[NSUserDefaults standardUserDefaults] integerForKey:@"ChooseMusicPlayMode"];
    
    [self initMusicState];
    
    [self initTableView];
    
}



- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    
    
    
    if (currentMusicMode != LocalMusicMode && _playerController) {
        [_playerController pause];
    }
    
    
    if (currentMusicMode != TFMusicMode && self.musicOperation) {
        
        if (_playOrPauseButton.selected) {
            [self.musicOperation setIsPlay:NO];
        }
    
        [_tfMusicTimer setFireDate:[NSDate distantFuture]];
        
    }
    
    

    
    
    if (_progressTimer.isValid) {
        
        [_progressTimer invalidate];
        _progressTimer = nil;
    }
    
    
    if (_tfMusicTimer.isValid) {
        [_tfMusicTimer invalidate];
        _tfMusicTimer = nil;
    }
    
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];


    
}







-(void)initMusicState{
    
    
    FunctionSingleton *func = [FunctionSingleton shareFunction];
    
    self.musicOperation = func.musicOperation;
    
    [_controlOperation enterMusic];
    
    switch (currentMusicMode) {
            
        case LocalMusicMode:
            [_musicOperation setDeviceSource:DeviceSourceBluetooth];
            
            
            _mediaItems = [NSArray array];
            [self initMusicPlayerController];
            
            [self loadMediaItems];
            [self initUI];
            [self addObserver];
            
            
            
            break;
            
            
            
        case TFMusicMode:
            
            
            _controlOperation = [ControlFunction new];
            
            [_controlOperation synchronizeState];
            
            
            [_musicOperation setDeviceSource:DeviceSourceSDCard];
            
            [self setupMusicTimer];

            [self initTFFunctionState];
            
            self.volumeOperation = [[VolumeFunction alloc] init];
            
            
            
            
            
            break;
            
            
        case OnlineMusicMode:
            
            break;
            
            
        default:
            break;
    }

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

    
    _progressSlider.userInteractionEnabled = YES;
    
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

    
    
     [[NSUserDefaults standardUserDefaults] setInteger:mode forKey:@"tfPlayMode"];

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


-(void)addObserver{
    

    //playerController Notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MPMusicPlayerControllerStateDidChangeNotification:) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MPMusicPlayerControllerNowPlayingItemDidChangeNotification:) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MPMusicPlayerControllerVolumeDidChangeNotification:) name:MPMusicPlayerControllerVolumeDidChangeNotification object:nil];

}






- (IBAction)prev:(UIButton *)sender {
    
    if (currentMusicMode == LocalMusicMode) {
        if (_playerController) {
        
            [_playerController skipToPreviousItem];
     
        }
    }
    
    
    if (currentMusicMode == TFMusicMode) {
        [self.musicOperation prev];
    }
    
}



- (IBAction)play:(UIButton *)sender {
    
    
    
    if (currentMusicMode == LocalMusicMode) {
        
    
       
        if(_playerController){

            if (self.playerController.playbackState != MPMusicPlaybackStatePlaying) {
                
                [_playerController play];
                
            }else{
                
                [_playerController pause];
                
            }
            
        }

    }
    
    
    
    
    
    
    if (currentMusicMode == TFMusicMode) {
        
      
        sender.selected = !sender.selected;
        [self.musicOperation setIsPlay:sender.selected];
  
    }
    
    
    
    
    

}



- (IBAction)next:(id)sender {
    
    
    if (currentMusicMode == LocalMusicMode) {
    
        if (_playerController) {
        
            if (currentMusicMode == LocalMusicMode) {
                [_playerController skipToNextItem];
            }
        }
    }
    
    if (currentMusicMode == TFMusicMode) {

        [self.musicOperation next];
    
    }
    
    

}














#pragma mark -  选择模式
- (IBAction)chooseMode:(UIButton *)sender {
    
    
    
    if(currentMusicMode == LocalMusicMode){
        
        currentMode = currentMode<2?++currentMode:0;
        [self settingMusicMode:currentMode];
        
    }
    
    
    if (currentMusicMode == TFMusicMode) {
        
        
        currentTFPlayMode = currentTFPlayMode<3?++currentTFPlayMode:1;
        

        [self showProgressHUD:currentTFPlayMode];
        
    }
    
    
    

}






- (IBAction)musicProgressBarEvent:(UISlider *)sender {
    
    
    [_playerController setCurrentPlaybackTime:_progressSlider.value * _playerController.nowPlayingItem.playbackDuration];
    
    
    
}








- (IBAction)showVolumeSlide:(UIButton *)sender {
    
    
    _volumeBackgroudView.hidden = _volumeBackgroudView.isHidden ? NO : YES ;
    
}



- (IBAction)changeVolume:(UISlider *)sender {
    
    if (currentMusicMode == LocalMusicMode) {
        _playerController.volume = sender.value;
    }
    
    
    if (currentMusicMode == TFMusicMode) {
    
        [_volumeOperation setDeviceVolumeWithRank:sender.value * 15];
    }
    
    
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

    if (currentMusicMode == LocalMusicMode) {
        self.currentTimeLabel.text = [NSString stringWithTimeInteral:self.playerController.currentPlaybackTime];
        
        
        _progressSlider.value = _playerController.currentPlaybackTime/_playerController.nowPlayingItem.playbackDuration;
    }
   
    
    if (currentMusicMode == TFMusicMode) {
        
        
        
        self.nowTime ++ ;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.currentTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",self.nowTime/60,self.nowTime%60];
            
            self.progressSlider.value = self.nowTime / (CGFloat)self.totalTime;
            
        });
        
    }
    
    

}



- (IBAction)openMelodyMode:(UIButton *)sender {
    
    LEDFunction *ledOpration = [LEDFunction new];
    [ledOpration setLightSenceWithIndex:5 andType:0 andTrans:0];
}






#pragma mark -  TF
-(void)initTFFunctionState{

    
    
    __weak typeof(_tfMusicTimer) weakTFTimer = _tfMusicTimer;
    __weak typeof(self) weakSelf = self;
    
    
    self.musicOperation.currentSongName = ^(NSString *songName){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            weakSelf.musicNameLabel.text = songName;

            
        });
    };
    
    
    
    self.musicOperation.currentMusicState = ^(NSInteger currentIndex,NSInteger totalNum,NSInteger currentTime,NSInteger totalTime,BOOL isPlay){
    
        nowIndex = currentIndex;
        totalNumber = totalNum;
        
        if (!weakSelf.nowTime) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.currentTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",currentTime/60,currentTime%60];
            });
        }
        
        
        
        weakSelf.nowTime = currentTime;
        
        
 
        
        if (isPlay) {
            
            
            
            [weakTFTimer setFireDate:[NSDate date]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.playOrPauseButton setBackgroundImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
            });
            
            }
        else{
            
            
            [weakTFTimer setFireDate:[NSDate distantFuture]];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{

                
                [weakSelf.playOrPauseButton setBackgroundImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
            });
        }
        
        
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            weakSelf.playOrPauseButton.selected = isPlay;
            weakSelf.progressSlider.value = currentTime / (CGFloat) totalTime;
            weakSelf.totalTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",totalTime/60,totalTime%60];
        });
        
        
        
        weakSelf.totalTime = totalTime;
        
        
    
    };
    

    
    self.musicOperation.currentSource = ^(DeviceSource currentSource){
        
        
        
        if (currentSource == DeviceSourceBluetooth) {
            [weakTFTimer setFireDate:[NSDate distantFuture]];
        }
    
    
    };
    

    
    
    _progressSlider.userInteractionEnabled = NO;

    
    
     currentTFPlayMode = [[NSUserDefaults standardUserDefaults] integerForKey:@"tfPlayMode"];
    
    if (currentTFPlayMode == 0 || !currentTFPlayMode) {
        currentTFPlayMode = TFMusicRepeatModeDefault;
    }
    
    
    [self setTFMusicPlayMode:currentTFPlayMode];
    
    
    
    
}






- (void)setupMusicTimer{
    
    __weak typeof(self) weakSelf = self;
    _tfMusicTimer = [NSTimer timerWithTimeInterval:1 target:weakSelf selector:@selector(updateProgress) userInfo:nil repeats:YES];
    __weak typeof(_tfMusicTimer) weakTimer = _tfMusicTimer;
    
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [weakTimer setFireDate:[NSDate distantFuture]];
        [[NSRunLoop currentRunLoop] addTimer:weakTimer forMode:NSRunLoopCommonModes];
        [[NSRunLoop currentRunLoop] run];
    });
    
}





-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([segue.identifier isEqualToString:@"listSegue"]) {
        
        
        MusicListVC *musicListVC = segue.destinationViewController;
        
        
        musicListVC.musicMode = currentMusicMode;
        
        musicListVC.musicOperation = self.musicOperation;
        
        musicListVC.totalNum = totalNumber;
        
        musicListVC.currentIndex = nowIndex;
        
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

- (IBAction)chooseTFOrLocalMode:(UIBarButtonItem *)sender {
    
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
