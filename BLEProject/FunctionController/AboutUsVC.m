//
//  AboutUsVC.m
//  BLEProject
//
//  Created by jp on 2016/12/7.
//  Copyright © 2016年 jp. All rights reserved.
//

#import "AboutUsVC.h"

@interface AboutUsVC ()
@property (weak, nonatomic) IBOutlet UIWebView *aboutUsWebView;

@end

@implementation AboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self.aboutUsWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.sancochip.com/index.asp"]]];
    self.aboutUsWebView.scalesPageToFit = YES;
    
}


@end
