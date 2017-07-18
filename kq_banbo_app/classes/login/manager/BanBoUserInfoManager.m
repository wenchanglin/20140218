//
//  BanBoUserInfoManager.m
//  kq_banbo_app
//
//  Created by hcy on 2016/11/28.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoUserInfoManager.h"
//http
#import "YZHttpService.h"

//登录单例管理
#import "NIMSingleton.h"

NSString *const BanBoLogoutNotification=@"BanBoLogoutNotification";

@interface BanBoUserInfoManager()
@property(strong,nonatomic)BanBoLoginModel *loginModel;
@property(assign,nonatomic)NSInteger currentIdx;
@property(strong,nonatomic)NSDictionary *typeDict;
@property(strong,nonatomic)BanBoLoginInfoModel *loginInfo;
@end
@implementation BanBoUserInfoManager
static BanBoUserInfoManager *manager;
+(instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[BanBoUserInfoManager new];
    });
    return manager;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.typeDict=@{@(BanBoUSerTypeIT):@"IT中心",
                        @(BanBoUSerTypeBS):@"业务中心",
                        @(BanBoUSerTypePM):@"项目经理",
                        @(BanBoUSerTypeLWC):@"劳务协调员",
                        @(BanBoUSerTypeLWM):@"劳务管理员",
                        @(BanBoUSerTypeSubIT):@"分区IT中心",
                        @(BanBoUSerTypeSubBS):@"分区业务中心"};
        [self checkCache];
    }
    return self;
}
#pragma mark func
-(void)loginWithAccount:(NSString *)account pwd:(NSString *)pwd completion:(BanBoUserInfoManagerCompletionBlock)completion{
    NSDictionary *param=@{@"username":account,@"password":pwd};
    
    [YZHttpService post2Addr:Inter_Login params:param success:^(id responseObject) {
        BanBoLoginModel *model=[BanBoLoginModel mj_objectWithKeyValues:responseObject];
        //DDLogDebug(@"loginModel:%@",model);
        _currentIdx=0;//防止坑爹
        if(model.loginInfoArr.count==1){
            _loginInfo=model.loginInfoArr[0];
            [self cacheModel];
        }else{
            _loginInfo=nil;
        }
        [[NIMSingletonManager sharedManager] createSingletonManager];
        self.loginModel=model;
        if (completion) {
            completion(nil);
        }
    } failure:^(NSError *error) {
       // DDLogError(@"loginWithError:%@",error);
        if(completion){
            completion(error);
        }
    }];
}
-(void)logoutWithCompletion:(BanBoUserInfoManagerCompletionBlock)completion{
    self.loginModel=nil;
    _currentIdx=-1;
    _loginInfo=nil;
    [self removeCache];
    [[NSNotificationCenter defaultCenter] postNotificationName:BanBoLogoutNotification object:nil];
    
}
#pragma mark cache
-(void)cacheModel{
    if (self.loginInfo) {
        NSData *data=[NSKeyedArchiver archivedDataWithRootObject:self.loginInfo];
        [[YZCacheManager sharedInstance] addCache:data forKey:@"loginInfo" type:YZCacheTypeDocumentFile];
    }
}
-(void)removeCache{
    [[YZCacheManager sharedInstance] removeCacheForKey:@"loginInfo" type:YZCacheTypeDocumentFile];
}
-(void)checkCache{
  NSData *data=  [[YZCacheManager sharedInstance] cacheForKey:@"loginInfo" type:YZCacheTypeDocumentFile];
    if (data) {
        BanBoLoginInfoModel *info=[NSKeyedUnarchiver unarchiveObjectWithData:data];
        self.loginInfo=info;
        
    }
}
#pragma mark param

-(NSArray *)loginInfos{
    return self.loginModel.loginInfoArr;
}
-(BanBoLoginInfoModel *)currentLoginInfo{
    return _loginInfo;
    
}
-(void)setInfoIdx:(NSInteger)idx{
    _currentIdx=idx;
    NSArray *infoArr= self.loginModel.loginInfoArr;
    if (idx>=0 && idx<infoArr.count) {
        _loginInfo=infoArr[idx];
        [self cacheModel];
    }else{
        DDLogError(@"invalidIdx:%ld",(long)idx);
    }
    
}

-(NSMutableDictionary *)userInfoParam{
    BanBoUser *user=[[self currentLoginInfo] user];
    if (user) {
        return [@{@"username":[user username],@"token":[self currentToken] } mutableCopy];
    }else{
        return nil;
    }
}
-(NSString *)userPageTitle{
    return [[self currentLoginInfo].title stringByAppendingString:@"智慧工地"];
}
/**
 最后一个token才是有效的

 @return 正确的token
 */
-(NSString *)currentToken{
    BanBoLoginInfoModel *info=[self.loginModel.loginInfoArr lastObject];
    if (info==nil) {
        info=[self currentLoginInfo];
    }
    if (info && info.token) {
        return info.token;
    }
    
    
    return @"";
}



-(NSString *)typeStrForRole:(BanBoUSerType)type{
    return self.typeDict[@(type)];
}
@end
