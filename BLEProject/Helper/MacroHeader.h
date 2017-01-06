//
//  MacroHeader.h
//  BLEProject
//
//  Created by jp on 2016/11/12.
//  Copyright © 2016年 jp. All rights reserved.
//

#ifndef MacroHeader_h
#define MacroHeader_h



//BLE
#define DataManager [DataStreamManager sharedManager]

#define Deviece_Version [[[UIDevice currentDevice] systemVersion] floatValue]

#define Device_IsPhone UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone

//
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight  [UIScreen mainScreen].bounds.size.height
#define margin 15
#define ROWHEIGHT ScreenHeight*0.09




//主线程异步队列
#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}



#endif /* MacroHeader_h */
