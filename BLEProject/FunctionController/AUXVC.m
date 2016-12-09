//
//  AUXVC.m
//  BLEProject
//
//  Created by jp on 2016/11/16.
//  Copyright © 2016年 jp. All rights reserved.
//

#import "AUXVC.h"

@interface AUXVC ()

@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;

@property  (nonatomic, strong)ControlFunction *controlOperation;

@property (nonatomic, strong) AUXFunction *auxOperation;

@property (nonatomic, strong) VolumeFunction *volOperation;


@end

@implementation AUXVC

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
    
    [self initFunction];

}



-(void)initFunction{

    _controlOperation = [ControlFunction new];
    [_controlOperation enterAUX];
    [_controlOperation synchronizeState];
    
    
    
    _auxOperation = [AUXFunction new];
    _volOperation = [VolumeFunction new];
    
    __weak typeof(self) weakSelf = self;
    _auxOperation.getAuxState = ^(BOOL auxState){
    
        if (auxState) {
            [SVProgressHUD showInfoWithStatus:@"AUX接入"];
        }else{
        
            [SVProgressHUD showInfoWithStatus:@"AUX未接入"];
        
        }
    
    };
    
    _auxOperation.getAuxVol = ^(NSInteger volume){
    
        weakSelf.volumeSlider.value = volume;
    
    };


}



- (IBAction)muteTapGesture:(UITapGestureRecognizer *)sender {
    
    UIImageView *volumeImageView = (UIImageView *)sender.view;
    
    volumeImageView.highlighted = volumeImageView.highlighted?NO:YES;
    
    
    if (volumeImageView.highlighted) {
        [[NSUserDefaults standardUserDefaults] setFloat:self.volumeSlider.value forKey:@"volumeSliderValue"];
        
        [_volOperation setDeviceVolumeWithRank:0];
        self.volumeSlider.value = 0;
        
    }else{
    
        self.volumeSlider.value = [[NSUserDefaults standardUserDefaults] floatForKey:@"volumeSliderValue"];
        
        [_volOperation setDeviceVolumeWithRank:[[NSUserDefaults standardUserDefaults] floatForKey:@"volumeSliderValue"]];
    }
    

}







- (IBAction)volumeChange:(UISlider *)sender {
    
    [_volOperation setDeviceVolumeWithRank:sender.value];
    
}



@end
