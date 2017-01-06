//
//  SettingVC.m
//  BLEProject
//
//  Created by jp on 2016/11/16.
//  Copyright © 2016年 jp. All rights reserved.
//

#import "SettingVC.h"


@interface SettingVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *settingTableView;

@end

@implementation SettingVC


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
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

   
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
    


    return nil;
}







@end
