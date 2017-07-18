//
//  BanBoHealthManager.m
//  kq_banbo_app
//
//  Created by hcy on 2017/1/6.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "BanBoHealthManager.h"
#import "BanBoUserInfoManager.h"
#import "YZHttpService.h"
#import "BanBoShiminDetail.h"
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>
@implementation BanBoHealthManager
#pragma mark public
-(void)addBloodPressure:(BloodPressureInfo *)info forProject:(NSNumber *)projectId  user:(NSNumber *)userId completion:(BanBoHealthManagerCompletionBlock)completion{

    NSMutableDictionary *param=[self param];
    [param setObject:projectId forKey:@"clientid"];
    [param setObject:userId forKey:@"userid"];
    [param setObject:@(info.highPressure) forKey:@"BloodMax"];
    [param setObject:@(info.lowPressure) forKey:@"BloodMin"];
    [param setObject:@(info.pluseRate) forKey:@"PulseRate"];
    
    [YZHttpService post2Addr:Inter_addBloodPressure params:param success:^(id responseObject) {
        if (completion) {
            completion(responseObject,nil);
        }
    } failure:^(NSError *error) {
        if (completion) {
            completion(nil,error);
        }
    }];
}
-(void)getBloodPressure4User:(BanBoShiminUser *)user inProject:(NSNumber *)projectId completion:(BanBoHealthManagerCompletionBlock)completion{
    NSMutableDictionary *param=[self param];
    [param setObject:projectId forKey:@"clientid"];
    [param setObject:user.CardId forKey:@"cardid"];
    
    [YZHttpService post2Addr:Inter_RealNameGetDetail params:param success:^(id responseObject) {
        if (completion) {
            //比较low
            NSDictionary *resultDict= responseObject[@"result"];
            BloodPressureInfo *info=[BloodPressureInfo new];
            [info mj_setKeyValues:resultDict];
            completion(info,nil);
        }
    } failure:^(NSError *error) {
        if (completion) {
            completion(nil,error);
        }
    }];
    
}

-(void)getHeadPic:(NSString *)headPic forUser:(NSString *)cardId inProject:(NSNumber *)projectId completion:(BanBoHealthManagerCompletionBlock)completion
{
    if (!completion) {
        return;
    }
    NSString * string = [NSString stringWithFormat:@"%@%@",QingQiuTou,headPic];
    NSDictionary * param = @{@"cardid":cardId,@"clientid":projectId};
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    AFHTTPResponseSerializer * serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObjects:@"image/jpeg",@"text/html", nil];
    manager.responseSerializer = serializer;
    [manager GET:string parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //DDLogDebug(@"resp:%@",responseObject);
        completion(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //DDLogError(@"error:%@",error);
        completion(nil,error);
    }];

}
-(void)uploadDailyImage:(UIImage *)image forUser:(NSString *)cardId inProject:(NSNumber *)projectId progres:(BanBoHealthManagerUploadProgressBlock)progress completion:(BanBoHealthManagerCompletionBlock)completion{
    if(!completion){
        return;
    }
    NSMutableDictionary *param=[self param];
    [param setObject:@7 forKey:@"fileType"];
    [param setObject:cardId forKey:@"cardid"];
    [param setObject:projectId forKey:@"clientId"];
    
    NSString *filePath=[[YZCacheManager sharedInstance] tmpPathForImage:image sepcFileName:cardId type:BanBoImageTypeJPG];//sepcfilename:nil
    
    [YZHttpService uploadFile:filePath param:param toUrl:Inter_UploadDailyPhoto formFileName:@"lifepic" progress:progress success:^(id responseObject) {
       // DDLogDebug(@"resp:%@",responseObject);
        completion(responseObject,nil);
    } failure:^(NSError *error) {
        //DDLogError(@"error:%@",error);
        completion(nil,error);
    }];
}
-(void)uploadCardImages:(NSArray *)images forUser:(NSString *)cardId inProject:(NSNumber *)projectId progres:(BanBoHealthManagerUploadProgressBlock)progress completion:(BanBoHealthManagerCompletionBlock)completion{
    if(!completion || images.count!=2){
        return;
    }
    NSMutableDictionary *param=[self param];
    [param setObject:@8 forKey:@"fileType"];
    [param setObject:cardId forKey:@"cardid"];
    [param setObject:projectId forKey:@"clientId"];
    UIImage *frontImage=images[0];
    UIImage *backImage =images[1];
    NSString *frontName=[NSString stringWithFormat:@"%@_1",cardId];
    NSString *backName=[NSString stringWithFormat:@"%@_2",cardId];
    NSString *frontPath=[[YZCacheManager sharedInstance] tmpPathForImage:frontImage sepcFileName:frontName type:BanBoImageTypeJPG];
    NSString *backPath=[[YZCacheManager sharedInstance] tmpPathForImage:backImage sepcFileName:backName type:BanBoImageTypeJPG];
    
    [YZHttpService uploadFile:frontPath param:param toUrl:Inter_IdCardPicUpload formFileName:@"cardpic" progress:nil success:^(id responseObject) {
        DDLogDebug(@"zheng%@",responseObject);
       [YZHttpService uploadFile:backPath param:param toUrl:Inter_IdCardPicUpload formFileName:@"cardpic" progress:nil success:^(id responseObject) {
           DDLogDebug(@"fan:%@",responseObject);
           completion(responseObject,nil);
       } failure:^(NSError *error) {
            completion(nil,error);
       }];
        
    } failure:^(NSError *error) {
        completion(nil,error);
    }];
    
}

