//
//  BanBoHomeTotal.h
//  kq_banbo_app
//
//  Created by hcy on 2016/11/29.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoRespObj.h"
@class BanBoCompanyTotal;
/**
 统计基础model
 */
@interface BanBoHomeTotal : BanBoRespObj
+(instancetype)instWithCompanyTotal:(NSDictionary *)dict;
+(instancetype)instWithProjectTotal:(NSDictionary *)dict;
@property(strong,nonatomic)BanBoCompanyTotal *result;
@end

/**
 公司统计信息
 */
@interface BanBoCompanyTotal : NSObject
@property(copy,nonatomic)NSString *name;
@property(assign,nonatomic)NSInteger TotalCheckToday;
@property(assign,nonatomic)NSInteger TotalCheckYestoday;
@end

/**
 工地统计信息
 */
@interface BanBoProjectTotal : BanBoCompanyTotal
@property(assign,nonatomic)NSInteger TotalWorker;
@property(assign,nonatomic)NSInteger WorkerNow;
@end
