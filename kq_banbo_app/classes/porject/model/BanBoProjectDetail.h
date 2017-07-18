//
//  BanBoProjectDetail.h
//  kq_banbo_app
//
//  Created by hcy on 2016/11/30.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoRespObj.h"
#import "YZListHeader.h"
#import "HCYColumnLayoutManager.h"
/**
 工地页面-行数据
 */
@interface BanBoProjectDetail : BanBoRespObj
+(instancetype)instWithResp:(NSDictionary *)dict;
@property(strong,nonatomic)NSArray *result;
@end

/**
 每行的信息
 */
@interface BanBoProjectDetailInfo : NSObject
@property(copy,nonatomic)NSString *GroupName;
@property(copy,nonatomic)NSString *type;
@property(assign,nonatomic)NSInteger AtWork30Days;
@property(assign,nonatomic)NSInteger AtWork7Days;
@property(assign,nonatomic)NSInteger AtWorkToday;
@property(assign,nonatomic)NSInteger AtWorkYestoday;
@property(assign,nonatomic)NSInteger Gid;
@end

/**
 工地页面-cell模型
 */
@interface BanBoProjectDetailCellObj : BanBoColumnCellObj
@property(strong,nonatomic)BanBoProjectDetailInfo *data;
@end
