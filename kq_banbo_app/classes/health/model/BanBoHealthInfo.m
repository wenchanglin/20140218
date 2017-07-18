//
//  BanBoPersonInfo.m
//  kq_banbo_app
//
//  Created by hcy on 2016/12/8.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoHealthInfo.h"

@implementation BanBoHealthInfo
-(NSString *)titleAtIndex:(NSInteger)idx{
    
    switch (idx) {
        case 0:
        {
            return self.projectName;
        }
            break;
        case 1:
        {
            return self.statusStr;
        }
            break;
        case 2:
        {
            return self.updateDateStr;
        }
            break;
        case 3:
        {
            return @" 采 集 ";
        }
            break;
        default:
            break;
    }
    return @"";
}
-(NSString *)cellClass{
    return @"BanBoHealthInfoListCell";
}
-(UIFont *)fontAtIndex:(NSInteger)idx{
    return self.font?:[YZLabelFactory normalFont];
}
@end
