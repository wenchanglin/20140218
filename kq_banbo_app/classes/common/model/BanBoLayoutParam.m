//
//  BanBoLayoutParam.m
//  kq_banbo_app
//
//  Created by hcy on 2016/11/30.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoLayoutParam.h"

@implementation BanBoLayoutParam
+(CGFloat)homeBtnMargin{
    if (IS_IPHONE_5) {
        return 10;
    }else if (IS_IPHONE_6){
        return  15;
    }else{
        //6p了把
        return 20;
    }
}
+(CGFloat)homeColorLabelMarginCenter{
    return 11.5;
}
+(CGFloat)projectCellHeight{
    return 38.f;
}
+(CGFloat)projectHeaderCellHeight{
    return 48.f;
}

+(CGFloat)shiminLineViewHeight{
    return 41.f;
}
+(CGFloat)shiminImagePercent{
    return .6;
}
@end
