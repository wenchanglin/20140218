//
//  BanBoNVRInfo.h
//  kq_banbo_app
//
//  Created by hcy on 2017/2/15.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "BanBoRespObj.h"
struct BanBoNVRInfoAddress{
    char *ipaddr;
    int port;
};
typedef struct BanBoNVRInfoAddress BanBoNVRInfoAddress;


/**
 海康nvr信息
 */
@interface BanBoNVRInfo : BanBoRespObj
@property(assign,nonatomic)NSInteger clientid;
@property(assign,nonatomic)BanBoNVRInfoAddress localAddress;
@property(assign,nonatomic)NSInteger nid;
@property(copy,nonatomic)NSString *note;
@property(assign,nonatomic)BanBoNVRInfoAddress remoteAddress;
@property(copy,nonatomic)NSString* ssid;
@end

@interface BanBoYSNVRInfo : BanBoRespObj
@property(copy,nonatomic)NSString *accessToken;
@end

