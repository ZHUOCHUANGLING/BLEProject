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

@property(nonatomic, strong)NSMutableArray *modualIDArr;

@property (nonatomic, strong)NSMutableArray *modualNameArr;

@end

@implementation LeftSideVC
{
    NSInteger selectedRow;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initData];
    
}

-(void)initUI{
    
    self.tableView.rowHeight = ROWHEIGHT;
    //去掉空的分割线
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
    


}

-(void)initData{
    
    selectedRow = -1;
    
    
    _modualIDArr = [NSMutableArray arrayWithObjects:
                    @"lampVC",
                    @"musicVC",
                    @"fmVC",
                    @"auxVC",
                    @"timingVC",
                    @"settingVC", nil];
    
    _modualNameArr = [NSMutableArray arrayWithObjects:
                      @"彩灯",
                      @"音乐",
                      @"收音机",
                      @"AUX",
                      @"定时",
                      @"设置", nil];

}








#pragma mark -  tableView_Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _modualIDArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = _modualNameArr[indexPath.row];
    return cell;
}



#pragma mark -  tableView_Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row != selectedRow) {
        NSString *functionID = _modualIDArr[indexPath.row];
        
        UINavigationController * fVC = [[UIStoryboard storyboardWithName:@"FunctionVC" bundle:nil] instantiateViewControllerWithIdentifier:functionID];
        
        self.mm_drawerController.centerViewController = fVC;
        
        
        
        fVC.navigationBar.topItem.title = _modualNameArr[indexPath.row];
        
        
        [fVC.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18], NSForegroundColorAttributeName:[UIColor whiteColor]}];
        

        [self settingNavBar:fVC];
        
        selectedRow = indexPath.row;

    }
    
}


#pragma mark -  侧边栏按钮
-(void)settingNavBar:(UINavigationController *)nav{
    
    MMDrawerBarButtonItem * leftButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftButtonPress:)];
    leftButton.tintColor = [UIColor whiteColor];
    [nav.navigationBar.topItem setLeftBarButtonItem:leftButton animated:YES];
    
}

-(void)leftButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES
                                    completion:nil];
    
    
}



@end
