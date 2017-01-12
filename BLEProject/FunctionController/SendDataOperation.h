//
//  SendDataOperation.h
//  BLEProject
//
//  Created by jp on 2017/1/10.
//  Copyright © 2017年 jp. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^sendDataFinishBlock)(BOOL isSuccess);


@interface SendDataOperation : NSObject

@property (nonatomic ,copy) sendDataFinishBlock sendDataSuccessBlock;
@property (nonatomic ,assign) CGFloat progress;

-(void)startPCBInteraction;
@end