-(void)addCardiorgramWithHR:(NSNumber *)hr result:(NSString *)result forUser:(NSInteger)userId inProject:(NSNumber *)projectId completion:(BanBoHealthManagerCompletionBlock)completion{
    if (!completion) {
        return;
    }
    NSMutableDictionary *param= [self param];
    [param setObject:projectId forKey:@"clientid"];
    [param setObject:[NSNumber numberWithInteger:userId] forKey:@"userid"];
    [param setObject:hr forKey:@"HeartRate"];
    [param setObject:result forKey:@"HeartRateCon"];
    
    [YZHttpService post2Addr:Inter_addHeartRate params:param success:^(id responseObject) {
        completion(responseObject,nil);
    } failure:^(NSError *error) {
        completion(nil,error);
    }];
    DDLogInfo(@"hearts参数:%@",param);
}
-(void)getLifePic:(NSString *)lifepicture forUser:(NSString *)cardId  completion:(BanBoHealthManagerCompletionBlock)completion
{
    if (!completion) {
        return;
    }
    NSString * string = [NSString stringWithFormat:@"%@%@",QingQiuTou,lifepicture];
    NSDictionary * param = @{@"cardid":cardId};
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    AFHTTPResponseSerializer * serializer = [AFHTTPResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates=YES;
    serializer.acceptableContentTypes = [NSSet setWithObjects:@"image/jpeg",@"text/html", nil];
    manager.responseSerializer = serializer;
    [manager GET:string parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        DDLogDebug(@"tupian%@",responseObject);
        completion(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil,error);
    }];
}

-(void)getCardPic:(NSString *)cardpic forUser:(NSString *)cardId Type:(NSString *)type completion:(BanBoHealthManagerCompletionBlock)completion
{
    NSString * string = [NSString stringWithFormat:@"%@%@",QingQiuTou,cardpic];
    NSDictionary * params;
    params = @{@"cardid":cardId,@"type":type};
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    AFHTTPResponseSerializer * serializer = [AFHTTPResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates=YES;
    serializer.acceptableContentTypes = [NSSet setWithObjects:@"image/jpeg",@"text/html", nil];
    manager.responseSerializer = serializer;
    [manager GET:string parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DDLogInfo(@"身份证成功:ID：%@-%@//%@",cardId,string,responseObject);
        completion(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //DDLogInfo(@"身份证错误:%@%@",string,error);
        completion(nil,error);
    }];
    
    
}
#pragma mark param
-(NSMutableDictionary *)param{
//    return [NSMutableDictionary dictionary];
    return [[BanBoUserInfoManager sharedInstance] userInfoParam];
}
@end
