//
//  AUXVC.m
//  BLEProject
//
//  Created by jp on 2016/11/16.
//  Copyright © 2016年 jp. All rights reserved.
//

#import "AUXVC.h"
#import "JPProgressHUD.h"

@interface AUXVC ()

@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;

@property (weak, nonatomic) IBOutlet UIImageView *volumeImageView;


@property (nonatomic, strong) AUXFunction *auxOperation;

@end

@implementation AUXVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initFunction];
    
}




-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    
    [self synchronizeCurrentState];
    [self synchronizeVolumeValue];
}



-(void)synchronizeCurrentState{
    
    [shareMainManager().controlOperation synchronizeState];
    
    shareMainManager().controlOperation.getDeviceCurrentState = ^(DeviceCurrentState state){
        
        if (state != DeviceCurrentStateAUX) {
            
            [shareMainManager().controlOperation enterAUX];
            
        }
    };
    
    
}

-(void)synchronizeVolumeValue{
    
    shareMainManager().volumeOperation.currentVolBlock = ^(NSInteger currentVol){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _volumeSlider.value = currentVol;
        });
        
        
    };
}



-(void)initFunction{

    _auxOperation = [AUXFunction new];
    
    __weak typeof(self) weakSelf = self;
    _auxOperation.getAuxState = ^(BOOL auxState){
    
        if (auxState) {
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
//                [JPProgressHUD showMessage:@"AUX未接入"];
            });
        }
    
    };
    
    _auxOperation.getAuxVol = ^(NSInteger volume){
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.volumeSlider.value = volume;
        });
    };


}



- (IBAction)muteTapGesture:(UITapGestureRecognizer *)sender {
    
    UIImageView *volumeImageView = (UIImageView *)sender.view;
    
    volumeImageView.highlighted = volumeImageView.highlighted?NO:YES;
    
    
    if (volumeImageView.highlighted) {
        
        [[NSUserDefaults standardUserDefaults] setFloat:self.volumeSlider.value forKey:@"volumeSliderValue"];
        
        [shareMainManager().volumeOperation setDeviceVolumeWithRank:0];
        self.volumeSlider.value = 0;
        
    }else{
    
        self.volumeSlider.value = [[NSUserDefaults standardUserDefaults] floatForKey:@"volumeSliderValue"];
        
        [shareMainManager().volumeOperation setDeviceVolumeWithRank:[[NSUserDefaults standardUserDefaults] floatForKey:@"volumeSliderValue"]];
    }
    

}



- (IBAction)volumeChange:(UISlider *)sender {
    
    if (sender.value == 0) {
        _volumeImageView.highlighted = YES;
    }else{
        _volumeImageView.highlighted = NO;
    
    }
    
    [shareMainManager().volumeOperation setDeviceVolumeWithRank:sender.value];
    
}



@end
