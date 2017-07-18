//
//  BanBoRecordsObj.m
//  kq_banbo_app
//
//  Created by hcy on 2016/12/1.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoRecordsObj.h"

@implementation BanBoRecordsObj
+(instancetype)instWithResp:(NSDictionary *)resp{
    BanBoRecordsObj *record=[BanBoRecordsObj mj_objectWithKeyValues:resp];
    
    NSDictionary *resultDict=resp[@"result"];
    id totalVal=resultDict[@"total"];
    if ([totalVal isKindOfClass:[NSNumber class]]) {
        record.totoal=[totalVal integerValue];
    }
    NSArray *listVal=resultDict[@"list"];
    if (listVal.count) {
        NSArray *dataArr=[BanBoRecordData  mj_objectArrayWithKeyValuesArray:listVal];
        record.result=dataArr;
    }
    
    return record;
    
}
@end
@implementation BanBoRecordData



@end
@implementation BanBoRecordCellObj
-(NSString *)cellClass{
    return @"BanBoReportListCell";
}
-(NSString *)reuseId{
    return [self cellClass];
}
#pragma mark column
-(NSString *)titleAtIndex:(NSInteger)idx{
    BanBoRecordData *data= self.data;
    switch (idx) {
        case 0:
        {
            return [NSString stringWithFormat:@"%ld",(long)data.xuhao];
        }
            break;
        case 1:
        {
            return [NSString stringWithFormat:@"%ld",(long)data.CurrWorkNo];
        }
            break;
        case 2:
        {
            return data.UserName;
        }
            break;
        case 3:
        {
            return data.GroupName;
        }
            break;
        case 4:
        {
            if ([data.status isEqualToString:@"Waiting"]) {
                return @"同步中";
            }else{
                return @"同步完成";
            }
        }
            break;
        case 5:
        {
            NSDate*date=[NSDate dateWithTimeIntervalSince1970:data.AddTime/1000];
            return [HCYUtil dateStrFromDate:date dateFormat:@"YYYY-MM-dd"];
        }
            break;
        case 6:
        {
            
        }
            break;
        default:
            break;
    }
    return @"";
}
@end
