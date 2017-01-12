//
//  LeftSideVC.m
//  BLEProject
//
//  Created by jp on 2016/11/15.
//  Copyright © 2016年 jp. All rights reserved.
//

#import "LeftSideVC.h"
#import "UIViewController+MMDrawerController.h"
#import <AVFoundation/AVFoundation.h>
#import "FunctionDataManager.h"




static NSInteger CharacterCount = 21;



@interface LeftSideVC ()<UIAlertViewDelegate,UITextFieldDelegate>

@property(nonatomic, strong)NSMutableArray *modualIDArr;
@property (nonatomic, strong)NSMutableArray *modualNameArr;



@property (weak, nonatomic) IBOutlet UILabel *connectedLabel;

@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIButton *speakerImageBtn;

@end

@implementation LeftSideVC
{
    NSInteger selectedRow;

}



-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

    [self refreshUI];

}





- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self addObserver];

    [self initUI];
    
}

-(void)initUI{
    
    self.tableView.rowHeight = ROWHEIGHT;
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.view.frame];
    backgroundView.image = [UIImage imageNamed:@"侧背景"];
    
    self.tableView.backgroundView = backgroundView;
    
    selectedRow = 0;
    
}

-(void)initData{
    
    
    
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


-(void)addObserver{

    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    //监听A2DP拔插
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangedCallBack:) name:AVAudioSessionRouteChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadModualData:) name:DataInitializedCompleted object:nil];
    
}



-(void)refreshUI{

    self.footerView.frame = CGRectMake(self.footerView.x, self.footerView.y, ScreenWidth,ScreenHeight - 160 - _modualIDArr.count*ROWHEIGHT);
    
    if (DataManager.connectedPeripheral.name) {
        self.connectedLabel.text = DataManager.connectedPeripheral.name;
    }
    
    
    UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0]];
    selectedCell.selected = YES;
    

}





#pragma mark -  tableView_Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _modualIDArr.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.textLabel.text = _modualNameArr[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.imageView.image = [UIImage imageNamed:_modualNameArr[indexPath.row]];
    
    
    
    cell.selectedBackgroundView = [UIView new];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:40.f/255.f green:60.f/255.f blue:111.f/255.f alpha:1];
    
    
    
    return cell;
    
    
}



#pragma mark -  tableView_Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

    UITabBarController *tabbarVC = (UITabBarController *)self.mm_drawerController.centerViewController;
    
    tabbarVC.selectedIndex = indexPath.row;
    
    
    UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0]];
    
    selectedCell.selected = NO;
    
    selectedRow = indexPath.row;
    
    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];

}





#pragma mark -  DisConnectDevice


- (IBAction)disConnectDevice:(UIButton *)sender {
    
    [DataManager disconnectPeripheral];
    
    
#warning 第一版上架用
    UIViewController * scanVC = [[UIStoryboard storyboardWithName:@"FunctionVC" bundle:nil] instantiateViewControllerWithIdentifier:@"scanVC"];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:scanVC animated:YES completion:nil];
    });
    
}




#pragma mark - A2DP


-(void)audioRouteChangedCallBack:(NSNotification *)notification{
    
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    
    
    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
           
            [self.speakerImageBtn setBackgroundImage:[UIImage imageNamed:@"侧音箱连接状态"] forState: UIControlStateNormal];
            //            NSLog(@"耳机插入");
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:

            [self.speakerImageBtn setBackgroundImage:[UIImage imageNamed:@"侧音箱"] forState: UIControlStateNormal];
            //            NSLog(@"耳机拔出，停止播放操作");
            break;
        case AVAudioSessionRouteChangeReasonCategoryChange:
            // 即将播放监听
//            NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
    
    
}





- (IBAction)presentSetting:(UIButton *)sender {
    
    
    if (Deviece_Version >= 10) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{UIApplicationOpenURLOptionUniversalLinksOnly:@NO} completionHandler:nil];
    }else{
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        
    }
    
    
    
}




-(void)reloadModualData:(NSNotification *)notification{

    NSDictionary *modualArrDic = notification.userInfo;
    
    [_modualIDArr removeAllObjects];
    [_modualNameArr removeAllObjects];
    
    [_modualIDArr addObjectsFromArray: modualArrDic[@"modualIDArr"]];
    [_modualNameArr addObjectsFromArray: modualArrDic[@"modualNameArr"]];

    
    dispatch_async(dispatch_get_main_queue(), ^{

        [self.tableView reloadData];
        selectedRow = 0;
        
    });

    
}






















