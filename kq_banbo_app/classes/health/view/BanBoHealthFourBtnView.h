//
//  BanBoHealthFourBtnViews.h
//  kq_banbo_app
//
//  Created by hcy on 2016/12/12.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BanBoHealthFourBtnView;
@protocol BanBoHealthFourBtnsViewDelegate <NSObject>

/**
 按钮点击条用

 @param btnView view
 @param btnIdx 按钮索引
 */
-(void)fourBtnView:(BanBoHealthFourBtnView *)btnView clickBtnAtIdx:(NSInteger)btnIdx;
@end

/**
 都喜欢搞4个按钮。那么就抽一个喽
 0 1
 2 3
 用法
 1.new一个
 2.设置titles，itemMargin。lineMargin，delegate
 3.sizeToFit或者调用setBtnViewSize
 
 */
@interface BanBoHealthFourBtnView : UIView
@property(weak,nonatomic)id<BanBoHealthFourBtnsViewDelegate> delegate;
-(UIButton *)btnAtIdx:(NSInteger)idx;
@property(assign,nonatomic)CGFloat itemMargin;
@property(assign,nonatomic)CGFloat lineMargin;

/**
 设置一个大小。然后里面4个按钮根据大小以及margin。自己算大小

 @param size view大小
 */
-(void)setBtnViewSize:(CGSize)size;
/**
 设置title

 @param titles 必须是长度为4个title
 */
-(void)setTitles:(NSArray *)titles;

/**
 设置按钮背景色

 @param bgColors 背景色
 */
-(void)setBgColorArr:(NSArray *)bgColors;

/**
 设置按钮颜色

 @param titleColors 按钮颜色
 @param state 状态
 */
-(void)setTitleColors:(NSArray *)titleColors forState:(UIControlState)state;
@end

/**
 用于设置垂直btns
 */
@interface BanBoVerBtnsView : BanBoHealthFourBtnView

@end
