//
//  BanBoProjectManager.m
//  kq_banbo_app
//
//  Created by hcy on 2016/12/1.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoProjectManager.h"
#import "BanBoUserInfoManager.h"
#import "BanBoShiminDetail.h"
#import "YZHttpService.h"
#import <AFNetworking.h>

@implementation BanBoProjectManager
-(void)getRecordsTotalWithProjectId:(NSNumber *)projectId completion:(BanBoProjectManagerCompletionBlock)completion{
    NSMutableDictionary *param=[self param];
    [param setObject:projectId forKey:@"clientid"];
    
    [YZHttpService post2Addr:Inter_RealNameUserNum params:param success:^(NSDictionary * responseObject) {
        if (completion) {
            id result=responseObject[@"result"];
            if ([result isKindOfClass:[NSNumber class]]) {
                completion(result,nil);
            }else{
                DDLogError(@"not Number Return:%@",responseObject);
                completion(@0,nil);
            }
            
        }
        
    } failure:^(NSError *error) {
        if (completion) {
            completion(nil,error);
        }
        
    }];
}
-(void)getRecordsDetailWithProjectId:(NSNumber *)projectId completion:(BanBoProjectManagerCompletionBlock)completion{
    NSMutableDictionary *param=[self param];
    [param setObject:@"0" forKey:@"start"];
    [param setObject:@"10000" forKey:@"limit"];
    [param setObject:projectId forKey:@"clientid"];
    
    [YZHttpService post2Addr:Inter_getRecords params:param success:^(id responseObject) {
        BanBoRecordsObj *record=[BanBoRecordsObj instWithResp:responseObject];
        if (completion) {
            completion(record,nil);
        }
    } failure:^(NSError *error) {
        if (completion) {
            completion(nil,error);
        }
    }];
}
-(void)getHealthDataWithProjectId:(NSNumber *)projectId completion:(BanBoProjectManagerCompletionBlock)completion{
    NSMutableDictionary *param=[self param];
    [param setObject:@"0" forKey:@"start"];
    [param setObject:@"10000" forKey:@"limit"];
    [param setObject:projectId forKey:@"clientid"];
    
    [YZHttpService post2Addr:Inter_RealNameProjectHealth params:param success:^(id responseObject) {
        BanBoShiminDetail *detail=[BanBoShiminDetail instWithResp:responseObject];
        completion(detail.result,nil);

    } failure:^(NSError *error) {
        if (completion) {
            completion(nil,error);
        }
    }];
    
}

-(void)addRecordPreForProject:(NSNumber *)projectId completion:(BanBoProjectManagerCompletionBlock)completion{
    NSMutableDictionary *param=[self param];
    [param setObject:projectId forKey:@"clientid"];
    [YZHttpService post2Addr:Inter_enableReport params:param success:^(NSDictionary* responseObject) {
        id resultval=responseObject[@"result"];
        BOOL canAdd=NO;
        if ([resultval integerValue]==1) {
            canAdd=YES;
        }
        if(completion){
            completion(@(canAdd),nil);
        }
    } failure:^(NSError *error) {
        if(completion){
            completion(nil,error);
        }
    }];
    
}
-(void)getValidCardNumForProject:(NSNumber *)projectId completion:(BanBoProjectManagerCompletionBlock)completion{
    NSMutableDictionary *param=[self param];
    [param setObject:projectId forKey:@"clientid"];
    [YZHttpService post2Addr:Inter_validUserId params:param success:^(NSDictionary* responseObject) {
        id resultval=responseObject[@"result"];
        if ([resultval isKindOfClass:[NSDictionary class]]) {
//           id workno= [(NSDictionary *)resultval objectForKey:@"workno"];
//            if ([workno integerValue]) {
//                if (completion) {
//                    completion(workno,nil);
//                }
//            }
            completion(resultval,nil);
        }else{
            completion(nil,[NSError errorWithDomain:@"" code:1 userInfo:@{NSLocalizedDescriptionKey:@"数据类型错误"}]);
//            completion(@(0),nil);
        }
    } failure:^(NSError *error) {
        if(completion){
            completion(nil,error);
        }
    }];
}
-(void)uploadImage:(UIImage *)image forPicKey:(NSString *)picKey forProject:(NSNumber *)projectId  progress:(BanBoProjectManagerUploadProgressBlock)progress completion:(BanBoProjectManagerCompletionBlock)completion{
    
    NSString *projectCacheKey= [NSString stringWithFormat:@"%@.jpg",picKey];//@"tmpImage.jpg";
    [[YZCacheManager sharedInstance] addCache:UIImageJPEGRepresentation(image, 0.7) forKey:projectCacheKey type:YZCacheTypeDocumentFile];
    NSString *cachePath=[[YZCacheManager sharedInstance] cachePathForKey:projectCacheKey type:YZCacheTypeDocumentFile];
    NSMutableDictionary * param = [self param];
    [param setObject:projectId forKey:@"clientid"];
    [param setObject:@6 forKey:@"fileType"];
    
    [YZHttpService uploadFile:cachePath param:param toUrl:Inter_UploadFile formFileName:@"uploadfile" progress:progress success:^(id responseObject) {
        NSString *fileUrl=@"";
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            fileUrl=responseObject[@"result"];
        }
        if (completion) {
            completion(fileUrl,nil);
        }
    } failure:^(NSError *error) {
        if (completion) {
            completion(nil,error);
        }
    }];
}
-(void)saveReport:(NSDictionary *)personInfo forProject:(NSNumber *)projectId completion:(BanBoProjectManagerCompletionBlock)completion{
    NSMutableDictionary *aParam= [self param];
    [aParam addEntriesFromDictionary:personInfo];
    [aParam setObject:projectId forKey:@"clientid"];
    NSString * string = [NSString stringWithFormat:@"%@%@",QingQiuTou,Inter_saveReport];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    AFHTTPResponseSerializer * serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObjects:@"image/jpeg",@"text/html", nil];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=utf8" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer = serializer;
    [manager POST:string parameters:aParam progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completion) {
            
            completion(responseObject,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {
            completion(nil,error);
        }
    }];    
    
}


-(NSMutableDictionary *)param{
    return [[BanBoUserInfoManager sharedInstance] userInfoParam];
    
}
@end
