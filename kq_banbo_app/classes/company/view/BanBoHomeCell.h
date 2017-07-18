//
//  BanBoCompanyHomeCell.h
//  kq_banbo_app
//
//  Created by hcy on 2016/11/29.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "YZListHeader.h"

/**
 主页cell-base
 */
@interface BanBoHomeCell : YZListCell
@property(strong,nonatomic)id data;
/**
 分割线
 */
@property(strong,nonatomic)UIView *separView;

@end

/**
 主页cell-分公司
 */
@interface BanboHomeSubCompanyCell : BanBoHomeCell

@end

/**
 主页cell-工地
 */
@interface BanBoHomeProjectCell : BanBoHomeCell

@end
