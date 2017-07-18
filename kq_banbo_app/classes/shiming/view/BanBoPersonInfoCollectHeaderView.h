//
//  BanBoPersonInfoCollectHeaderView.h
//  kq_banbo_app
//
//  Created by hcy on 2016/12/8.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BanBoProject.h"

@class BanBoShiminUser;
/**
 个人信息采集。头
 */
@interface BanBoPersonInfoCollectHeaderView : UIView
-(void)refreshWithUser:(BanBoShiminUser *)user;
@property(strong,nonatomic)BanBoProject *project;
@end
