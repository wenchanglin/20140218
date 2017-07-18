//
//  YZCommonMacros.h
//  kq_banbo_app
//
//  Created by hcy on 2016/11/23.
//  Copyright © 2016年 yzChina. All rights reserved.
//
//常用宏定义
#ifndef YZCommonMacros_h
#define YZCommonMacros_h
#import "UIColor+HCY.h"
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define kVersionKey @"CFBundleShortVersionString"
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IOS9_LATER [[UIDevice currentDevice].systemVersion floatValue]>9
#define IS_IOS8 [[UIDevice currentDevice].systemVersion hasPrefix:@"8."]
#define IS_IOS7 [[UIDevice currentDevice].systemVersion hasPrefix:@"7."]
#define IS_IOS9 [[UIDevice currentDevice].systemVersion hasPrefix:@"9"]
#define IS_IOS10 [[UIDevice currentDevice].systemVersion hasPrefix:@"10"]

#define SCREEN_SCALE [UIScreen mainScreen].scale

#define dispatch_sync_main_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}

#define dispatch_async_main_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

#define superResponseToSelector(aSelector)\
[[[self class] superclass] instancesRespondToSelector: aSelector] \

#endif /* YZCommonMacros_h */
