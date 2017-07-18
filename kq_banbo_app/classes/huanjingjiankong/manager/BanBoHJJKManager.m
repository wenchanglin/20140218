//
//  BanBoHJJKManager.m
//  kq_banbo_app
//
//  Created by banbo on 2017/5/4.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "BanBoHJJKManager.h"

@implementation BanBoHJJKManager
-(void)postSheBeiListWithProject:(NSNumber *)projectid completion:(BanBoHJJKCompletionBlock)completion
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", nil];
    manager.securityPolicy = securityPolicy;
    NSString * string2 = [NSString stringWithFormat:@"%@/dhrtd/jsonDhEquipmentList.html",huanjingtou];
    NSDictionary * param = @{@"clientId":projectid};
    [manager POST:string2 parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        DDLogInfo(@"huanjing:%@",responseObject);
        if([((NSNumber*)[responseObject objectForKey:@"code"]) intValue]==1)
        {
            NSDictionary * arr = responseObject[@"data"];
            NSArray * arr2 = arr[@"dataList"];
            completion(arr2,nil);
        }
        else if ([((NSNumber*)[responseObject objectForKey:@"code"]) intValue]==-1)
        {
            [HCYUtil showErrorWithStr:responseObject[@"message"]];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         DDLogInfo(@"huanjing错误:%@",error);
    }];
}
-(void)posthuanJSShiDataWithSheBeiId:(NSNumber *)shibeiId completion:(BanBoHJJKCompletionBlock)completion
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", nil];
    manager.securityPolicy = securityPolicy;
    NSString * string2 = [NSString stringWithFormat:@"%@/dhrtd/jsonDhRtd.html",huanjingtou];
    NSDictionary * param = @{@"equipmentId":shibeiId};
    [manager POST:string2 parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       // DDLogInfo(@"huanjing:%@",responseObject);
        if([((NSNumber *)[responseObject objectForKey:@"code"])intValue]==1)
        {
            NSDictionary * dict = responseObject[@"data"];
            completion(dict,nil);
        }
        else if ([((NSNumber *)[responseObject objectForKey:@"code"])intValue]==-1)
        {
            
           // [HCYUtil showErrorWithStr:responseObject[@"message"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // DDLogInfo(@"huanjing错误:%@",error);
    }];
}
@end
