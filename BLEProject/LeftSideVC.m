//
//  LeftSideVC.m
//  BLEProject
//
//  Created by jp on 2016/11/15.
//  Copyright © 2016年 jp. All rights reserved.
//

#import "LeftSideVC.h"
#import "UIViewController+MMDrawerController.h"


@interface LeftSideVC ()

@end

@implementation LeftSideVC

- (void)viewDidLoad {
    [super viewDidLoad];
    



    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text =[NSString stringWithFormat:@"Left-Demo%ld",indexPath.row];
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UIViewController * fVC = [[UIStoryboard storyboardWithName:@"FunctionVC" bundle:nil] instantiateViewControllerWithIdentifier:@"lampVC"];
    
    if (indexPath.row == 1) {
        fVC = [[UIStoryboard storyboardWithName:@"FunctionVC" bundle:nil] instantiateViewControllerWithIdentifier:@"musicVC"];
    }
    
    self.mm_drawerController.centerViewController = fVC;
    
    
}


@end
