//
//  BanBoLoginModel.h
//  kq_banbo_app
//
//  Created by hcy on 2016/11/28.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoRespObj.h"
typedef NS_ENUM(NSInteger,BanBoUSerType){
    BanBoUSerTypeIT=1,  //IT中心
    BanBoUSerTypeBS,    //业务中心
    BanBoUSerTypePM,    //项目经理
    BanBoUSerTypeLWC,   //劳务协调员
    BanBoUSerTypeLWM,   //劳务管理员
    BanBoUSerTypeSubIT, //分区IT中心
    BanBoUSerTypeSubBS  //分区业务中心
    
};
@class BanBoUser;

/**
 最基础的model
 */
@interface BanBoLoginModel : BanBoRespObj
@property(strong,nonatomic)NSArray *loginInfoArr;
@end

/**
 每一个角色
 */
@interface BanBoLoginInfoModel : NSObject<NSCoding>
@property(copy,nonatomic)NSString *title;
@property(copy,nonatomic)NSString *subtitle;
@property(strong,nonatomic)BanBoUser *user;
@property(copy,nonatomic)NSString *token;
@end

/**
 用户信息
 */
@interface BanBoUser : NSObject<NSCoding>
@property(assign,nonatomic)NSInteger luid;
@property(copy,nonatomic)NSString *username;
@property(copy,nonatomic)NSString *userpsw;
@property(assign,nonatomic)BanBoUSerType roletype;
@property(assign,nonatomic)NSInteger contractorid;
@property(assign,nonatomic)NSInteger clientid;
@property(assign,nonatomic)NSTimeInterval addtime;
@property(copy,nonatomic)NSString *remark;
@end
