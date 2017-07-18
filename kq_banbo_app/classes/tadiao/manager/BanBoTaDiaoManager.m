//
//  BanBoTaDiaoManager.m
//  kq_banbo_app
//
//  Created by banbo on 2017/6/9.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "BanBoTaDiaoManager.h"
#import "YZHttpService.h"

@implementation BanBoTaDiaoManager
-(void)postTaDiaoListWithProject:(NSNumber *)projectid completion:(BanBoTaDiaoCompletionBlock)completion
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", nil];
    manager.securityPolicy = securityPolicy;
    NSString * string = [NSString stringWithFormat:@"%@td/jsonListTowerCrane.html",huanjingtou];
    NSDictionary * param = @{@"clientId":projectid};
    [manager POST:string parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       // DDLogInfo(@"塔吊ID:%@",responseObject);
        if([((NSNumber*)[responseObject objectForKey:@"code"]) intValue]==1)
        {
            NSDictionary * arraay = responseObject[@"data"];
            NSArray * sf = arraay[@"list"];
//            DDLogInfo(@"塔吊ID:%@",sf);
            completion(sf,nil);
            
        }
        else if ([((NSNumber*)[responseObject objectForKey:@"code"]) intValue]==-1)
        {
          //  [HCYUtil showErrorWithStr:responseObject[@"message"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       // DDLogInfo(@"塔吊ID错误:%@",error);
    }];
}
-(void)postTaDiaoDataWithSheBeiId:(NSNumber *)shibeiId completion:(BanBoTaDiaoCompletionBlock)completion
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", nil];
    manager.securityPolicy = securityPolicy;
    NSString * string2 = [NSString stringWithFormat:@"%@td/jsonGetTowerCraneData.html",huanjingtou];
    NSDictionary * param = @{@"deviceId":shibeiId};
    [manager POST:string2 parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if([((NSNumber *)[responseObject objectForKey:@"code"])intValue]==1)
        {
//           DDLogInfo(@"塔吊实时数据:%@",responseObject);
            NSDictionary * dict = responseObject[@"data"];
            completion(dict,nil);
        }
        else if ([((NSNumber *)[responseObject objectForKey:@"code"])intValue]==-1)
        {
            completion(responseObject[@"message"],nil);
            //[HCYUtil showErrorWithStr:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       //    DDLogInfo(@"塔吊实时数据错误:%@",error);
    }];
}
@end
