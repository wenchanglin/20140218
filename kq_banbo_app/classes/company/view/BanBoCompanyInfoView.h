//
//  BanBoCompanyInfoView.h
//  kq_banbo_app
//
//  Created by hcy on 2016/11/28.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 公司信息
 */
@interface BanBoCompanyInfoView : UIView

/**
 公司名称
 */
@property(copy,nonatomic)NSString *companyName;

/**
 在建工程
 */
@property(assign,nonatomic)NSInteger projectCount;

/**
 设备
 */
@property(assign,nonatomic)NSInteger deviceCount;

/**
 考勤
 */
@property(assign,nonatomic)NSInteger kaoqinCount;
@end
