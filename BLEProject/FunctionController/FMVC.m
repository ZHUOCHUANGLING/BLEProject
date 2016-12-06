//
//  FMVC.m
//  BLEProject
//
//  Created by jp on 2016/11/16.
//  Copyright © 2016年 jp. All rights reserved.
//

#import "FMVC.h"

@interface FMVC ()

@property (weak, nonatomic) IBOutlet UIView *volumeBGView;

@property (weak, nonatomic) IBOutlet UILabel *FMChannelLab;

@property (weak, nonatomic) IBOutlet UISlider *changeChannelSlider;

@property (weak, nonatomic) IBOutlet UIView *seachingView;






@property (nonatomic, strong) VolumeFunction *volOperation;

@property (nonatomic, strong) FMFunction *fmOperation;


@property (nonatomic, strong) ControlFunction *controlOperation;
@end

@implementation FMVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self resetTFSongList];
 
    
}



-(void)resetTFSongList{
    
    NSArray *resetArr;
    [[NSUserDefaults standardUserDefaults] setObject:resetArr forKey:@"tfSongListArr"];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self initUI];
    
    
    [self initFunction];
    
    [self initState];
}



-(void)initUI{

    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];

    

    [_changeChannelSlider setThumbImage:[UIImage imageNamed:@"滑竿"] forState:UIControlStateNormal];
    [_changeChannelSlider setThumbImage:[UIImage imageNamed:@"滑竿"] forState:UIControlStateHighlighted];
    
}


-(void)initFunction{
   
    _controlOperation = [ControlFunction new];
    [_controlOperation enterFM];
    [_controlOperation synchronizeState];
    
    _volOperation = [VolumeFunction new];
    
    _fmOperation = [FMFunction new];

    
    
}


-(void)initState{

    __weak typeof(self) weakSelf = self;

    
    _fmOperation.channelResponse = ^(NSInteger currentChannel,
                            NSInteger totalChannel,
                            CGFloat channelRate){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            weakSelf.changeChannelSlider.value = channelRate;
            
            weakSelf.FMChannelLab.text = [NSString stringWithFormat:@"%.1f",channelRate];
            
        });
    };
    

    
    _fmOperation.searchState = ^(BOOL isSearch){
        
        NSLog(@"%@",isSearch ? @"-->正在搜索" : @"-->结束搜索");
        
        [weakSelf showSearchingView:isSearch];
        
        
        
    };


}


-(void)showSearchingView:(BOOL)isSearching{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _seachingView.hidden = isSearching?NO:YES;
    });
    
}







#pragma mark -  Channel_Method
- (IBAction)changeVolumeEvent:(UISlider *)sender {

    [_volOperation setDeviceVolumeWithRank:sender.value];
}



- (IBAction)showVolumeView:(UIButton *)sender {
    
    _volumeBGView.hidden = _volumeBGView.hidden?NO:YES;
    

}






- (IBAction)changeChanel:(UISlider *)sender {
    
    if (sender.value < 87.5) {
        _changeChannelSlider.value = 87.5;
    }
    
    if (sender.value >108) {
        _changeChannelSlider.value = 108;
    }
    
    
    
    
    [_fmOperation setStationChannelWithRate:sender.value];
    
//    _FMChannelLab.text = [NSString stringWithFormat:@"%.1f",sender.value];
    
}



- (IBAction)prevChannel:(UIButton *)sender {
    
    [_fmOperation pervStation];
}


- (IBAction)nextChannel:(UIButton *)sender {
    
    [_fmOperation nextStation];
}




- (IBAction)searchChannel:(UIButton *)sender {
    
    [_fmOperation startOrStopSearchStation];
    

}













@end
