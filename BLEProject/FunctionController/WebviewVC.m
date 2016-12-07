//
//  WebviewVC.m
//  BLEProject
//
//  Created by jp on 2016/12/5.
//  Copyright © 2016年 jp. All rights reserved.
//

#import "WebviewVC.h"

@interface WebviewVC ()
@property (weak, nonatomic) IBOutlet UIWebView *onlineMusicWebView;

@end

@implementation WebviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.onlineMusicWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]]];
    
    
}



@end
