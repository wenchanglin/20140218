//
//  YZTitleView+BanBo.m
//  kq_banbo_app
//
//  Created by hcy on 2016/12/29.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "YZTitleView+BanBo.h"
#import "BanBoUserInfoManager.h"
@implementation YZTitleView (BanBo)
+(instancetype)banbo_inst{
    
    YZTitleView *titleView=[YZTitleView new];
    UIFont *font= [YZLabelFactory bigFont];
    UIFont *bFont=[UIFont boldSystemFontOfSize:font.pointSize];
    titleView.font=bFont;
    titleView.textColor=[UIColor whiteColor];
    titleView.text=[[BanBoUserInfoManager sharedInstance] userPageTitle];
    
    return titleView;
    
}
@end
