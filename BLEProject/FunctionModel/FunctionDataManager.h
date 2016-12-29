//
//  FunctionDataManager.h
//  BLEProject
//
//  Created by jp on 2016/12/23.
//  Copyright © 2016年 jp. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const DataInitializedCompleted;



@interface FunctionDataManager : NSObject

@property(nonatomic, strong)NSMutableArray *modualIDArr;

@property(nonatomic, strong)NSMutableArray *modualNameArr;

@property(nonatomic, strong)NSMutableArray *musicFunctionArr;



+(instancetype)shareManager;





@end
