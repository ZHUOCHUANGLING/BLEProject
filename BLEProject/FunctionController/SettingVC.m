//
//  SettingVC.m
//  BLEProject
//
//  Created by jp on 2016/11/16.
//  Copyright © 2016年 jp. All rights reserved.
//

#import "SettingVC.h"
#import "DownLoadFileOperation.h"
#import "SendDataOperation.h"
#import "UILabel+Extension.h"

@interface SettingVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *settingTableView;
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressSlider;


@end

@implementation SettingVC
{
    SendDataOperation *_sendDataOpt;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    

    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [_settingTableView reloadData];

}


-(void)initUI{
    
    self.settingTableView.tableFooterView = [UIView new];

    self.settingTableView.rowHeight = ScreenHeight * 0.08;
    
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem  = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    
    if (Device_IsPhone) {
        
    }else{
        //标题颜色和字体
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:25],NSForegroundColorAttributeName:[UIColor whiteColor]}];
        
    }
}






-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (Device_IsPhone) {
        UITableViewCell *OTACell = [tableView dequeueReusableCellWithIdentifier:@"OTAUpdate"];
        UITableViewCell *aboutUsCell  = [tableView dequeueReusableCellWithIdentifier:@"aboutUsCell"];
        
        if (indexPath.row == 0) {
            OTACell.imageView.image = [UIImage imageNamed:@"OTA升级"];
            OTACell.textLabel.text = @"OTA升级固件";
          
            return OTACell;
        }else{
            aboutUsCell = [tableView dequeueReusableCellWithIdentifier:@"aboutUsCell"];
            aboutUsCell.imageView.image = [UIImage imageNamed:@"关于我们"];
            aboutUsCell.textLabel.text = @"关于我们";
          
            return aboutUsCell;
        }

    }else{
        UITableViewCell *OTACell = [tableView dequeueReusableCellWithIdentifier:@"OTAUpdate"];
        UITableViewCell *aboutUsCell  = [tableView dequeueReusableCellWithIdentifier:@"aboutUsCell"];
        
        if (indexPath.row == 0) {
            OTACell.imageView.image = [UIImage imageNamed:@"OTA升级"];
            OTACell.textLabel.text = @"OTA升级固件";
            [OTACell.textLabel adjustFontSizeWithSize:20];
            return OTACell;
        }else{
            aboutUsCell = [tableView dequeueReusableCellWithIdentifier:@"aboutUsCell"];
            aboutUsCell.imageView.image = [UIImage imageNamed:@"关于我们"];
            aboutUsCell.textLabel.text = @"关于我们";
            [aboutUsCell.textLabel adjustFontSizeWithSize:20];
            return aboutUsCell;
        }

    }
    
    
    
    
    
    return nil;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        [self selectedOTAUpdate];
        

    }
    

}






-(void)selectedOTAUpdate{

    
    UIAlertController *isDownLoadAlert = [UIAlertController alertControllerWithTitle:@"是否下载升级文件用以进行OTA升级" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [isDownLoadAlert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"用户取消下载");
        
    }]];
    
    [isDownLoadAlert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        DownLoadFileOperation *operation = [[DownLoadFileOperation alloc] init];
        [operation startDownLoadWithVersion:@"123"];
        
        
    }]];
    
    [self presentViewController:isDownLoadAlert animated:YES completion:nil];
    
    
    
    
    
    
    
    
    
    
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:DownLoadFirmwareFileCompleted object:nil] subscribeNext:^(NSNotification *notification) {
        
        _sendDataOpt = [[SendDataOperation alloc] init];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"文件下载成功，是否进行升级" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"用户取消升级");
            
        }]];
        
        

        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            [_sendDataOpt startPCBInteraction];

            [RACObserve(_sendDataOpt, progress) subscribeNext:^(NSNumber *progress) {
                _progressSlider.progress = [progress floatValue];
                
            }];
            
            [UIApplication sharedApplication].keyWindow.rootViewController.view.userInteractionEnabled = NO;
          
            _progressView.hidden = NO;
            
            __weak typeof(_progressView) weakProgressView = _progressView;
            _sendDataOpt.sendDataSuccessBlock = ^(BOOL isSuccess){
                
                if (isSuccess) {
                    
                    [UIApplication sharedApplication].keyWindow.rootViewController.view.userInteractionEnabled = YES;
                    
                    weakProgressView.hidden = YES;
                    
                    dispatch_main_async_safe(^{
                        [JPProgressHUD showMessage:@"升级成功"];
                    });
                    
                }
                
                
            };
            
            
            
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        
        
        
    }];



}












@end
