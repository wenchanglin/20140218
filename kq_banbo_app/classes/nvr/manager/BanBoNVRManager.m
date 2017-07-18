//
//  BanBoNVRManager.m
//  kq_banbo_app
//
//  Created by hcy on 2017/2/22.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "BanBoNVRManager.h"
#import "BanBoUserInfoManager.h"
#import "YZHttpService.h"
@implementation BanBoNVRManager
#pragma mark 海康
-(void)getNVRInfoWithProject:(NSNumber *)projectId completion:(BanBoNVRCompletionBlock)completion{
    NSMutableDictionary *param=[self param];
    [param setObject:projectId forKey:@"clientid"];
    
    [YZHttpService post2Addr:Inter_getNVRInfo params:param success:^(id responseObject) {
        BanBoNVRInfo *info=[BanBoNVRInfo instWithResp:responseObject[@"result"]];
        completion(info,nil);
    } failure:^(NSError *error) {
        completion(nil,error);
    }];
}

-(void)updateHiddenChannels:(NSString *)notes forProject:(NSNumber *)projectId completion:(BanBoNVRCompletionBlock)completion{
    if (!projectId || !notes) {
        return;
    }
    
    NSMutableDictionary *param=[self param];
    [param setObject:projectId forKey:@"clientid"];
    [param setObject:notes forKey:@"ipchannel"];
//没必要回调外面
    [YZHttpService post2Addr:Inter_updateIPChannel params:param success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        DDLogError(@"updateIPCHannelError:%@",error);
    }];
    
}

#pragma mark 萤石
-(void)getYSNVRInfoWithProject:(NSNumber *)projectId completion:(BanBoNVRCompletionBlock)completion{
    NSMutableDictionary *param=[self param];
    [param setObject:projectId forKey:@"clientid"];
    [YZHttpService get2Addr:Inter_getYSNVRInfo params:param success:^(id responseObject) {
        NSString *token=responseObject[@"result"];
        completion(token,nil);
    } failure:^(NSError *error) {
        DDLogError(@"error:%@",error);
    }];

    
}
-(void)getYSSerialNumbWithProject:(NSNumber *)projectId completion:(BanBoNVRCompletionBlock)completion
{
    NSMutableDictionary * param = [self param];
    [param setObject:projectId forKey:@"clientid"];
    [YZHttpService post2Addr:Inter_getYSSeriaNum params:param success:^(id responseObject) {
        DDLogInfo(@"ys设备:%@",responseObject);
        NSArray * aarray = responseObject[@"result"];
        if ([aarray[0] isKindOfClass:[NSString class]]) {
            [HCYUtil showProgressWithStr:aarray[0]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [HCYUtil dismissProgress];
            });
        }
        else
        {
            completion(aarray,nil);
           // DDLogInfo(@"YS设备:%@",aarray);
        }
    } failure:^(NSError *error) {
        completion(nil,error);
    }];
}

#pragma mark 公共
-(NSMutableDictionary *)param{
    return [[BanBoUserInfoManager sharedInstance] userInfoParam];
}
@end
