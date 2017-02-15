//
//  UILabel+Extension.m
//  lable
//
//  Created by 金港 on 16/7/13.
//  Copyright © 2016年 com.xiankexun. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)


- (void)adjustFontSizeWithSize:(NSInteger)size {
    
    self.font = [UIFont systemFontOfSize:size * [UIScreen mainScreen].bounds.size.height/ 736];
}


@end
