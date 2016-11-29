//
//  SceneViewCell.m
//  BLEProject
//
//  Created by jp on 2016/11/28.
//  Copyright © 2016年 jp. All rights reserved.
//

#import "SceneViewCell.h"

@implementation SceneViewCell






-(void)setSelected:(BOOL)selected{


    if(selected){
        
        self.imageView.image = [UIImage imageNamed:self.selectedImageName];
        self.titleLab.textColor = [UIColor colorWithRed:0 green:160.f/255.f blue:233.f/255.f alpha:1];
    }else{
    
        self.imageView.image = [UIImage imageNamed:self.imageName];
        self.titleLab.textColor = [UIColor blackColor];
    }
    
}







@end
