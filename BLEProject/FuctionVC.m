//
//  FuctionVC.m
//  BLEProject
//
//  Created by jp on 2016/11/12.
//  Copyright © 2016年 jp. All rights reserved.
//

#import "FuctionVC.h"

@interface FuctionVC ()

@end

@implementation FuctionVC

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self presentScanAction];

}






#pragma mark -  跳转搜索界面
-(void)presentScanAction{

    [self performSegueWithIdentifier:@"scanSegue" sender:nil];

}









@end
