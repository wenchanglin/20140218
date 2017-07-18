//
//  BanBoCustomTabbarView.h
//  kq_banbo_app
//
//  Created by hcy on 2016/11/30.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BanBoCustomTabbarView;
@protocol BanboCustomTabbarDelegate<NSObject>
@optional
-(void)customBar:(BanBoCustomTabbarView *)tabbar toReport:(UIButton *)btn
;
-(void)customBar:(BanBoCustomTabbarView *)tabbar toAddBtn:(UIButton *)btn;

-(void)customBar:(BanBoCustomTabbarView *)tabbar toNVR:(UIButton *)btn;
@end
/**
 工地页面底部-那个假的 tabbar
 */
@interface BanBoCustomTabbarView : UIView

/**
 方便

 @return 帮你创建一个好的而已。origin还是需要自己设置
 */
+(instancetype)inst;


@property(weak,nonatomic)id<BanboCustomTabbarDelegate> delegate;
@end
