//
//  BanBoListViewController.h
//  kq_banbo_app
//
//  Created by hcy on 2016/11/28.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "YZListViewController.h"
#import "YZColorTextLabel.h"
/**
 list页面-基类
 */
@interface BanBoListViewController : YZListViewController

/**
 子类重写这个get
 */
@property(strong,nonatomic)UIView *topView;

/**
 数据表单的frame

 @return frame
 */
-(CGRect)banbo_dataTableFrame;

@end
