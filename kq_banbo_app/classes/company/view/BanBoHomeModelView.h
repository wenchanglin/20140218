//
//  BanBoHomeModelView.h
//  kq_banbo_app
//
//  Created by hcy on 2016/12/1.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoModelView.h"
@class BanBoHomeModelView;
@protocol BanBoHomeModelViewActionDelegate <NSObject>
//action
@optional
-(void)toShimin:(UIButton *)btn;
-(void)toSuShe:(UIButton *)btn;
-(void)toPeixun:(UIButton *)btn;
@end



@interface BanBoHomeModelView : BanBoModelView
-(void)showInView:(UIView *)supView;
/**
 default is YES
 */
@property(assign,nonatomic)BOOL dismissAfterClick;
@property(weak,nonatomic)id<BanBoHomeModelViewActionDelegate> actionDelegate;
@end
