//
//  YZBaseViewController.h
//  YZWaimaiCustomer
//
//  Created by hcy on 16/9/1.
//  Copyright © 2016年 hcy@yz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface YZBaseViewController : UIViewController
/**
 *  子类在这个方法里返回view的背景色（默认是grayColor）
 *
 *  @return 想要的背景色
 */
-(UIColor *)YZViewBgColor;
@end
