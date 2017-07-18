//
//  BanBoNewReportView.h
//  kq_banbo_app
//
//  Created by hcy on 2016/12/27.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BanBoCardNumberView.h"

@class IDCardInfo;
/**
 新增报道-信息展示1
 */
@interface BanBoNewReportView : UIView
@property(assign,nonatomic,readonly)NSInteger groupId;
@property(assign,nonatomic,readonly)NSInteger subGroupId;
@property(strong,nonatomic)BanBoCardNumberView *numView;
@property(strong,nonatomic)UIImageView *iconView;
@property(assign,nonatomic)CGFloat lineLeft;
-(void)refreshWithData:(IDCardInfo *)data;

/**
 有没有头像

 @return 有没有头像
 */
-(BOOL)haveImage;
/**

 */
@property(strong,nonatomic)UIView *contentView;
@end
