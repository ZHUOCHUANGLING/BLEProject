//
//  TimingVC.m
//  BLEProject
//
//  Created by jp on 2016/11/16.
//  Copyright © 2016年 jp. All rights reserved.
//

#import "TimingVC.h"
#import <objc/runtime.h>


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
    TimingSwitch,
    Timing2Switch
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




@property (weak, nonatomic) IBOutlet UIButton *cancelSettingTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmSettingTimeBtn;




@end

@implementation TimingVC
{
    TimeButtonType currentBtnType;
    TimeSwitchType currentSwichType;
    
    UIButton *currentBtn;

    UILocalNotification *_localNotification;
    
    NSMutableArray *_buttonArr;
    NSMutableArray *_switchArr;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNotification];
    
    
    [self setPadButtonUI];
    
    
    [self setIOS8DatePicker];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self refreshUI];
    
}


-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self persistentData];

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
    
    
//    [[UIApplication sharedApplication] scheduleLocalNotification:_localNotification];
    
    
    if (Device_IsPhone) {
        
    }else{
        //标题颜色和字体
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:25],NSForegroundColorAttributeName:[UIColor whiteColor]}];
        
    
    }
    
}




-(void)setIOS8DatePicker{
    
    
    if (Deviece_Version<9.0) {

        
//        _settingTimeView.frame = CGRectMake(0, 0, 100, 200);
        
        
        
    }
   
    
}





-(void)setPadButtonUI{
    
    
    if (!(Device_IsPhone)) {
        _lightOpenBtn.titleLabel.font = [UIFont systemFontOfSize:30];
        [_lightOpenBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 150, 0, 0)];
        _lightCloseBtn.titleLabel.font = [UIFont systemFontOfSize:30];
        [_lightCloseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 150, 0, 0)];
        _playerOpenBtn.titleLabel.font = [UIFont systemFontOfSize:30];
        [_playerOpenBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 150, 0, 0)];
        _playerCloseBtn.titleLabel.font = [UIFont systemFontOfSize:30];
        [_playerCloseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 150, 0, 0)];
        _timingOpenBtn.titleLabel.font = [UIFont systemFontOfSize:30];
        [_timingOpenBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 240, 0, 0)];
        _timingCloseBtn.titleLabel.font = [UIFont systemFontOfSize:30];
        [_timingCloseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 240, 0, 0)];
        
        
        
        _confirmSettingTimeBtn.titleLabel.font = [UIFont systemFontOfSize:30];
        _cancelSettingTimeBtn.titleLabel.font = [UIFont systemFontOfSize:30];
        
    }else{
    
        if (ScreenHeight == 568) {
            _lightOpenBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            _lightCloseBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            _playerOpenBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            _playerCloseBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            _timingOpenBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            _timingCloseBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        }
    
    
    
    }
    
    
    

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
        case Timing2Switch:
            
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


-(void)refreshUI{
    _buttonArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"buttonArr"];
    
    for (NSInteger i = 0; i<_buttonArr.count ; i++) {
        
        NSString *timeStr = _buttonArr[i];
        
        if ((i<=3 && ![timeStr isEqualToString:@"添加时间"])|| (i>3 && ![timeStr isEqualToString:@"添加闹钟"])) {
            
            UIButton *settingBtn = [self.view viewWithTag:i+1];
            settingBtn.selected = YES;
            [settingBtn setTitle:timeStr forState:UIControlStateNormal &UIControlStateSelected];
            
        }
    }
    
    [self refreshSwitch];

}



-(void)refreshSwitch{
    _switchArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"switchArr"];
    
    _lightSwitch.on = [_switchArr[0] boolValue];
    _playerSwitch.on = [_switchArr[1] boolValue];
    _timingSwitch.on = [_switchArr[2] boolValue];
    _timing2Switch.on = [_switchArr[3] boolValue];

}


-(void)persistentData{

    _buttonArr = [NSMutableArray arrayWithObjects:
                  _lightOpenBtn.titleLabel.text,
                  _lightCloseBtn.titleLabel.text,
                  _playerOpenBtn.titleLabel.text,
                  _playerCloseBtn.titleLabel.text,
                  _timingOpenBtn.titleLabel.text,
                  _timingCloseBtn.titleLabel.text,
                  nil];
    
    
    _switchArr = [NSMutableArray arrayWithObjects:
                  @(_lightSwitch.on),
                  @(_playerSwitch.on),
                  @(_timingSwitch.on),
                  @(_timing2Switch.on),
                  nil];
    
    
    
    [[NSUserDefaults standardUserDefaults] setObject:_buttonArr forKey:@"buttonArr"];
    [[NSUserDefaults standardUserDefaults] setObject:_switchArr forKey:@"switchArr"];
    
    
}



@end
