//
//  BanBoRespObj.h
//  kq_banbo_app
//
//  Created by hcy on 2016/11/29.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NSObject+MJKeyValue.h>
#import "BanBoCellObj.h"
@interface BanBoRespObj : NSObject
+(instancetype)instWithResp:(NSDictionary *)resp;

@property(assign,nonatomic)NSInteger code;
@property(copy,nonatomic)NSString *resultDes;
//自己加的。方便有些模型要做缓存。但是去重是多个属性联合才能做好的话。可以用这个来搞
@property(copy,nonatomic)NSString *objIdentifier;
@end
