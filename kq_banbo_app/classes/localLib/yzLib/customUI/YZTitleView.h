//
//  YZTitleView.h
//  kq_banbo_app
//
//  Created by hcy on 2016/12/1.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 方便用来显示在页面上的titleView
 */
@interface YZTitleView : UIView
-(void)showInNaviItem:(UINavigationItem *)item;
@property(copy,nonatomic)NSString *text;
@property(strong,nonatomic)UIFont *font;
@property(strong,nonatomic)UIColor *textColor;
@property(assign,nonatomic)NSInteger numberOfLines;
@end
