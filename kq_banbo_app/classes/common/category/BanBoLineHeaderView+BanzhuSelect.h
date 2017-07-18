//
//  BanBoLineHeaderView+BanzhuSelect.h
//  kq_banbo_app
//
//  Created by hcy on 2017/1/3.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "BanBoLineHeaderView.h"
#import "BanBoBanZhuSelectView.h"
@interface BanBoLineHeaderView (BanzhuSelect)
@property(assign,nonatomic)BOOL enableBanzhuSelect;
@property(strong,nonatomic)BanBoBanzhuItem *item;
@property(strong,nonatomic)UIView *contentView;

@property(copy,nonatomic) BOOL(^BanzhuselectPrefixCheck)(BanBoLineHeaderView *view);
@property(copy,nonatomic)BanBoBanzhuSelectCompletion banzhuSelectCompletion;
@end
