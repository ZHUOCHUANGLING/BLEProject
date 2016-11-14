//
//  FunctionTabbarVC.m
//  BLEProject
//
//  Created by jp on 2016/11/14.
//  Copyright © 2016年 jp. All rights reserved.
//

#import "FunctionTabbarVC.h"

@interface FunctionTabbarVC ()

@end

@implementation FunctionTabbarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self presentScanAction];
    
    
}



#pragma mark -  跳转搜索界面
-(void)presentScanAction{
    
    [self performSegueWithIdentifier:@"scanSegue" sender:nil];
    
}



@end
