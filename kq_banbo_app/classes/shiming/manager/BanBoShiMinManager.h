//
//  BanBoShiMinManager.h
//  kq_banbo_app
//
//  Created by hcy on 2016/12/5.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "NIMSingleton.h"
#import "BanBoBanzhuObj.h"
typedef NS_ENUM(NSInteger,BanBoShiminType){
    BanBoShiminTypeGZLB=1,
    BanBoShiminTypeGRMC,        //工人名册
    BanBoShiminTypeXXGL,        //信息管理
    BanBoShiminTypeKQGL,        //考情管理
    BanBoShiminTypeYHKH,        //
    BanBoShiminTypeKQTJ,        //考情统计
    BanBoShiminTypeJKGL         //健康管理
};
typedef void(^BanBoShiMinCompletionBlock)(id data,NSError *error);
@interface BanboShiminRequestParam :NSObject
@property(strong,nonatomic)NSNumber *banzhu;
@property(strong,nonatomic)NSNumber *xiaobanzhu;
@property(copy,nonatomic)NSString *user;
@property(assign,nonatomic)NSInteger start;
@property(assign,nonatomic)NSInteger limit;
@end

@interface BanBoShiMinManager : NIMSingleton
/**
 接口-一开始漏写了
 */
@property(strong,nonatomic)NSNumber *projectId;


/**
 获得人数

 @param param 请求参数
 @param completion 回调
 */
-(void)getPersonCountWithParam:(BanboShiminRequestParam *)param completion:(BanBoShiMinCompletionBlock)completion;

/**
 获得小班组列表
 
 @param param 请求参数
 @param completion 回调
 */
-(void)getXiaoBanzhuForBanzhuWithParam:(BanboShiminRequestParam *)param completion:(BanBoShiMinCompletionBlock)completion;

/**
 获得班组列表

 @param completion 回调
 */
-(void)getBanzhuWithCompletion:(BanBoShiMinCompletionBlock)completion;

/**
 获得详细信息

 @param type 类型
 @param param 请求参数
 @param completion 回调
 */
-(void)getDataForType:(BanBoShiminType)type param:(BanboShiminRequestParam *)param completion:(BanBoShiMinCompletionBlock)completion;
@end
