//
//  BanBoReportListViewController.h
//  kq_banbo_app
//
//  Created by hcy on 2016/12/1.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoColumnListViewController.h"
@class BanBoProject;
/**
 工地-报道页面
 */
@interface BanBoReportListViewController : BanBoColumnListViewController
-(instancetype)initWithProject:(BanBoProject *)project;
@end