- (IBAction)changeDeviceNameAction:(id)sender {
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"修改蓝牙名" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    //添加textfield
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        //        textField.placeholder = @"登陆";

        //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
        
        
        //        textField.text=_bleManager.peripheral.name;
        
        textField.delegate = self;
        
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        
        
        
        [textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        

    }];
    
    
    
    
    
    UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        
        //存储修改前的名字
        //        UITableViewCell *cell = [self.Device_list cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_didSelectedRow inSection:0]];
        //        _oldName = cell.textLabel.text;
        
        
        
        
        if (alertController.textFields.count!=0) {
            
            
            //发送修改名字
            //            [self adjustChangedWithName:alertController.textFields.firstObject.text];
            
            //            [self changingName];
            
            
      
            
#warning 测试用
            [self disConnectDevice:nil];
            
            
            
            
        }
        
        
        
    }];
    
    
    
    
    
    
    
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"用户取消了登陆");
        
    }];
    
    
    /**
     *  添加交互按钮
     */
    [alertController addAction:cancleAction];
    [alertController addAction:commitAction];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}



























#pragma mark -  textfield监听和代理方法
//监听正在输入的内容
- (void)textFieldChanged:(UITextField *)textField {
    
    NSString *toBeString = textField.text;
    
    if (![self isInputRuleAndBlank:toBeString]) {
        textField.text = [self disable_emoji:toBeString];
        return;
    }
    NSString *lang = [[textField textInputMode] primaryLanguage]; // 获取当前键盘输入模式
    
    //简体中文输入,第三方输入法（搜狗）所有模式下都会显示“zh-Hans”
    if([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        //没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if(!position) {
            NSString *getStr = [self getSubString:toBeString];
            if(getStr && getStr.length > 0) {
                textField.text = getStr;
            }
        }
        
        
    } else{
        NSString *getStr = [self getSubString:toBeString];
        if(getStr && getStr.length > 0) {
            textField.text= getStr;
        }
    }
    
    
}



//判断输入框输入的是否符合否则不允许输入
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([self isInputRuleNotBlank:string] || [string isEqualToString:@""]) {//当输入符合规则和退格键时允许改变输入框
        return YES;
    }
    else {
        NSLog(@"超出字数限制");
        return NO;
    }
}



#pragma mark - 过滤方法
//第三方的键盘判断是否有特殊字符
//➋➌➍➎➏➐➑➒系统九宫格输入
- (BOOL)isInputRuleNotBlank:(NSString *)str {

    
    NSString *pattern = @"^[a-zA-Z\u4E00-\u9FA5\\d➋➌➍➎➏➐➑➒_/]*$";
    //    NSString *pattern = @"[`~!@#$%^&*+=|{}':;',\\[\\].<>~！@#￥%……&*（）+|{}【】‘；：”“’。，、？-_()-""]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];

    if (!isMatch) {
        [JPProgressHUD showMessage:@"请勿输入非法字符"];
    }
    return isMatch;
    
}

//系统键盘拼音输入中间有空格，用这个方法判断是否有特殊字符
- (BOOL)isInputRuleAndBlank:(NSString *)str {
    
    
    
    NSString *pattern = @"^[a-zA-Z\u4E00-\u9FA5\\d\\s_/]*$";
    //    NSString *pattern = @"[`~!@#$%^&*+=|{}':;',\\[\\].<>~！@#￥%……&*（）+|{}【】‘；：”“’。，、？-_()-""]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    
    if (!isMatch) {
        [JPProgressHUD showMessage:@"请勿输入非法字符"];
    }
    return isMatch;
    
}



//禁用emoji表情
- (NSString *)disable_emoji:(NSString *)text {
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}



//限制长度
-(NSString *)getSubString:(NSString*)string
{
    /// 第一种:三个字节一个中文
    //        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSInteger length = [data length];
    
    if (length > CharacterCount) {
        NSData *data1 = [data subdataWithRange:NSMakeRange(0, CharacterCount)];
        NSString *content = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];//注意：当截取CharacterCount长度字符时把中文字符截断返回的content会是nil
        
        //当把中文的三个字节中间某个截断了的时候就抛弃
        if (!content || content.length == 0) {
            
            data1 = [data subdataWithRange:NSMakeRange(0, CharacterCount - 1)];
            content =  [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
            
            if (!content || content.length == 0) {
                data1 = [data subdataWithRange:NSMakeRange(0, CharacterCount - 2)];
                content =  [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
            }
        }
        
        
        [JPProgressHUD showMessage:@"输入过长"];
        return content;
    }
    return nil;
    
    
    
    /// 第二种:按照个数进行判断
    //    if (string.length > CharacterCount) {
    //        NSLog(@"超出字数上限");
    //        _totalCharacterLabel.text = @"0";
    //        return [string substringToIndex:CharacterCount];
    //    }else {
    //        _totalCharacterLabel.text = [NSString stringWithFormat:@"%ld",(long)(CharacterCount - string.length)];
    //    }
    //    return nil;
    
}






@end
