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
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"aboutUsCell"];
    cell.imageView.image = [UIImage imageNamed:@"关于我们"];
    cell.textLabel.text = @"关于我们";


    return cell;
}







@end
