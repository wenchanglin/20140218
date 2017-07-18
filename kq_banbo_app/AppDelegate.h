//
//  AppDelegate.h
//  kq_banbo_app
//
//  Created by hcy on 2016/11/23.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "FindFile/UIViewController+Swizzled.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
-(void)userLogin;
-(void)userLogout;
@end

