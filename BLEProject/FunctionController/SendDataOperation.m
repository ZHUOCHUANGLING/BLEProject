//
//  SendDataOperation.m
//  BLEProject
//
//  Created by jp on 2017/1/10.
//  Copyright © 2017年 jp. All rights reserved.
//

#import "SendDataOperation.h"
#import "OTAModel.h"


@implementation SendDataOperation
{
    OTAFunction *_otaOperation;
}



-(instancetype)init{
    
    self = [super init];
    if (self) {
        _otaOperation = [[OTAFunction alloc] init];
        [self startUpadate];
        
    }
    return self;
}



-(void)startPCBInteraction{

    [_otaOperation startOTAHandleWithPolicy:OTAUpdatePolicyAll];

    
}



-(void)startUpadate{
    
    NSData *upgradeData = [NSData dataWithContentsOfFile:firmwarePath];
    
    NSLog(@"%ld",(long)upgradeData.length);
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(_otaOperation) weakOTAOperation = _otaOperation;
    
    _otaOperation.startResponse = ^(BOOL isPrepared){
        
        if (isPrepared) {
            
            [weakOTAOperation sendOTADataWithData:upgradeData andProgressBlock:^(CGFloat progress) {
                
                dispatch_main_async_safe(^{
                    
                    NSLog(@"%lf",progress);
                    weakSelf.progress = progress;
                    
                });
                
            } andCompleteBlock:^{
                
                [weakOTAOperation finishOTAUpdateWithData:upgradeData];
                
            }];
            
            
        }
        
    };
    
    
    _otaOperation.finishResponse = ^(BOOL isSucced){
        
        if (isSucced) {
            NSLog(@"传输成功");
            
            weakSelf.sendDataSuccessBlock(isSucced);
            
        }
        
    };
    
    
    
}



















@end
