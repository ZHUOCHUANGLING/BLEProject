//
//  UIView+RotateAnimation.m
//  BLEProject
//
//  Created by jp on 2016/12/12.
//  Copyright © 2016年 jp. All rights reserved.
//

#import "UIView+RotateAnimation.h"

@implementation UIView (RotateAnimation)

-(void)rotate360DegreeWithImageView:(CGFloat)speed{
    
    CABasicAnimation *rotationAnimation = (CABasicAnimation *)[self.layer animationForKey:@"rotationAnimation"];
    
    
    CFTimeInterval pausedTime = [self.layer timeOffset];
    self.layer.speed = 1.0f;
    self.layer.timeOffset = 0.0f;
    self.layer.beginTime = 0.0f;
    CFTimeInterval timeSincePause = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.layer.beginTime = timeSincePause;
    
    
    if (rotationAnimation) {
        
    }else{
        
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
        rotationAnimation.duration = 10/speed;
        rotationAnimation.repeatCount = MAXFLOAT;
        
        rotationAnimation.removedOnCompletion = NO;
        rotationAnimation.fillMode = kCAFillModeBackwards;
        
        [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    }
   

    
    
    
    
    
    
    
    
    
}

-(void)stopRotate{
    
    CFTimeInterval pausedTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.layer.speed = 0.0;
    self.layer.timeOffset = pausedTime;
    
    
}
@end
