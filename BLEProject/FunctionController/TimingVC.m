//
//  TimingVC.m
//  BLEProject
//
//  Created by jp on 2016/11/16.
//  Copyright © 2016年 jp. All rights reserved.
//

#import "TimingVC.h"


typedef NS_ENUM(NSInteger, TimeButtonType) {
    LightOpenBtn = 0x01,
    LightCloseBtn,
    PlayerOpenBtn,
    PlayerCloseBtn,
    TimingOpenBtn,
    TimingCloseBtn
};


typedef NS_ENUM(NSInteger, TimeSwitchType) {
    LightSwitch = 0x0A,
    PlayerSwitch,
    TimingSwitch
};


@interface TimingVC ()

@property (weak, nonatomic) IBOutlet UIView *settingTimeBackView;
@property (weak, nonatomic) IBOutlet UIDatePicker *settingTimePicker;




@property (weak, nonatomic) IBOutlet UISwitch *lightSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *playerSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *timingSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *timing2Switch;





@property (weak, nonatomic) IBOutlet UIButton *lightOpenBtn;
@property (weak, nonatomic) IBOutlet UIButton *lightCloseBtn;
@property (weak, nonatomic) IBOutlet UIButton *playerOpenBtn;
@property (weak, nonatomic) IBOutlet UIButton *playerCloseBtn;
@property (weak, nonatomic) IBOutlet UIButton *timingOpenBtn;
@property (weak, nonatomic) IBOutlet UIButton *timingCloseBtn;

@end

@implementation TimingVC
{
    TimeButtonType currentBtnType;
    TimeSwitchType currentSwichType;
    
    UIButton *currentBtn;

    UILocalNotification *_localNotification;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNotification];
    
}




-(void)initNotification{
    
    _localNotification = [UILocalNotification new];
    
    
    NSDate *pushDate = [NSDate dateWithTimeIntervalSinceNow:10];
    _localNotification.fireDate = pushDate;

    
    _localNotification.alertBody = @"haha";
    _localNotification.alertTitle = @"呼呼";
    _localNotification.soundName = UILocalNotificationDefaultSoundName;
//    _localNotification.applicationIconBadgeNumber = 0;
    _localNotification.alertAction = @"哟西";
    
    
    [[UIApplication sharedApplication] scheduleLocalNotification:_localNotification];

    
    
}





- (IBAction)timingSwitch:(UISwitch *)sender {
    
    currentSwichType = sender.tag;
    
    switch (currentSwichType) {
        case LightSwitch:
            
            break;
        case PlayerSwitch:
            
            break;
        case TimingSwitch:
            
            break;
            
        default:
            break;
    }
    
    
    
    
}


- (IBAction)settingTimeClick:(UIButton *)sender {
    
    currentBtnType = sender.tag;
    currentBtn = sender;
    
    self.settingTimeBackView.hidden = NO;
    
    
    
    
}


- (IBAction)deleteTimeGesture:(UILongPressGestureRecognizer *)sender {
    
    
    
    
    UIButton *currentButton = (UIButton *)sender.view;

    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"是否删除当前设置时间" preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [currentButton setTitle:@"添加时间" forState:UIControlStateNormal];
        
        if (currentButton == _timingOpenBtn || currentButton == _timingCloseBtn) {
            [currentButton setTitle:@"添加闹钟" forState:UIControlStateNormal];
        }
        currentButton.selected = NO;
        
        
        currentBtnType = currentButton.tag;

        switch (currentBtnType) {
                
            case LightOpenBtn:

                _lightSwitch.on = NO;
                
                break;
            case LightCloseBtn:
                
                _lightSwitch.on = NO;
                
                

                break;
                
                
            case PlayerOpenBtn:
                
                _playerSwitch.on = NO;
                

                break;
            case PlayerCloseBtn:
                
                _playerSwitch.on = NO;
                
                break;
                
                
            case TimingOpenBtn:
                
                _timingSwitch.on = NO;
                
                
                
                break;
            case TimingCloseBtn:
                
                _timing2Switch.on = NO;
                
                
                
                break;
                
            default:
                break;
        }
        
        
    }];
    
    
    
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    
    
    [self presentViewController:alertController animated:NO completion:nil];
    

}





- (IBAction)settingTimeConfirmClick:(UIButton *)sender {
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"HH:mm"];
    NSString *settingTimeStr = [formatter stringFromDate:_settingTimePicker.date];

    
    switch (currentBtnType) {
            
        case LightOpenBtn:
            if (_lightCloseBtn.selected) {
                _lightSwitch.on = YES;
            }
            
            
            break;
        case LightCloseBtn:
            if (_lightOpenBtn.selected) {
                _lightSwitch.on = YES;
            }
            
            
            break;
            
            
        case PlayerOpenBtn:
            if (_playerCloseBtn.selected) {
                _playerSwitch.on = YES;
            }
            
            
            break;
        case PlayerCloseBtn:
            
            if (_playerOpenBtn.selected) {
                _playerSwitch.on = YES;
            }
            
            break;
            
            
        case TimingOpenBtn:
            _timingSwitch.on = YES;
            break;
        case TimingCloseBtn:
            _timing2Switch.on = YES;
            break;
            
        default:
            break;
    }
    
    
    currentBtn.selected = YES;
    
    [currentBtn setTitle:settingTimeStr forState:UIControlStateNormal &UIControlStateSelected];
    
    
    _settingTimeBackView.hidden = YES;
    
    
}



- (IBAction)settingTimeCancelClick:(UIButton *)sender {
    
    _settingTimeBackView.hidden = YES;
}




@end
