//
//  BanBoProjectMainViewController.h
//  kq_banbo_app
//
//  Created by hcy on 2016/11/30.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoColumnListViewController.h"
#import "BanBoCustomTabbarView.h"
@class BanBoProject,BanBoProjectTotal;

/**
 工地主页
 */
@interface BanBoProjectMainViewController : BanBoColumnListViewController
// .因为要继承。所以把这几个放出来了
@property(strong,nonatomic,readonly)BanBoProject *project;
@property(strong,nonatomic,readonly)BanBoCustomTabbarView *customTabbar;
@property(strong,nonatomic,readonly)UIButton *logoutBtn;

-(void)refreshColorLabel:(BanBoProjectTotal *)data;
/**
 用工地id初始化

 @param project 工地对象
 @return 页面
 */
-(instancetype)initWithProject:(BanBoProject *)project;
@end
