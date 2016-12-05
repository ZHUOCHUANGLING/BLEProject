//
//  SceneVC.m
//  BLEProject
//
//  Created by jp on 2016/11/22.
//  Copyright © 2016年 jp. All rights reserved.
//

#import "SceneVC.h"
#import "SceneViewCell.h"

@interface SceneVC ()<UICollectionViewDelegate, UICollectionViewDataSource>



@end

@implementation SceneVC
{
    
    NSMutableArray *_sceneDataArr;
    NSMutableArray *_sceneSelectedDataArr;
    

}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self initData];
    
    
}



-(void)initData{

    _sceneDataArr = [NSMutableArray arrayWithObjects:
                     @"彩虹",
                     @"心跳",
                     @"烛火",
                     @"快闪",
                     @"慢闪",
                     @"旋律",
                     @"呼吸",
                     @"绿色心情",
                     @"三色轮转",
                     @"红色渐变",
                     @"绿色渐变",
                     @"蓝色渐变",
                     nil];
    _sceneSelectedDataArr =[NSMutableArray arrayWithObjects:
                            @"彩虹S",
                            @"心跳S",
                            @"烛火S",
                            @"快闪S",
                            @"慢闪S",
                            @"情景旋律S",
                            @"呼吸S",
                            @"绿色心情S",
                            @"三色轮转S",
                            @"红色渐变",
                            @"绿色渐变",
                            @"蓝色渐变",
                            nil];

}



#pragma mark -  CollectionView_DataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return _sceneDataArr.count;


}



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SceneViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sceneCell" forIndexPath:indexPath];
    
    //model
    cell.imageName = _sceneDataArr[indexPath.row];
    cell.selectedImageName = _sceneSelectedDataArr[indexPath.row];
    
    //view
    cell.imageView.image = [UIImage imageNamed:_sceneDataArr[indexPath.row]];
    cell.titleLab.text =  _sceneDataArr[indexPath.row];
    
 

    
    return cell;



}





#pragma mark -  Collection_Delegate


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    [self.operationModel setLightSenceWithIndex:indexPath.row andType:0 andTrans:0];


}








@end
