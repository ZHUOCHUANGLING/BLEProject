//
//  LampVC.m
//  BLEProject
//
//  Created by jp on 2016/11/15.
//  Copyright © 2016年 jp. All rights reserved.
//

#import "LampVC.h"
#import "SceneVC.h"
#import "RSColorPickerView.h"
#import "MSColorWheelView.h"
#import "MSColorUtils.h"
#import "CHcir_Slider.h"





typedef NS_ENUM(NSInteger, ColorLampButton) {
    colorLampNoneClick,
    redLampClick,
    greenLampClick,
    blueLampClick,
    whiteLampClick
};



@interface LampVC ()<CHcirsliderDelegate>

@property (weak, nonatomic) IBOutlet UIButton *mainSwitch;

@property (nonatomic,strong) LEDFunction *operationModel;


@end

@implementation LampVC
{
    MSColorWheelView *_colorWheelView;
    CHcir_Slider *_cirSlider;
    
    NSDate *_oldTime;
    
    ColorLampButton currentColor;
    
    NSMutableArray *_saveLampArr;
    CGFloat r, g, b, w, slideValue, a;
    HSB globalHSB;
    
}





- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    [self initControlller];
   
    [self setupOperationModel];
    
    
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSMutableArray *arr = [[NSUserDefaults standardUserDefaults]objectForKey:@"saveLampArr"];
    
    
    
    if (arr) {
        [_saveLampArr removeAllObjects];
        [_saveLampArr addObjectsFromArray:arr];
    }
    
    
    [self resetState];
    
    
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
    [self saveLampValue];
    [[NSUserDefaults standardUserDefaults] setObject:_saveLampArr forKey:@"saveLampArr"];
    
    [[NSUserDefaults standardUserDefaults] setBool:_mainSwitch.selected forKey:@"mainSwitchState"];
    
    
}







- (void)setupOperationModel {
    
    _oldTime = [NSDate date];

    self.operationModel = [[LEDFunction alloc] init];
    

    _saveLampArr = [NSMutableArray array];
    
    

}







-(void)initUI{

    
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}


-(void)initControlller{

    int width=ScreenWidth*0.7;
    int cirWidth = ScreenWidth *0.9;
    
    
    
    
    CGRect cirRect = CGRectMake(0.07 * ScreenWidth, 0.07*ScreenHeight, cirWidth, cirWidth);
    _cirSlider = [[CHcir_Slider alloc]init];
    _cirSlider.frame = cirRect;

    _cirSlider.startAngle = -90;
    _cirSlider.cutoutAngle = 180;
    _cirSlider.delegate = self;
    _cirSlider.backgroundColor = [UIColor clearColor];
    
    
    _cirSlider.tintColor = [UIColor whiteColor];
    [self.view addSubview:_cirSlider];

    

    
    
    CGRect rect = CGRectMake(0.2*ScreenWidth, ScreenHeight*0.15, width, width);
    
    _colorWheelView = [[MSColorWheelView alloc] initWithFrame:rect];
    _colorWheelView.center = CGPointMake(cirWidth/2, cirWidth/2);
    [_colorWheelView addTarget:self action:@selector(touchColorWheelView) forControlEvents:UIControlEventValueChanged | UIControlEventTouchUpInside|UIControlEventTouchCancel];
    
    _colorWheelView.layer.borderColor = [UIColor whiteColor].CGColor;
    _colorWheelView.layer.borderWidth = 5;
    _colorWheelView.layer.cornerRadius = width/2;
    
    [_cirSlider addSubview:_colorWheelView];
    
    


    
    
}







#pragma mark - MSColorWheelView methods
- (void)touchColorWheelView {
    
    
    HSB hsb = {_colorWheelView.hue, 1.0f,1.0f, 1.0f};
    
    RGB rgb = MSHSB2RGB(hsb);
    
    r = rgb.red;
    g = rgb.green;
    b = rgb.blue;

    self.mainSwitch.selected = YES;
    
    _colorWheelView.layer.borderColor = [UIColor colorWithRed:r green:g blue:b alpha:1].CGColor;
    
    [self adjustData];
    

}






