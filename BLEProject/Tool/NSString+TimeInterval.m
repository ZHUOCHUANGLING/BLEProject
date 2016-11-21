//
//  NSString+TimeInterval.m
//  BLEProject
//
//  Created by jp on 2016/11/18.
//  Copyright © 2016年 jp. All rights reserved.
//

#import "NSString+TimeInterval.h"

@implementation NSString (TimeInterval)



+(NSString *)stringWithTimeInteral:(NSTimeInterval)timeInteral{
    
    NSInteger minute = (NSInteger)timeInteral/60;
    NSInteger second = (NSInteger)timeInteral%60;
    
    return [NSString stringWithFormat:@"%02ld:%02ld",minute ,second];
  
}

@end
