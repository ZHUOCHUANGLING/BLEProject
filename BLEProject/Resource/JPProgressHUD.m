//
//  JPProgressHUD.m
//  BLEProject
//
//  Created by jp on 2016/12/9.
//  Copyright © 2016年 jp. All rights reserved.
//

#import "JPProgressHUD.h"

@implementation JPProgressHUD



+(void)showMessage:(NSString *)message{

    JPProgressHUD *currentHUD = [JPProgressHUD sharedView];
    
    
    if (currentHUD.superview) {
        
        
    }
    
    
    UILabel *currentLabel = [JPProgressHUD sharedLabel];
    UIWindow *currentWindow = [UIApplication sharedApplication].keyWindow;
    
    
    currentLabel.frame = CGRectMake(10, 10, currentWindow.bounds.size.width, 10);
    currentLabel.text = message;
    currentLabel.font = [UIFont systemFontOfSize:15];
    currentLabel.textColor = [UIColor whiteColor];
    currentLabel.textAlignment = NSTextAlignmentCenter;
    [currentLabel sizeToFit];
    

    currentHUD.center = currentWindow.center;
    currentHUD.bounds = CGRectMake(0, 0, currentLabel.bounds.size.width+20, currentLabel.bounds.size.height+20);
    currentHUD.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    currentHUD.layer.masksToBounds = YES;
    currentHUD.layer.cornerRadius = 10.0f;
    
    [currentHUD addSubview:currentLabel];
    [currentWindow addSubview:currentHUD];
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
        
        [currentHUD removeFromSuperview];
        
    });
    
    
    
  
    
}




+ (JPProgressHUD*)sharedView{
    static dispatch_once_t once;
    
    static JPProgressHUD *sharedView;
    

    dispatch_once(&once, ^{
        
        sharedView = [[self alloc] init];

    });

    return sharedView;
}


+ (UILabel *)sharedLabel{
    static dispatch_once_t once;
    
    static UILabel *shareLabel;
    
    
    dispatch_once(&once, ^{
        
        shareLabel = [[UILabel alloc] init];
        
    });
    
    return shareLabel;

}






@end
