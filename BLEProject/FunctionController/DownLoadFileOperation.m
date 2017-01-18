//
//  DownLoadFileOperation.m
//  BLEProject
//
//  Created by jp on 2017/1/9.
//  Copyright © 2017年 jp. All rights reserved.
//

#import "DownLoadFileOperation.h"
#import <AFNetworking.h>
#import "OTAModel.h"

NSString *const DownLoadFirmwareFileCompleted = @"DownLoadFirmwareFileCompleted";

@interface DownLoadFileOperation()
@property(nonatomic, strong)AFHTTPSessionManager * httpManager;


@end



@implementation DownLoadFileOperation


-(instancetype)init{
    
    self = [super init];
    if (self) {
        self.httpManager = [AFHTTPSessionManager manager];

    }

    return self;
}




-(void)startDownLoadWithVersion:(NSString *)version{
    
    [self checkVersion:version];
   
}



-(void)checkVersion:(NSString *)version{
    
    _httpManager.requestSerializer = [AFJSONRequestSerializer serializer];
    _httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    NSString * urlString = [@"http://192.168.1.71:8080/M1/checkVersion?version=" stringByAppendingString:version];
    
    
    
    [_httpManager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        NSLog(@"%@",responseObject);
        
        NSDictionary * responseDict = responseObject;
        
        
        if ([responseDict[@"code"] integerValue] == 0) {
            
            NSString * latestVersionStr = responseDict[@"result"][@"version"];
            [latestVersionStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [self downLoadFileWithVersion:latestVersionStr];
            
        }else{
            NSLog(@"No New Version");
        
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"CheckVersionError--%@",error);
        
    }];


}







-(void)downLoadFileWithVersion:(NSString *)latestVersion{
    
    _httpManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSString * downLoadFileStr = [@"http://192.168.1.71:8080/M1/download?id=" stringByAppendingString:latestVersion];
    
#warning 测试用
    downLoadFileStr = @"http://192.168.1.71:8080/M1/download?id=9";
    
    [_httpManager GET:downLoadFileStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSData *firmwareFile = responseObject;
        
        [firmwareFile writeToFile:firmwarePath atomically:YES];
        
        NSLog(@"%ld",(long)firmwareFile.length);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:DownLoadFirmwareFileCompleted object:nil];

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"DownLoadFileError--%@",error);
        
    }];
    
    

}






@end
