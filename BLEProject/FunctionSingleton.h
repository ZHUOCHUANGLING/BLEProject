//
//  FunctionSingleton.h
//  BLEProject
//
//  Created by jp on 2016/12/2.
//  Copyright © 2016年 jp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FunctionSingleton : NSObject


@property(nonatomic, strong)MusicFunction *musicOperation;


+(instancetype)shareFunction;


@end
