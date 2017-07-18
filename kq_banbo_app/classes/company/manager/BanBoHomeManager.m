//
//  BanBoHomeManager.m
//  kq_banbo_app
//
//  Created by hcy on 2016/11/29.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoHomeManager.h"
#import "YZHttpService.h"
#import "BanBoUserInfoManager.h"

@interface BanBoHomeManager()
@property(strong,nonatomic)NSMutableArray *cacheProjectDetails;
@end
@implementation BanBoHomeManager
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cacheProjectDetails=[NSMutableArray array];
    }
    return self;
}
#pragma mark 公司方法
-(void)getCompanyTotalInfoWithGroupId:(NSNumber *)groupId completion:(BanBoHomeManagerCompletionBlock)completion{
    [self getTotalInfoWithType:CompanyKey val:groupId completion:completion];
}
-(void)getCompanyDetailInfoWithGroupId:(NSNumber *)clientId start:(NSInteger)start limit:(NSInteger)limit completion:(BanBoHomeManagerCompletionBlock)completion{
    [self getDetailInfoWithType:CompanyKey val:clientId start:start limit:limit completion:completion];
}

#pragma mark 工地方法
-(void)getProjectTotalInfoWithProjectId:(NSNumber *)projectId completion:(BanBoHomeManagerCompletionBlock)completion{
    [self getTotalInfoWithType:ProjectKey val:projectId completion:completion];
}
-(void)getProjectDetailInfoWithGroupId:(NSNumber *)clientId start:(NSInteger)start limit:(NSInteger)limit completion:(BanBoHomeManagerCompletionBlock)completion{
    [self getDetailInfoWithType:ProjectKey val:clientId start:start limit:limit completion:completion];
}

#pragma mark 公共方法
-(void)getTotalInfoWithType:(NSString *)type val:(NSNumber *)val completion:(BanBoHomeManagerCompletionBlock)completion{
    if (![self checkWithCompletion:completion]) {
        return;
    }
    NSMutableDictionary *param=[self baseParam];
    [param setObject:val forKey:@"groupid"];
    [param setObject:type forKey:@"grouptype"];
    
    [YZHttpService post2Addr:Inter_HomeTotal params:param success:^(id responseObject) {
        BanBoHomeTotal *model=nil;
        if ([type isEqualToString:ProjectKey]) {
            model=[BanBoHomeTotal instWithProjectTotal:responseObject];
        }else{
            model=[BanBoHomeTotal instWithCompanyTotal:responseObject];
        }
        //DDLogDebug(@"nimei:%@",responseObject);
        if(completion){
            completion(model.result,nil);
        }
    } failure:^(NSError *error) {
        if (completion) {
            completion(nil,error);
        }
    }];
}
-(void)getDetailInfoWithType:(NSString *)type val:(NSNumber *)val start:(NSInteger)start limit:(NSInteger)limit completion:(BanBoHomeManagerCompletionBlock)completion{
    if (![self checkWithCompletion:completion]) {
        return;
    }
    NSMutableDictionary *param=[self baseParam];
    [param setObject:val forKey:@"groupid"];
    [param setObject:type forKey:@"grouptype"];
    [param setObject:@(start) forKey:@"start"];
    [param setObject:@(limit) forKey:@"limit"];
    if ([type isEqualToString:CompanyKey]) {
        BanBoHomeDetail *detail=[self getDetailCacheWithVal:val];
        if (detail && completion) {
            completion(detail,nil);
            return;
        }
    }
    [YZHttpService post2Addr:Inter_HomeDetail params:param success:^(id responseObject) {
        id model=nil;
        if ([type isEqualToString:CompanyKey]) {
            model=[BanBoHomeDetail instWithResp:responseObject contrId:val];
            if ([model subInfoIsProject] && [self.cacheProjectDetails containsObject:model]==NO) {
                [(BanBoHomeDetail *)model setObjIdentifier:[NSString stringWithFormat:@"%@%ld",CompanyKey,(long)[val integerValue]]];
                [self.cacheProjectDetails addObject:model];
            }
        }else{
            
            model=[BanBoProjectDetail instWithResp:responseObject];
        }
       // DDLogDebug(@"nidaye:%@",responseObject);
        if (completion) {
            completion(model,nil);
        }
    } failure:^(NSError *error) {
        if (completion) {
            completion(nil,error);
        }
    }];
}
-(NSString *)projectNameById:(NSNumber *)projectId{
    for (BanBoHomeDetail *detail in self.cacheProjectDetails) {
        for (BanBoHomeDetailInfoProject *project in detail.subInfo) {
            if (project.ClientId==[projectId integerValue]) {
                return project.name;
                break;
            }
        }
    }
    return @"";
}
-(BanBoHomeDetail *)getDetailCacheWithVal:(NSNumber *)val{
    NSString* objIdentifier= [NSString stringWithFormat:@"%@%ld",CompanyKey,(long)[val integerValue]];
    
    for (BanBoHomeDetail *detail in self.cacheProjectDetails) {
        if ([detail.objIdentifier isEqualToString:objIdentifier]) {
            return detail;
            break;
        }
    }
    return nil;
    
}
-(BOOL)checkWithCompletion:(BanBoHomeManagerCompletionBlock)completion{
    NSMutableDictionary *param=[self baseParam];
    if (!param) {
        if (completion) {
            completion(nil,[YZErrorMaker noUserError]);
        }
        return NO;
    }
    
    return YES;
}

-(NSMutableDictionary *)baseParam{
    return [[BanBoUserInfoManager sharedInstance] userInfoParam];
}
@end
