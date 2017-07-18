//
//  YZColorTextLabel.h
//  kq_banbo_app
//
//  Created by hcy on 2016/11/28.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 带颜色的view。用来制作头
 */
@interface YZColorTextLabel : UILabel
-(void)refreshWithText:(NSString *)text Val:(NSString *)val valColor:(UIColor *)valueColor;
@end
