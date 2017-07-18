//
//  YZDateHelper.m
//  kq_banbo_app
//
//  Created by hcy on 2016/12/6.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "YZDateHelper.h"

@implementation YZDateHelper
+(NSInteger)monthByAddMonth:(NSInteger)month{
    NSDateComponents *comp=[[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:[NSDate new]];
    NSInteger currentMonth=comp.month;
    currentMonth+=month;
    if (currentMonth<0) {
        currentMonth=12+currentMonth;
    }
    NSInteger result=currentMonth%12;
    
    return result?result:12;
    
    
    
}
+(NSInteger)yeaderByAddYear:(NSInteger)year{
    NSDateComponents *comp=[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate new]];
    NSInteger currentYear=comp.year;
    return  currentYear+year;
}

@end
