//
//  BanBoShiMinManager.m
//  kq_banbo_app
//
//  Created by hcy on 2016/12/5.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoShiMinManager.h"
#import "BanBoBanzhuObj.h"
#import "BanBoUserInfoManager.h"
#import "BanBoShiminDetail.h"
#import "YZHttpService.h"
@interface BanBoShiMinManager()

@end
@implementation BanBoShiMinManager
-(void)getPersonCountWithParam:(BanboShiminRequestParam *)requestParam completion:(BanBoShiMinCompletionBlock)completion{
    NSMutableDictionary *param=[self param];
    [param setObject:requestParam.banzhu forKey:@"mastergroup"];
    [param setObject:requestParam.xiaobanzhu forKey:@"subgroup"];
    [param setObject:requestParam.user forKey:@"user"];
    
    [YZHttpService post2Addr:Inter_RealNameSelectUserNum params:param success:^(id responseObject) {
        id val=responseObject[@"result"];
        DDLogInfo(@"搜索到人:%@",val);
        if (completion) {
            completion(val,nil);
        }
        
    } failure:^(NSError *error) {
        if (completion) {
            completion(nil,error);
        }
    }];
    
    
}

-(void)getBanzhuWithCompletion:(BanBoShiMinCompletionBlock)completion{
    if (!completion) {
        return;
    }
    
    [YZHttpService post2Addr:Inter_GroupGetGroup params:[self param] success:^(id responseObject) {
        BanBoBanzhuObj *obj=[BanBoBanzhuObj instWithResp:responseObject];
        completion(obj.result,nil);
    } failure:^(NSError *error) {
        completion(nil,error);
    }];
}
-(void)getXiaoBanzhuForBanzhuWithParam:(BanboShiminRequestParam *)aParam completion:(BanBoShiMinCompletionBlock)completion{
    NSMutableDictionary *param=[self param];
    [param setObject:aParam.banzhu forKey:@"groupid"];
    
    [YZHttpService post2Addr:Inter_GroupGetSubGroup params:param success:^(id responseObject) {
        BanBoBanzhuObj *obj=[BanBoBanzhuObj instWithResp:responseObject];
        completion(obj.result,nil);
    } failure:^(NSError *error) {
        completion(nil,error);
    }];
}
-(void)getDataForType:(BanBoShiminType)type param:(BanboShiminRequestParam *)aParam completion:(BanBoShiMinCompletionBlock)completion{
    NSString *paramStr=@"";
    switch (type) {
        case BanBoShiminTypeGZLB:
        {
            paramStr=Inter_RealNameSalary;
        }
            break;
        case BanBoShiminTypeGRMC:
        {
            paramStr=Inter_RealNameUserDetail;
        }
            break;
        case BanBoShiminTypeXXGL:
        {
            paramStr=Inter_RealNameContactDetail;
        }
            break;
        case BanBoShiminTypeKQGL:
        {
            paramStr=Inter_RealNameUserRecord;
        }
            break;
        case BanBoShiminTypeYHKH:
        {
            paramStr=Inter_RealNameBankCard;
        }
            break;
        case BanBoShiminTypeJKGL:
        {
            paramStr=Inter_RealNameHealth;
        }
            
        default:
            break;
    }
    if (!paramStr.length) {
        DDLogError(@"unSupportShiminType:%ld",(long)type);
        completion(@[],[NSError errorWithDomain:@"不支持的类型" code:1 userInfo:nil]);
        return;
    }
    NSMutableDictionary *param=[self param];
    [param setObject:aParam.banzhu forKey:@"mastergroup"];
    [param setObject:aParam.xiaobanzhu forKey:@"subgroup"];
    [param setObject:aParam.user forKey:@"user"];
    [param setObject:@(aParam.start) forKey:@"start"];
    [param setObject:@(aParam.limit) forKey:@"limit"];

    NSString * string12 = [NSString stringWithFormat:@"%@%@",QingQiuTou,paramStr];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"image/jpeg",@"text/html",@"text/plain",@"text/json", nil];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=utf8" forHTTPHeaderField:@"Content-Type"];
    [manager POST:string12 parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      //  DDLogInfo(@"获取到数据:%@",responseObject);
        BanBoShiminDetail *detail=[BanBoShiminDetail instWithResp:responseObject];
        completion(detail.result,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // DDLogError(@"中文获取失败:%@",error);
          completion(nil,error);
    }];

}

-(NSMutableDictionary *)param{
    NSMutableDictionary *param= [[BanBoUserInfoManager sharedInstance] userInfoParam];
    [param setObject:self.projectId?:@(-1) forKey:@"clientid"];
    
    return param;
}
@end
@implementation BanboShiminRequestParam

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.banzhu=(@-1);
        self.xiaobanzhu=@(-1);
        self.user=@"";
        self.limit=20;
        self.start=0;
    }
    return self;
}

@end
