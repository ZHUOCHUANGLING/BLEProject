//
//  FunctionDataManager.m
//  BLEProject
//
//  Created by jp on 2016/12/23.
//  Copyright © 2016年 jp. All rights reserved.
//

#import "FunctionDataManager.h"

NSString *const DataInitializedCompleted = @"InitializedCompleted";

@implementation FunctionDataManager


static FunctionDataManager *_instance;

+(void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[FunctionDataManager alloc] init];
    });
}


+(instancetype)shareManager{
    
    return _instance;
}


-(NSMutableArray *)modualIDArr{

    if (!_modualIDArr) {
        _modualIDArr = [NSMutableArray array];
    }
    
    return _modualIDArr;
}

-(NSMutableArray *)modualNameArr{
    
    if (!_modualNameArr) {
        _modualNameArr = [NSMutableArray array];
    }
    return _modualNameArr;
}


-(NSMutableArray *)musicFunctionArr{
    if (!_musicFunctionArr) {
        _musicFunctionArr = [NSMutableArray array];
    }
    return _musicFunctionArr;

}




-(instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        [self setUpFunctionModelArr];
        
        [self addObserver];
    }
    
    return self;
}



-(void)setUpFunctionModelArr{
    
    
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"FunctionData" ofType:@"json"];
    
    NSData *functionData = [[NSData alloc] initWithContentsOfFile:jsonPath];
    
    NSDictionary *functionDic = [NSJSONSerialization JSONObjectWithData:functionData options:NSJSONReadingMutableContainers error:nil];
    
    
    [self.modualIDArr addObjectsFromArray:functionDic[@"modualID"]];
    [self.modualNameArr addObjectsFromArray:functionDic[@"modualName"]];
    

}






-(void)addObserver{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(centralReceiveNotFoundCorrespondMsg:) name:BLENotFoundCorrespondMsgNotification object:nil];
}



-(void)centralReceiveNotFoundCorrespondMsg:(NSNotification *)notification{
    
    

    
    
    if ([notification.userInfo[@"characteristic"] isEqualToString:@"FFF1"]) {
    
        NSData *data =notification.userInfo[@"data"];
        Byte *bytes = (Byte *)[data bytes];
        
//        Byte bytes[] = {0x00,0x00,0x00,0x00,0x00,0x01,0x00,0x01,0x00,0x01,0x01};
        
        
        
        //music mode
        if (bytes[6] || bytes[7]) {
            [self.musicFunctionArr addObject:@(bytes[6])];
            [self.musicFunctionArr addObject:@(bytes[7])];
        }
        
        
        
        for (NSInteger i=_modualIDArr.count-1 ; i>=0; i--) {
            
            if (!bytes[i+5]) {
                
                if (i==0) {
                    
                    [_modualIDArr removeObjectAtIndex:i];
                    [_modualNameArr removeObjectAtIndex:i];
                    
                }else if ((i==2)&&(!bytes[6])){
                    
                    [_modualIDArr removeObjectAtIndex:1];
                    [_modualNameArr removeObjectAtIndex:1];
                    
                }else if (i>2){
                    
                    [_modualIDArr removeObjectAtIndex:i-1];
                    [_modualNameArr removeObjectAtIndex:i-1];
                    
                    
                }
                
            }
        }
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:DataInitializedCompleted object:nil userInfo:@{@"modualIDArr":self.modualIDArr,@"modualNameArr":_modualNameArr,@"musicFunctionArr":self.musicFunctionArr}];
        
    }
    
    
  
    
}







@end
