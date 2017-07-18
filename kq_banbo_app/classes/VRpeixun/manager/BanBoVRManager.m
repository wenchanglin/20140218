//
//  BanBoVRManager.m
//  kq_banbo_app
//
//  Created by banbo on 2017/6/23.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "BanBoVRManager.h"
#import "YZHttpService.h"
@implementation BanBoVRManager
-(void)postVRTongJiWithProjectId:(NSNumber *)projectid completion:(BanBoVRManagerCompletion)completion
{
    NSString * string = [NSString stringWithFormat:@"%@/vr/getvrtotalAction.html",huanjingtou];//173
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    AFSecurityPolicy * securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;	
    manager.securityPolicy = securityPolicy;
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/plain",@"text/json", nil];
    [manager POST:string parameters:@{@"clientid":projectid} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         if ([responseObject[@"code"]intValue]==1) {
           // DDLogInfo(@"tj%@",responseObject);
             NSArray * arr = responseObject[@"data"];
             if (arr.count==0) {
                 [HCYUtil showErrorWithStr:@"没有数据"];
                 return ;
             }
             else
             {
                 for (NSDictionary * dict in arr) {
                     completion(dict,0,nil);
                 }
             }
         }
         else if ([responseObject[@"code"]intValue]==-1)
         {
             [HCYUtil showErrorWithStr:responseObject[@"message"]];
         }
   
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       // DDLogInfo(@"统计cuowu:%@",error);
    }];
}
-(void)postVRXiangQingWithParameter:(NSDictionary *)parameter completion:(BanBoVRManagerCompletion)completion
{
    NSString * string = [NSString stringWithFormat:@"%@/vr/getvrlistAction.html",huanjingtou];//173
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
     manager.responseSerializer = [AFJSONResponseSerializer serializer];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/plain",@"text/json", nil];
   
    [manager POST:string parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       if ([responseObject[@"code"]intValue]==1) {
//           DDLogInfo(@"xqing%@",responseObject);
            NSDictionary * array = responseObject[@"data"];
            NSNumber * rowDic =array[@"allrow"];
            NSArray * data = array[@"datalist"];
            if(data.count == 0)
            {
                rowDic = 0;
                [HCYUtil showErrorWithStr:@"没有搜索到数据"];
                completion(@{},rowDic,nil);
                return ;
            }
            else
            {
            for (NSDictionary *dic in data) {
                completion(dic,rowDic,nil);
                }
            }
        }
        else if ([responseObject[@"code"]intValue]==-1)
        {
            [HCYUtil showErrorWithStr:responseObject[@"message"]];
        }
        //DDLogInfo(@"详情chengg:%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DDLogInfo(@"详情cuowu:%@",error);
    }];
}
-(void)postVRXiangqingSubWithParameter:(NSDictionary *)parameter completion:(BanBoVRManagerCompletion)completion
{
    NSString * string = [NSString stringWithFormat:@"%@/vr/getvrinfoAction.html",huanjingtou];//?clientid=18&currworkno=1127
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/plain",@"text/json", nil];
    [manager GET:string parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        DDLogInfo(@"chakan:%@",responseObject);
        if ([responseObject[@"code"]intValue]==1) {
            NSDictionary * dic = responseObject[@"data"];
            NSArray * array = dic[@"missionlist"];
            for (NSDictionary * dict in array) {
                completion(dict,nil,nil);
            }
        }
        else if([responseObject[@"code"]intValue]==-1)
        {
            [HCYUtil showErrorWithStr:responseObject[@"message"]];
            return ;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
     //    DDLogInfo(@"查看cuowu:%@",error);
    }];
}
@end
