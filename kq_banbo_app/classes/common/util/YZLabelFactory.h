//
//  YZLabelFactory.h
//  kq_banbo_app
//
//  Created by hcy on 2016/11/28.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YZColorTextLabel;
@interface YZLabelFactory : NSObject
+(UILabel *)blueLabel;
+(UILabel *)blackLabel;
+(UILabel *)grayLabel;
+(YZColorTextLabel *)grayColorLabel;
+(UIFont *)taDiaoSectionFont;
+(UIFont *)normal14Font;
+(UIFont *)normalFont;
+(UIFont *)bigFont;
+(UIFont *)blodBigFont;
@end
