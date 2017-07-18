//
//  UIColor+HCY.m
//  YZWaimaiCustomer
//
//  Created by hcy on 16/8/17.
//  Copyright © 2016年 hcy@yz. All rights reserved.
//

#import "UIColor+HCY.h"

@implementation UIColor (HCY)
+(UIColor *)hcy_colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha{
    return [UIColor colorWithRed:red/255.f green:green/255.f blue:blue/255.f alpha:alpha];
}
+(UIColor *)hcy_colorWithString:(NSString *)str{
    if (!str || [str isEqualToString:@""]) {
        return [UIColor blackColor];
    }
    unsigned red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 1;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&red];
    range.location = 3;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&green];
    range.location = 5;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&blue];
    
    UIColor *color= [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1];
    return color;
}
@end
