//
//  BanBoLayoutParam.h
//  kq_banbo_app
//
//  Created by hcy on 2016/11/30.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 一些会随着机器变化的页面布局参数
 */
@interface BanBoLayoutParam : NSObject
+(CGFloat)homeBtnMargin;
+(CGFloat)homeColorLabelMarginCenter;
+(CGFloat)projectHeaderCellHeight;
+(CGFloat)projectCellHeight;

+(CGFloat)shiminLineViewHeight;
+(CGFloat)shiminImagePercent;
@end
