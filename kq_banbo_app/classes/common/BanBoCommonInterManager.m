//
//  BanBoCommonInterManager.m
//  kq_banbo_app
//
//  Created by hcy on 2017/1/19.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "BanBoCommonInterManager.h"
#import "YZHttpService.h"
@implementation BanBoCommonInterManager
-(void)checkBlueToothWithInfo:(BanboBlueToothInfo *)info completion:(BanBoCommonInterCompletionBlock)completion{
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    [param setObject:info.identifier forKey:@"Mac"];
    [param setObject:info.name forKey:@"deviceType"];
    [param setObject:@1 forKey:@"mobileType"];
    DDLogInfo(@"device:%@-Mac:%@",info.name,info.identifier);
    [YZHttpService post2Addr:Inter_checkBlueTooeh params:param success:^(id responseObject) {
        if (completion) {
            completion(responseObject,nil);
        }
    } failure:^(NSError *error) {
        if (completion) {
            completion(nil,error);
        }
    }];
}
@end


@implementation BanboBlueToothInfo



@end
