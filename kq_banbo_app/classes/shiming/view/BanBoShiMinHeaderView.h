//
//  BanBoShiMinHeaderView.h
//  kq_banbo_app
//
//  Created by hcy on 2016/12/5.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BanBoShiMinManager.h"
@class BanBoShiminListItem,BanBoImageHeaderView,BanBoBanzhuItem,BanBoShiMinHeaderView;
@protocol BanBoShiminHeaderViewDelegate <NSObject>
-(void)headerViewConditionChanged:(BanBoShiMinHeaderView *)headerView;
-(void)headerViewSearchBtnClicked:(BanBoShiMinHeaderView *)headerView;
@end
/**
 实名制6个页面头上的view
 */
@interface BanBoShiMinHeaderView : UIView
-(void)setHeaderText:(NSString *)text;
-(BanBoBanzhuItem *)banzhuItem;
-(BanBoBanzhuItem *)xiaobanzhuItem;
-(NSString *)userText;
-(instancetype)initWithItem:(BanBoShiminListItem *)item projectName:(NSString *)projectName;

@property(weak,nonatomic)id<BanBoShiminHeaderViewDelegate> delegate;
@end
