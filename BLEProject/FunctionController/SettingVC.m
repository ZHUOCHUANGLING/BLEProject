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


-(void)initUI{
    
    self.settingTableView.tableFooterView = [UIView new];

    self.settingTableView.rowHeight = ScreenHeight * 0.08;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell"];

    
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"版权说明"];
        cell.textLabel.text = @"版权说明";
    }else if(indexPath.row == 1){
    
        cell.imageView.image = [UIImage imageNamed:@"关于我们"];
        cell.textLabel.text = @"关于我们";
    
    }
    
    
    
    
    
    return cell;
}


@end