-(void)adjustData{

    
    CGFloat cirSliderValue = _cirSlider.progress1;
    
    
    
    
    if (-[_oldTime timeIntervalSinceNow] > 0.1) {
        _oldTime = [NSDate date];
    
        
        
        w = 0;
        if (_colorWheelView.saturation == 0 && _colorWheelView.hue == 0) {
            r = 0;
            g = 0;
            b = 0;
            w = 1;
        }
        
        
        
        [self.operationModel setLightColorWithRed:r*255*cirSliderValue green:g*255*cirSliderValue blue:b*255*cirSliderValue white:w];
        
    }
    
    
    slideValue = _cirSlider.progress1;
    HSB _globalHSB = {_colorWheelView.hue,_colorWheelView.saturation,1.0f,1.0f};
    globalHSB = _globalHSB;
}









- (IBAction)mainSwitch:(UIButton *)sender {
    

    sender.selected = !sender.selected;
    [[NSUserDefaults standardUserDefaults] setBool:_mainSwitch.selected forKey:@"mainSwitchState"];
    
    if (sender.selected) {

        [self resetState];

        
    }else{
    
        [self saveLampValue];
        [self.operationModel setLightColorWithRed:0 green:0 blue:0 white:0];
    
    }
    
    
    

    
}





- (IBAction)colorLampBtn:(UIButton *)sender {
    
    
    HSB _hsb;
    
    currentColor = sender.tag;
    
    switch (currentColor) {
        case redLampClick:

            _hsb = MSRGB2HSB(MSRGBColorComponents([UIColor redColor]));
            
            
            break;
            
        case greenLampClick:
            
            _hsb = MSRGB2HSB(MSRGBColorComponents([UIColor greenColor]));
            
            break;

        case blueLampClick:
            
            _hsb = MSRGB2HSB(MSRGBColorComponents([UIColor blueColor]));
            
            break;

        case whiteLampClick:
            
            _hsb = MSRGB2HSB(MSRGBColorComponents([UIColor whiteColor]));
            
            break;
        default:
            break;
    }
    
    
    
    [_colorWheelView setHue:_hsb.hue];
    [_colorWheelView setSaturation:_hsb.saturation];
    
    _cirSlider.progress1 = 1;
    
    [self touchColorWheelView];
    
    _mainSwitch.selected = YES;
}





#pragma mark -  CHcir_Slider_Delegate
- (void)minIntValueChanged:(CGFloat)minIntValue{
//    NSLog(@"minIntValue%f",minIntValue);
    
    [self touchColorWheelView];
    
    _mainSwitch.selected = YES;
    
    
}
- (void)maxIntValueChanged:(CGFloat)maxIntValue{
    
    
    
}







#pragma mark -  DataOperation
-(void)saveLampValue{

    
    if (globalHSB.hue || globalHSB.saturation || slideValue) {
        [_saveLampArr removeAllObjects];
        [_saveLampArr addObject:@(globalHSB.hue)];
        [_saveLampArr addObject:@(globalHSB.saturation)];
        [_saveLampArr addObject:@(slideValue)];
    }
   
}



-(void)resetState{
    
    BOOL isSelected = [[NSUserDefaults standardUserDefaults] boolForKey:@"mainSwitchState"];
    
    if (_saveLampArr.count != 0) {
        
        [_colorWheelView setHue:[_saveLampArr[0] floatValue]];
        [_colorWheelView setSaturation:[_saveLampArr[1] floatValue]];
        _cirSlider.progress1 = [_saveLampArr[2] floatValue];
        
        if (isSelected) {
            [self touchColorWheelView];
        }
    }

}




-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([segue.identifier isEqualToString:@"presentSceneVC"]) {
        
        
        SceneVC *sceneVC = segue.destinationViewController;
        
        sceneVC.operationModel = self.operationModel;
        
    }



}






@end
