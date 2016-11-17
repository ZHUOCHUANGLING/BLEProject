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


-(void)initColorPicker{

    int width=ScreenWidth*0.7;
    
    
    CGRect rect = CGRectMake(0.15*ScreenWidth, ScreenHeight*0.15, width, width);
    _colorPicker = [[RSColorPickerView alloc] initWithFrame:rect];
    
    _colorPicker.cropToCircle = YES;
    _colorPicker.showLoupe = NO;
    [_colorPicker setDelegate:self];
    

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




- (IBAction)brightnessChange:(UISlider *)sender {
    
    [self colorPickerDidChangeSelection:_colorPicker];
    
}


@end
