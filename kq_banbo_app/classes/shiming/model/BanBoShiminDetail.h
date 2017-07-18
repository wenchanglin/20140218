//
//  BanBoShiminUser.h
//  kq_banbo_app
//
//  Created by hcy on 2016/12/6.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoRespObj.h"
#import "YZListHeader.h"
#import "HCYColumnLayoutManager.h"
#import "BanBoShiMinManager.h"//比较坑爹。后面把枚举换个地方放
/**
 实名制那6个页面的详情
 */
@interface BanBoShiminDetail : BanBoRespObj
@property(strong,nonatomic)NSArray *result;
@end
@interface BanBoShiminUser : NSObject
/**
 *
 */
@property(nonatomic,assign) CGFloat PayLastMonth;
/**
 *
 */
@property(nonatomic,assign) CGFloat PayThisMonth;
/**
 *
 */
@property(nonatomic,assign) CGFloat PayYear;

/**
 *
 */
@property(nonatomic,assign) NSInteger Uid;
/**
 *
 */
@property(nonatomic,assign) NSInteger UserId;
/**
 *
 */
@property(nonatomic,copy) NSString* UserName;
/**
 *
 */
@property(nonatomic,assign) NSInteger WorkNo;
//花名册
/**
 *
 */
@property(nonatomic,copy) NSString* EnterDate;
/**
 *
 */
@property(nonatomic,assign) NSInteger GroupId;

/**
 *
 */
@property(nonatomic,copy) NSString* GroupName;
/**
 *
 */
@property(nonatomic,assign) NSInteger SubGroupId;
/**
 *
 */
@property(nonatomic,copy) NSString* SubGroupName;
//信息管理
/**
 *
 */
@property(nonatomic,copy) NSString* ContractDate;

/**
 *
 */
@property(nonatomic,copy) NSString* InsuranceDate;
//next
/**
 *
 */
@property(nonatomic,assign) NSInteger CheckLastMonth;
/**
 *
 */
@property(nonatomic,assign) NSInteger CheckThisMonth;
/**
 *
 */
@property(nonatomic,assign) NSInteger CheckYear;
//银行
/**
 *
 */
@property(nonatomic,copy) NSString* BankCardNo;
/**
 *
 */
@property(nonatomic,copy) NSString* BankName;
//健康
/**
 *
 */
@property(nonatomic,copy) NSString* BloodDate;
/**
 *
 */
@property(nonatomic,copy) NSString* BloodMax;
/**
 *
 */
@property(nonatomic,copy) NSString* BloodMin;
/**
 *
 */
@property(nonatomic,copy) NSString* CardId;
/**
 *
 */
@property(nonatomic,copy) NSString* CardIdUpload;
/**
 *
 */
@property(nonatomic,assign) NSInteger CliendId;
/**
 *
 */
@property(nonatomic,copy) NSString* HeartRate;
/**
 *
 */
@property(nonatomic,copy) NSString* HeartRateCon;
/**
 *
 */
@property(nonatomic,copy) NSString* HeartRateDate;

/**
 *
 */
@property(nonatomic,copy) NSString* LifePicUpload;
/**
 *
 */
@property(nonatomic,copy) NSString* PulseRate;
@end

/**
 cell对象
 */
@interface BanboShiminUserCellObj : BanBoColumnCellObj
@property(assign,nonatomic)NSInteger xuhao;
@property(copy,nonatomic)NSString *cellClass;
@property(strong,nonatomic)BanBoShiminUser *user;
@property(assign,nonatomic)BanBoShiminType type;
@property(strong,nonatomic)UIFont *font;
@end

