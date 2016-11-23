//
//  SceneVC.m
//  BLEProject
//
//  Created by jp on 2016/11/22.
//  Copyright © 2016年 jp. All rights reserved.
//

#import "SceneVC.h"
#import "SceneCollectionCell.h"

@interface SceneVC ()<UICollectionViewDelegate, UICollectionViewDataSource>
@end

@implementation SceneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
   
    
    
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return 9;


}



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    SceneCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sceneCell" forIndexPath:indexPath];
    
    
    
    return cell;



}

@end
