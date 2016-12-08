//
//  CustomEQVC.m
//  BLEProject
//
//  Created by jp on 2016/12/7.
//  Copyright © 2016年 jp. All rights reserved.
//

#import "CustomEQVC.h"

@interface CustomEQVC ()
@property (weak, nonatomic) IBOutlet UISlider *slider31;
@property (weak, nonatomic) IBOutlet UISlider *slider62;
@property (weak, nonatomic) IBOutlet UISlider *slider125;
@property (weak, nonatomic) IBOutlet UISlider *slider250;
@property (weak, nonatomic) IBOutlet UISlider *slider500;
@property (weak, nonatomic) IBOutlet UISlider *slider1K;
@property (weak, nonatomic) IBOutlet UISlider *slider8K;
@property (weak, nonatomic) IBOutlet UISlider *slider16k;

@end

@implementation CustomEQVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
    
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












@end
