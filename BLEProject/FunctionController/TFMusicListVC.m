//
//  TFMusicListVC.m
//  BLEProject
//
//  Created by jp on 2016/12/27.
//  Copyright © 2016年 jp. All rights reserved.
//

#import "TFMusicListVC.h"
#import "MusicFunctionManger.h"

@interface TFMusicListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *songListTableView;



@end

@implementation TFMusicListVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTFMusicState];
}




-(void)initTFMusicState{
    
    __weak typeof(self) weakSelf = self;
    shareMusicOperation().listSongName = ^(NSString *songListName){
        
        [shareTFSongListArr() addObject:songListName];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.songListTableView reloadData];
        });

        
    };
    
}



- (IBAction)dismissVC:(UITapGestureRecognizer *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}




#pragma mark -  tableView_DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return shareTFSongListArr().count;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor clearColor];
        
        cell.selectedBackgroundView = [UIView new];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:26.f/255.f green:161.f/255.f blue:230.f/255.f alpha:1];
        cell.textLabel.highlightedTextColor = [UIColor whiteColor];
        cell.detailTextLabel.highlightedTextColor = [UIColor whiteColor];
    }
    
    
    
    
    return cell;
    
}





#pragma mark -  tableView_Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
        cell.textLabel.text = shareTFSongListArr()[indexPath.row];

        if (indexPath.row == self.currentIndex-1) {
            
            cell.selected = YES;
        }
        else {
            cell.selected = NO;
        }
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    self.currentIndex = indexPath.row+1;
    
    [shareMusicOperation() setPlaySongIndex:indexPath.row+1];
    
    [tableView reloadData];
    
    
}





- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y>=scrollView.contentSize.height-CGRectGetHeight(scrollView.frame)) {
        
        [shareMusicOperation() getSongList];
    }
}


@end
