//
//  BanBoRespObj.m
//  kq_banbo_app
//
//  Created by hcy on 2016/11/29.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoRespObj.h"
#import <NSObject+MJKeyValue.h>
@implementation BanBoRespObj
+(instancetype)instWithResp:(NSDictionary *)resp{
    return [[self class] mj_objectWithKeyValues:resp];
}
@end
