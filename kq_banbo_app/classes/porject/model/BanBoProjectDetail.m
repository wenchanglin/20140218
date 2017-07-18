//
//  BanBoProjectDetail.m
//  kq_banbo_app
//
//  Created by hcy on 2016/11/30.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoProjectDetail.h"
@implementation BanBoProjectDetail
+(instancetype)instWithResp:(NSDictionary *)dict{
    BanBoProjectDetail *detail=[BanBoProjectDetail mj_objectWithKeyValues:dict];
    return detail;
}

+(NSDictionary *)mj_objectClassInArray{
    return @{@"result":@"BanBoProjectDetailInfo"};
}
-(NSString *)description{
    NSString *superDesc=[super description];
    return [NSString stringWithFormat:@"%@-subInfo:%@",superDesc,_result];
}
@end
@implementation BanBoProjectDetailInfo
-(NSString *)description{
    NSString *superDesc=[super description];
    return [NSString stringWithFormat:@"%@-%@",superDesc,[[self mj_keyValues] mj_JSONString]];
}
@end
@implementation BanBoProjectDetailCellObj
#pragma mark item
-(instancetype)init{
    if (self=[super init]) {
        self.cellHeight=[BanBoLayoutParam projectCellHeight];
    }
    return self;
}
-(NSString *)groupTitle{
    return @"";
}
-(id)sortKey{
    return @(self.data.Gid);
}
-(NSString *)reuseId{
    return [self cellClass];
}
-(NSString *)cellClass{
    return @"BanBoProjectListCell";
}
#pragma mark column
-(UIFont *)fontAtIndex:(NSInteger)idx{
    return [YZLabelFactory normalFont];
}
-(NSString *)titleAtIndex:(NSInteger)idx{
    BanBoProjectDetailInfo *info=self.data;
    switch (idx) {
        case 0:
            return info.GroupName;
            break;
        case 1:
            return [NSString stringWithFormat:@"%ld",(long)info.AtWorkToday];
            break;
        case 2:
            return [NSString stringWithFormat:@"%ld",(long)info.AtWorkYestoday];
            break;
        case 3:
            return [NSString stringWithFormat:@"%ld",(long)info.AtWork7Days];
            break;
        case 4:
            return [NSString stringWithFormat:@"%ld",(long)info.AtWork30Days];
            break;
        default:
            return @"不知道";
            break;
    }
}
#pragma mark desc
-(NSString *)description{
    NSString *superDesc=[super description];
    return [NSString stringWithFormat:@"%@-%@",superDesc,_data];
}

@end


