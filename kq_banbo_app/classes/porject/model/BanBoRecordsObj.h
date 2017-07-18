//
//  BanBoRecordsObj.h
//  kq_banbo_app
//
//  Created by hcy on 2016/12/1.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoRespObj.h"
/**
 getrecord接口返回
 */
@interface BanBoRecordsObj : BanBoRespObj
+(instancetype)instWithResp:(NSDictionary *)resp;
@property(assign,nonatomic)NSInteger totoal;
@property(strong,nonatomic)NSArray *result;
@end
@interface BanBoRecordData : NSObject
@property(assign,nonatomic)int64_t AddTime;
@property(nonatomic,copy) NSString* Address;
@property(copy,nonatomic) NSString* CardId;
@property(assign,nonatomic)NSInteger ClientId;
@property(assign,nonatomic)NSInteger CurrCardNo;
@property(assign,nonatomic)NSInteger CurrWorkNo;
@property(assign,nonatomic)NSInteger Gid;
@property(nonatomic,copy) NSString* GroupName;
@property(nonatomic,assign) NSInteger sex;
@property(assign,nonatomic)NSInteger Uid;
@property(assign,nonatomic)NSInteger UserId;
@property(nonatomic,copy) NSString* UserName;
@property(nonatomic,copy) NSString* status;

@property(assign,nonatomic)NSInteger xuhao;
@end

@interface BanBoRecordCellObj : BanBoColumnCellObj
@property(strong,nonatomic)BanBoRecordData *data;
@end
