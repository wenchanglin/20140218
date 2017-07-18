//
//  YZLabelFactory.m
//  kq_banbo_app
//
//  Created by hcy on 2016/11/28.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "YZLabelFactory.h"
#import "YZColorTextLabel.h"
@implementation YZLabelFactory
+(UILabel *)blueLabel{
    UILabel *label=[UILabel new];
    
    label.font=[self normalFont];
    label.textColor=BanBoBlueColor;
    
    return label;
}
+(UIFont *)normalFont{
    if (IS_IPHONE_5) {
        //不然显示不下比较恶心。ip4什么的。让他们换手机把~
        return [UIFont systemFontOfSize:12.f];
    }else{
        return [UIFont systemFontOfSize:14.f];
    }
}
+(UIFont *)normal14Font{
    if (IS_IPHONE_5) {
        //不然显示不下比较恶心。ip4什么的。让他们换手机把~
        return [UIFont systemFontOfSize:14.f];
    }else{
        return [UIFont systemFontOfSize:16.f];
    }
}
+(UIFont *)bigFont{
    if (IS_IPHONE_5) {
        //不然显示不下比较恶心。ip4什么的。让他们换手机把~
        return [UIFont systemFontOfSize:16.f];
    }else{
        return [UIFont systemFontOfSize:18.f];
    }
}
+(UIFont *)taDiaoSectionFont
{
    if (IS_IPHONE_5) {
        return [UIFont boldSystemFontOfSize:18];
    }
    else
    {
        return [UIFont boldSystemFontOfSize:20];
    }
}
+(UIFont *)blodBigFont{
    if (IS_IPHONE_5) {
        //不然显示不下比较恶心。ip4什么的。让他们换手机把~
        return [UIFont boldSystemFontOfSize:16.f];
    }else{
        return [UIFont boldSystemFontOfSize:18.f];
    }
}

+(UILabel *)blackLabel{
    UILabel *label=[UILabel new];
    
    label.font=[self normalFont];
    label.textColor=[UIColor blackColor];
    
    return label;
}
+(UILabel *)grayLabel{
    UILabel *label=[UILabel new];
    
    label.font=[self normalFont];
    label.textColor=BanBoLabelGrayColor;
    
    return label;
}
+(YZColorTextLabel *)grayColorLabel{
    
    YZColorTextLabel *todayCountLabel=[YZColorTextLabel new];
    todayCountLabel.textColor=BanBoLabelGrayColor;
    return  todayCountLabel;
}
@end
