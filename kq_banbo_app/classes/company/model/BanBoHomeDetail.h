//
//  BanBoCompanyInfoModel.h
//  kq_banbo_app
//
//  Created by hcy on 2016/11/29.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoRespObj.h"

#import "YZListHeader.h"
#import "HCYColumnLayoutManager.h"
@class BanBoHomeDetailInfoTotal;

/**
 detail信息
 */
@interface BanBoHomeDetail : BanBoRespObj
+(instancetype)instWithResp:(NSDictionary *)resp contrId:(NSNumber *)contrId;
@property(strong,nonatomic)BanBoHomeDetailInfoTotal *totalInfo;
@property(strong,nonatomic)NSArray *subInfo;
//方便外面判断用
@property(assign,nonatomic)BOOL subInfoIsProject;

@end

/**
 公司主页-detail信息。父类
 */
@interface BanBoHomeDetailInfoBase : NSObject
@property(copy,nonatomic)NSString *name;
@property(assign,nonatomic)NSInteger CheckProperly;
@property(assign,nonatomic)NSInteger ContractorId;
@property(assign,nonatomic)NSInteger DeviceProperly;
@property(assign,nonatomic)NSInteger TotalClient;
@property(copy,nonatomic)NSString *type;
@end
/**
 detail信息。总计
 */
@interface BanBoHomeDetailInfoTotal : BanBoHomeDetailInfoBase
@end
/**
 detail信息-分公司
 */
@interface BanBoHomeDetailInfoSubCompany : BanBoHomeDetailInfoBase
@property(copy,nonatomic)NSString *grouptype;
@end
/**
 detail信息-工地
 */
@interface BanBoHomeDetailInfoProject : BanBoHomeDetailInfoBase
@property(assign,nonatomic)NSInteger ClientId;
@property(assign,nonatomic)NSInteger DeviceType;
@property(assign,nonatomic)NSInteger KqType;
@property(copy,nonatomic)NSString *lastReport;
@property(assign,nonatomic)NSInteger devType;

@end

/**
 主页-cell显示模型
 */
@interface BanBoHomeDetailInfoCellObj :BanBoCellObj
-(instancetype)initWithModel:(BanBoHomeDetailInfoBase *)model;
@property(strong,nonatomic)BanBoHomeDetailInfoBase *data;

@property(assign,nonatomic,getter=isOpen)BOOL open;
@end
