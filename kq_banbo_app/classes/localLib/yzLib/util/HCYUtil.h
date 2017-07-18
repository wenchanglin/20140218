//
//  HCYUtil.h
//  NewYiContact
//
//  Created by hcy on 2/19/15.
//  Copyright (c) 2015 hcy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 *  工具类
 */
@interface HCYUtil : NSObject
+(CGRect)screenRect;
//提示
+(void)toastMsg:(NSString *)msg inView:(UIView *)view;
+(void)showProgressWithStr:(NSString *)str;
+(void)showProgressWithProcess:(CGFloat)process;
+(void)showProgress:(CGFloat)progress str:(NSString *)str;
+(BOOL)isShowProgress;
+(void)dismissProgress;
+(void)showErrorWithStr:(NSString *)errorStr;
+(void)showError:(NSError *)error;
//颜色图片
+(UIImage *)createImageWithColor:(UIColor *)color;
+(UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)imageSize;
//UI类
+(UIBarButtonItem *)getNilBarItemWithWidth:(CGFloat)width;
//类型转换
+(NSDate *)dateFromString:(NSString *)dateStr dateFormat:(NSString *)dateformat;
+(NSString *)dateStrFromDate:(NSDate *)date dateFormat:(NSString *)dateformat;
//计算
+(CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize attrs:(NSDictionary *)attris;
+(NSString *)wifiName;
/**
 获得一个float有几位小数字

 @param f 浮点
 @return 几位数字
 */
+(NSInteger)getDecimalCountForFloat:(CGFloat)f;

//文本处理
//+(NSString *)escapeWithStr:(NSString *)str;
+(NSString *)formatter4Sql:(NSString *)sql;

@end
