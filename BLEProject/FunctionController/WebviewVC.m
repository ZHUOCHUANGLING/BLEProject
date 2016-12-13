//
//  WebviewVC.m
//  BLEProject
//
//  Created by jp on 2016/12/5.
//  Copyright © 2016年 jp. All rights reserved.
//

#import "WebviewVC.h"
#import <AFNetworking.h>
#import "JPProgressHUD.h"

@interface WebviewVC ()
@property (weak, nonatomic) IBOutlet UIWebView *onlineMusicWebView;

@end

@implementation WebviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self.onlineMusicWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]]];
    
    self.onlineMusicWebView.scalesPageToFit = YES;
    
    
    [self openAFNObserveNetState];
    
}

-(void)openAFNObserveNetState{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager ] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case -1:
            //            NSLog(@"未知网络");
            break;
            case 0:
            //            NSLog(@"网络不可达");
            break;
            case 1:
            //            NSLog(@"GPRS网络");
            break;
            case 2:
            //            NSLog(@"wifi网络");
            break;
            default:
            break;
        }
        if(status ==AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi)
        {
            //            NSLog(@"有网");
        }else
        {
            //            NSLog(@"没有网");
            [JPProgressHUD showMessage:@"网络不可用"];
        }
    }];
    
    
    
}


@end
