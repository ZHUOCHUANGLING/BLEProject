//
//  CustomEQVC.m
//  BLEProject
//
//  Created by jp on 2016/12/7.
//  Copyright © 2016年 jp. All rights reserved.
//

#import "CustomEQVC.h"

static const NSInteger SLIDEMIN = -12;
static const NSInteger EQCOUNT = 8;


@interface CustomEQVC ()
@property (weak, nonatomic) IBOutlet UISlider *slider31;
@property (weak, nonatomic) IBOutlet UISlider *slider62;
@property (weak, nonatomic) IBOutlet UISlider *slider125;
@property (weak, nonatomic) IBOutlet UISlider *slider250;
@property (weak, nonatomic) IBOutlet UISlider *slider500;
@property (weak, nonatomic) IBOutlet UISlider *slider1K;
@property (weak, nonatomic) IBOutlet UISlider *slider8K;
@property (weak, nonatomic) IBOutlet UISlider *slider16k;

@property (nonatomic, strong) NSArray *sliderValueArr;
@property (nonatomic, strong) NSMutableArray <UISlider *> *sliderArr;

@end

@implementation CustomEQVC
{
    NSMutableDictionary *_EQDict;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self loadSlider];
}


-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    
    __weak typeof(self) weakSelf = self;
    _eqOperation.getUserEQ = ^(NSDictionary *dict)
    {
        weakSelf.sliderValueArr = @[    dict[@"EQone"],
                                        dict[@"EQtwo"],
                                        dict[@"EQthree"],
                                        dict[@"EQfour"],
                                        dict[@"EQfive"],
                                        dict[@"EQsix"],
                                        dict[@"EQseven"],
                                        dict[@"EQeight"]
                                        ];
        
        
        for (int i = 0; i < EQCOUNT; i++) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.sliderArr[i].value = [weakSelf.sliderValueArr[i] floatValue] + SLIDEMIN;
            });
        }
    };
    
    
    
    [_eqOperation synchronizeEQState];
    
    
}


-(void)initUI{

    NSArray *sliderArr = [NSArray arrayWithObjects:_slider31, _slider62, _slider125, _slider250,_slider500, _slider1K, _slider8K, _slider16k, nil];
    
    
    for (UISlider *slider in sliderArr) {
        [self transformSlider:slider];
    }
    
    
}



-(void)transformSlider:(UISlider *)slider{

    slider.transform = CGAffineTransformMakeRotation( M_PI * 0.5 );


}



- (void)loadSlider
{
    _sliderArr = [NSMutableArray array];
    for (int i = 1; i <= EQCOUNT; i++) {
        UISlider *slider = [self.view viewWithTag:i];
        [_sliderArr addObject:slider];
    }
}


- (void)loadEQDict
{
    
    _EQDict = [@{@"EQone" : @(_sliderArr[0].value - SLIDEMIN),
                 @"EQtwo" : @(_sliderArr[1].value - SLIDEMIN),
                 @"EQthree" : @(_sliderArr[2].value - SLIDEMIN),
                 @"EQfour" : @(_sliderArr[3].value - SLIDEMIN),
                 @"EQfive" : @(_sliderArr[4].value - SLIDEMIN),
                 @"EQsix" : @(_sliderArr[5].value - SLIDEMIN),
                 @"EQseven" : @(_sliderArr[6].value - SLIDEMIN),
                 @"EQeight" : @(_sliderArr[7].value - SLIDEMIN)
                 } mutableCopy];
}




- (IBAction)settingAction:(UIButton *)sender {
    [self loadEQDict];
    [self.eqOperation setUserEQ:_EQDict];
}



- (IBAction)resetAction:(UIButton *)sender {
    
    
    for (int i = 1; i <= EQCOUNT; i ++) {
        UISlider *slider = [self.view viewWithTag:i];
        dispatch_async(dispatch_get_main_queue(), ^{
            slider.value = 0;
        });
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self loadEQDict];
        [self.eqOperation setUserEQ:_EQDict];
    });
}

@end
