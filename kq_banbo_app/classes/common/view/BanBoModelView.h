//
//  BanBoModelView.h
//  kq_banbo_app
//
//  Created by hcy on 2016/12/5.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 一个带农蒙版效果的弹出view父类。
 containerView需要自己写。frame父类会算

 失败品。下次写好一点。这次就这样把
 
 */
@interface BanBoModelView : UIView
#pragma mark 外部调用
-(void)showInView:(UIView *)supView;
-(void)dismiss;

/**
 内容view
 */
@property(strong,nonatomic,readonly)UIView *containerView;
@property(assign,nonatomic)BOOL enableTapBgToClose;
#pragma mark 会调用子类实现的
/**
 点击空白区域的时候会调用的
 子类如果不重写。默认就是从父view移除
 
 @param tap 手势
 */
-(void)closeGestureTaped:(UITapGestureRecognizer *)tap;

#pragma mark 必须重写
/**
 渐变背景终值

 @return 值
 */
-(CGFloat)bgLayerShowVal;

/**
 渐变背景初始值

 @return 值
 */
-(CGFloat)bgLayerHiddenVal;

#pragma mark private
/**
 显示在view上

 @param superView 父view
 @param fromWhere CATransitionSubType
 */
-(void)showInView:(UIView *)superView fromWhere:(NSString *)fromWhere dur:(NSTimeInterval)dur;

/**
 从superview中消失

 @param toWhere 暂时没有用
 @param dur 时间
 */
-(void)dismissToWhere:(NSString *)toWhere dur:(NSTimeInterval)dur;

@end
