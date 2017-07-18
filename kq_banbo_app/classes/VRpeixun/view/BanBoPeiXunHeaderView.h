//
//  BanBoPeiXunHeaderView.h
//  kq_banbo_app
//
//  Created by banbo on 2017/6/26.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BanBoShiMinManager.h"
#import "BanBoShiminListItem.h"
@class BanBoPeiXunHeaderView;
@protocol BanBoPeiXunHeaderViewDelegate <NSObject>
-(void)headerViewConditionChanged:(BanBoPeiXunHeaderView *)headerView;
-(void)headerViewSearchBtnClicked:(BanBoPeiXunHeaderView *)headerView;
@end

@interface BanBoPeiXunHeaderView : UIView
-(void)setHeaderText:(NSString *)text;
-(BanBoBanzhuItem *)banzhuItem;
-(BanBoBanzhuItem *)xiaobanzhuItem;
-(NSString *)userText;
-(instancetype)initWithItem:(BanBoShiminListItem *)item projectName:(NSString *)projectName;

@property(weak,nonatomic)id<BanBoPeiXunHeaderViewDelegate> delegate;
@end
