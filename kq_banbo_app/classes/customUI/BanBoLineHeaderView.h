//
//  BanBoLineHeaderView.h
//  kq_banbo_app
//
//  Created by hcy on 2016/12/1.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 用于那种 时间  |   2015年这样的
 */
@interface BanBoLineHeaderView : UIView
/**
 宽度需要手动调节。默认蓝色13b8f5
 */
@property(strong,nonatomic)UILabel *leftLabel;

/**
 右边的label
 */
@property(strong,nonatomic)UILabel *rightLabel;
/**
 左右之间的分割线。会自动垂直居中。宽度是1
 */
@property(strong,nonatomic)UIView *verSeparView;

/**
 底部分割线
 */
@property(strong,nonatomic)UIView *bottomSeparView;


/**
 中间竖着的那根里leftLabel右边的距离
 *默认是5
 */
@property(assign,nonatomic)CGFloat verSeparLeftToLeftLabel;


/**
 右边的label距离中间分割线的距离
 *默认 20
 */
@property(assign,nonatomic)CGFloat rightLabelLeftToVerSepar;

/**
 中间那个垂直view的高度比。默认0.8
 */
@property(assign,nonatomic)CGFloat verSeparPercent;

@end
