//
//  YZDateHelper.h
//  kq_banbo_app
//
//  Created by hcy on 2016/12/6.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZDateHelper : NSObject

/**
 获得当前日期前后的月份的数字

 @param month 隔几个月份
 @return 月份
 */
+(NSInteger)monthByAddMonth:(NSInteger)month;


/**
 获得当前日期前后的年的数字

 @param year 隔几年
 @return 年
 */
+(NSInteger)yeaderByAddYear:(NSInteger)year;
@end
