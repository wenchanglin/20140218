//
//  BanBoHomeTotal.m
//  kq_banbo_app
//
//  Created by hcy on 2016/11/29.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoHomeTotal.h"
@implementation BanBoHomeTotal
+(instancetype)instWithCompanyTotal:(NSDictionary *)dict{
    BanBoHomeTotal *model=[BanBoHomeTotal mj_objectWithKeyValues:dict];
    
    NSDictionary *resultDict=dict[@"result"];
    if (resultDict) {
        BanBoCompanyTotal *resultModel=[BanBoCompanyTotal mj_objectWithKeyValues:resultDict];
        model.result=resultModel;
    }
    return model;
    
}
+(instancetype)instWithProjectTotal:(NSDictionary *)dict{
    BanBoHomeTotal *model=[BanBoHomeTotal mj_objectWithKeyValues:dict];
    
    NSDictionary *resultDict=dict[@"result"];
    if (resultDict) {
        BanBoProjectTotal *resultModel=[BanBoProjectTotal mj_objectWithKeyValues:resultDict];
        model.result=resultModel;
    }
    return model;
}

@end

@implementation BanBoCompanyTotal
@end
@implementation BanBoProjectTotal
@end
