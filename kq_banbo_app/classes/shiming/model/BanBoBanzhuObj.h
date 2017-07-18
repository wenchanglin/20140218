//
//  BanBoBanzhuObj.h
//  kq_banbo_app
//
//  Created by hcy on 2016/12/5.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoRespObj.h"

/**
 班组接口
 */
@interface BanBoBanzhuObj : BanBoRespObj
+(instancetype)instWithResp:(NSDictionary *)resp;
@property(strong,nonatomic)NSArray *result;
@end
@interface BanBoBanzhuItem : NSObject

/**
 是不是头上那个请选择班组的item

 @return 是不是
 */
-(BOOL)isDefaultItem;
@property(assign,nonatomic)NSInteger gid;
@property(copy,nonatomic)NSString *groupname;
@property(assign,nonatomic)NSTimeInterval addtime;
@property(strong,nonatomic)NSString *enterdate;
@property(assign,nonatomic)NSInteger fatherid;
@property(assign,nonatomic)NSInteger groupid;
@property(assign,nonatomic)NSInteger maxgroupid;

@end
