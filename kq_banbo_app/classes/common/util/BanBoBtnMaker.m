//
//  BanBoBtnMaker.m
//  kq_banbo_app
//
//  Created by hcy on 2017/1/17.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "BanBoBtnMaker.h"
#import <UIKit/UIKit.h>
@implementation BanBoBtnMaker
+(UIButton *)sectionSelectBtnWithNormalTitle:(NSString *)title{
    UIButton *btn=[UIButton new];
    btn.titleLabel.font=[YZLabelFactory normalFont];
    [btn setBackgroundImage:[HCYUtil createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [btn setBackgroundImage:[self selectSelectBgImageForSelected] forState:UIControlStateSelected];
    btn.adjustsImageWhenHighlighted=NO;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:BanBoBlueColor forState:UIControlStateSelected];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn sizeToFit];
    btn.height=30;

    return btn;
}
static UIImage *sectionSelectBgImage;
+(UIImage *)selectSelectBgImageForSelected{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat width=SCREEN_WIDTH;
        CGFloat height=44;
        
        UIGraphicsBeginImageContext(CGSizeMake(width, height));
        
        CGContextRef context=  UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        [[UIColor whiteColor] setFill];
        CGContextFillRect(context, CGRectMake(0, 0, width, height));
        CGContextRestoreGState(context);
        
        CGContextSaveGState(context);
        [BanBoBlueColor set];
        
        CGMutablePathRef path=CGPathCreateMutable();
        CGPathAddRect(path, NULL, CGRectMake(0, height-1, width, 1));
        CGContextAddPath(context, path);
        CGContextFillPath(context);
        CGContextRestoreGState(context);
        
        UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
        
        CGPathRelease(path);
        CGContextRelease(context);
        sectionSelectBgImage=image;
    });
    return sectionSelectBgImage;
    
}
@end
