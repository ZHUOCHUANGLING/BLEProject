//
//  LampVC.m
//  BLEProject
//
//  Created by jp on 2016/11/15.
//  Copyright © 2016年 jp. All rights reserved.
//

#import "LampVC.h"
#import "RSColorPickerView.h"
#import "CHcir_Slider.h"


typedef NS_ENUM(NSInteger, ColorLampSwitch) {
    colorLampNoneClick,
    redLampClick,
    greenLampClick,
    blueLampClick,
    whiteLampClick
};



@interface LampVC ()<RSColorPickerViewDelegate,CHcirsliderDelegate>

//UI
@property (weak, nonatomic) IBOutlet UISlider *brightnessSlider;


//
@property (nonatomic,strong) LEDFunction *operationModel;


@end

@implementation LampVC
{
    RSColorPickerView *_colorPicker;
    CHcir_Slider *_cirSlider;
    
    NSDate *_oldTime;
    
    ColorLampSwitch currentColor;
}





- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
    
    [self initControlller];
   
    [self setupOperationModel];
}


- (void)setupOperationModel {
    
    _oldTime = [NSDate date];

    self.operationModel = [[LEDFunction alloc] init];
}



-(void)initUI{

//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];


    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}


-(void)initControlller{

    int width=ScreenWidth*0.7;
    
    
    CGRect rect = CGRectMake(0.15*ScreenWidth, ScreenHeight*0.15, width, width);
    _colorPicker = [[RSColorPickerView alloc] initWithFrame:rect];
    
    _colorPicker.cropToCircle = YES;
    _colorPicker.showLoupe = NO;
    [_colorPicker setDelegate:self];
    

    [self.view addSubview:_colorPicker];
    
    
    
    
    _cirSlider = [[CHcir_Slider alloc]init];
    _cirSlider.frame = rect;
    _cirSlider.startAngle = -90;
    _cirSlider.cutoutAngle = 180;
    _cirSlider.delegate = self;
    _cirSlider.backgroundColor = [UIColor clearColor];
    
    _cirSlider.progress1 = 0;
    
    
    [self.view addSubview:_cirSlider];
    
    
}







#pragma mark - RSColorPickerView delegate methods
- (void)colorPickerDidChangeSelection:(RSColorPickerView *)cp {
    
    CGFloat r, g, b, a;
    [[cp selectionColor] getRed:&r green:&g blue:&b alpha:&a];
    
    
//    NSString *colorDesc = [NSString stringWithFormat:@"rgba: %f, %f, %f, %f", r, g, b, a];
//    NSLog(@"%@", colorDesc);

    
    
    CGFloat slideValue = self.brightnessSlider.value;
    
    if (-[_oldTime timeIntervalSinceNow] > 0.08) {
        _oldTime = [NSDate date];
        
            [self.operationModel setLightColorWithRed:r*255*slideValue green:g*255*slideValue blue:b*255*slideValue white:0];
        
    }
    
}




- (IBAction)brightnessChange:(UISlider *)sender {
    
    [self colorPickerDidChangeSelection:_colorPicker];
    
}



- (IBAction)mainSwitch:(UIButton *)sender {
    

    sender.selected = !sender.selected;
    
    if (sender.selected) {
        
        
        
        
    }else{
    
        
        [self.operationModel setLightColorWithRed:0 green:0 blue:0 white:0];
    
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}



- (IBAction)whiteLampSwitch:(UIButton *)sender {
    
    
    sender.selected = !sender.selected;
}




- (IBAction)colorLampBtn:(UIButton *)sender {
    
    
    currentColor = sender.tag;
    
    switch (currentColor) {
        case redLampClick:
            
            [_colorPicker setSelectionColor:[UIColor redColor]];
            
            break;
            
        case greenLampClick:
            
            [_colorPicker setSelectionColor:[UIColor greenColor]];
            
            break;

        case blueLampClick:
            
            [_colorPicker setSelectionColor:[UIColor blueColor]];
            
            break;

        case whiteLampClick:
            
            [_colorPicker setSelectionColor:[UIColor whiteColor]];
            
            break;
        default:
            break;
    }
    
    
    
    self.brightnessSlider.value = 1;
    
    [self colorPickerDidChangeSelection:_colorPicker];
    
}





#pragma mark -  CHcir_Slider_Delegate
- (void)minIntValueChanged:(CGFloat)minIntValue{
    NSLog(@"minIntValue%f",minIntValue);
    
    
    
}
- (void)maxIntValueChanged:(CGFloat)maxIntValue{
    NSLog(@"maxIntValue%f",maxIntValue);
}





@end
