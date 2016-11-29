//
//  SceneViewCell.h
//  BLEProject
//
//  Created by jp on 2016/11/28.
//  Copyright © 2016年 jp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SceneViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@property(nonatomic, strong)NSString *imageName;
@property(nonatomic, strong)NSString *selectedImageName;

@end
