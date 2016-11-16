//
//  LampVC.m
//  BLEProject
//
//  Created by jp on 2016/11/15.
//  Copyright © 2016年 jp. All rights reserved.
//

#import "LampVC.h"
#import "RSColorPickerView.h"


@interface LampVC ()<RSColorPickerViewDelegate>

//UI
@property (weak, nonatomic) IBOutlet UISlider *brightnessSlider;


//
@property (nonatomic,strong) LEDFunction *operationModel;


@end

@implementation LampVC
{
    RSColorPickerView *_colorPicker;
    
    NSDate *_oldTime;
}





- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    
    [self initColorPicker];
   
    [self setupOperationModel];
}


- (void)setupOperationModel {
    
    _oldTime = [NSDate date];

    self.operationModel = [[LEDFunction alloc] init];
}





- (IBAction)brightnessChange:(UISlider *)sender {
    
    [self colorPickerDidChangeSelection:_colorPicker];
    
}




-(void)initColorPicker{

    int width=0;
    CGRect rect;
    if ([UIScreen mainScreen].bounds.size.height == 568) {
        width = ScreenWidth*0.5;
        
        rect = CGRectMake((ScreenWidth-ScreenWidth*0.5)/2.0, 110, width, width);
        _colorPicker = [[RSColorPickerView alloc] initWithFrame:rect];
        
    }
    
    if ([UIScreen mainScreen].bounds.size.height == 667) {
        width = ScreenWidth*0.65;
        rect = CGRectMake((ScreenWidth-ScreenWidth*0.7)/1.74, 120, width, width);
        _colorPicker = [[RSColorPickerView alloc] initWithFrame:rect];
    }
    
    if ([UIScreen mainScreen].bounds.size.height == 736) {
        width = ScreenWidth*0.7;
        rect = CGRectMake((ScreenWidth-ScreenWidth*0.8)/1.5, 130, width, width);
        _colorPicker = [[RSColorPickerView alloc] initWithFrame:rect];
    }

    
    [_colorPicker setDelegate:self];
    
    
    
    _colorPicker.cropToCircle = YES;
    _colorPicker.showLoupe = NO;
    [self.view addSubview:_colorPicker];
}





#pragma mark - RSColorPickerView delegate methods


- (void)colorPickerDidChangeSelection:(RSColorPickerView *)cp {
    
    CGFloat r, g, b, a;
    [[cp selectionColor] getRed:&r green:&g blue:&b alpha:&a];
    
    
    NSString *colorDesc = [NSString stringWithFormat:@"rgba: %f, %f, %f, %f", r, g, b, a];
    NSLog(@"%@", colorDesc);

    
    
    CGFloat slideValue = self.brightnessSlider.value;
    
    if (-[_oldTime timeIntervalSinceNow] > 0.08) {
        _oldTime = [NSDate date];
        
            [self.operationModel setLightColorWithRed:r*255*slideValue green:g*255*slideValue blue:b*255*slideValue white:0];
        
    }
    
}



@end
