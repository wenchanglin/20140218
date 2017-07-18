//
//  BanBoUserInfoManager.h
//  kq_banbo_app
//
//  Created by hcy on 2016/11/28.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BanBoLoginModel.h"
typedef void (^BanBoUserInfoManagerCompletionBlock)(NSError *error);
/**
 当前登录用户信息管理
 */
@interface BanBoUserInfoManager : NSObject
+(instancetype)sharedInstance;
-(NSString *)typeStrForRole:(BanBoUSerType)type;
/**
 登录

 @param account 帐号
 @param pwd 密码
 @param completion 回调
 */
-(void)loginWithAccount:(NSString *)account pwd:(NSString *)pwd completion:(BanBoUserInfoManagerCompletionBlock)completion;


/**
 登出

 @param completion 回调
 */
-(void)logoutWithCompletion:(BanBoUserInfoManagerCompletionBlock)completion;
/**
 所有角色

 @return 所有角色
 */
-(NSArray *)loginInfos;

/**
 当前登录的角色

 @return 当前登录的角色
 */
-(BanBoLoginInfoModel *)currentLoginInfo;

/**
 设置使用哪个角色登录

 @param idx 位置
 */
-(void)setInfoIdx:(NSInteger)idx;
/**
 用户信息参数

 @return 用户信息参数
 */
-(NSMutableDictionary *)userInfoParam;

-(NSString *)userPageTitle;

-(void)removeCache;
@end
