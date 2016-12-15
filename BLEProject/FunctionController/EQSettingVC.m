//
//  EQSettingVC.m
//  BLEProject
//
//  Created by jp on 2016/11/28.
//  Copyright © 2016年 jp. All rights reserved.
//

#import "EQSettingVC.h"
#import "CustomEQVC.h"

@interface EQSettingVC ()


@property(nonatomic, strong)UIImageView *oldImageView;

@end

@implementation EQSettingVC
{
    
    
    EQFunction *eqOperation;
    __weak IBOutlet UIButton *_customBtn;
    
    

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [eqOperation synchronizeEQState];
}



- (void)viewDidLoad {
    [super viewDidLoad];
  
    
    [self initEQFunction];
    [self initUI];
    
}

-(void)initEQFunction{
    eqOperation = [[EQFunction alloc] init];
    
    
    
    //正确写法:获取到外设EQ通知(待测试后开启)
    __weak typeof(self) weakSelf = self;
    eqOperation.getEQ = ^(EQEffectType type){
        
        if (weakSelf.oldImageView) {
            weakSelf.oldImageView.highlighted = NO;
            UILabel *oldTitleLab = [weakSelf.view viewWithTag:_oldImageView.tag+1];
            oldTitleLab.textColor = [UIColor blackColor];
        }
        
        
        if (type < 6) {
            
 
            UIImageView *imageView = [weakSelf.view viewWithTag:type*2+1];
            imageView.highlighted = YES;
            
            
            UILabel *titleLab = [weakSelf.view viewWithTag:(imageView.tag+1)];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                titleLab.textColor = [UIColor colorWithRed:0 green:160/255.f blue:233/255.f alpha:1];
            });
            
            
            
            weakSelf.oldImageView = imageView;
            
            
        }
    
    };

}





-(void)initUI{

    _customBtn.layer.cornerRadius = margin;

}

- (IBAction)tapAction:(UITapGestureRecognizer *)sender {
    
    
    
    if (_oldImageView) {
        _oldImageView.highlighted = NO;
        UILabel *oldTitleLab = [self.view viewWithTag:_oldImageView.tag+1];
        oldTitleLab.textColor = [UIColor blackColor];
    }
    
    
    
    UIImageView *imageview = (UIImageView *)sender.view;
    imageview.highlighted = YES;
    
    UILabel *titleLab = [self.view viewWithTag:(sender.view.tag + 1)];
    titleLab.textColor = [UIColor colorWithRed:0 green:160/255.f blue:233/255.f alpha:1];
    
    _oldImageView = imageview;

    [eqOperation setEQWithEffect:sender.view.tag/2];
    
    
}





-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{


    if ([segue.identifier isEqualToString:@"CustomEQSegue"]) {
        
        CustomEQVC *cumstomEQVC = segue.destinationViewController;
        cumstomEQVC.eqOperation = eqOperation;
        
    }





}





@end
