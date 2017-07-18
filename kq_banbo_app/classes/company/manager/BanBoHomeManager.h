//
//  BanBoHomeManager.h
//  kq_banbo_app
//
//  Created by hcy on 2016/11/29.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "NIMSingleton.h"
#import "BanBoHomeTotal.h"
#import "BanBoHomeDetail.h"
#import "BanBoProjectDetail.h"
typedef void(^BanBoHomeManagerCompletionBlock)(id data,NSError *error);
/**
 主页管理
 */
@interface BanBoHomeManager : NIMSingleton


/**
 *
 */

#pragma mark 公司
/**
 获取总公司/分公司统计信息

 @param groupId id
 @param completion 回调
 */
-(void)getCompanyTotalInfoWithGroupId:(NSNumber *)groupId completion:(BanBoHomeManagerCompletionBlock)completion;

/**
 获取公总司/分公司详情

 @param clientId 分公司id
 @param start 开始
 @param limit limit
 @param completion 回调
 */
-(void)getCompanyDetailInfoWithGroupId:(NSNumber *)clientId start:(NSInteger)start limit:(NSInteger)limit completion:(BanBoHomeManagerCompletionBlock)completion;


#pragma mark 工地
/**
 获得工地的统计信息

 @param projectId 工地id
 @param completion 回调
 */
-(void)getProjectTotalInfoWithProjectId:(NSNumber *)projectId completion:(BanBoHomeManagerCompletionBlock)completion;

/**
 获取工地详情
 
 @param clientId 分公司id
 @param start 开始
 @param limit limit
 @param completion 回调
 */
-(void)getProjectDetailInfoWithGroupId:(NSNumber *)clientId start:(NSInteger)start limit:(NSInteger)limit completion:(BanBoHomeManagerCompletionBlock)completion;


/**
 给报道页面用

 @param projectId 工地id
 @return 工地名字
 */
-(NSString *)projectNameById:(NSNumber *)projectId;
@end
