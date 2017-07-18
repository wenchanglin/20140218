//
//  YZWMHttpService.m
//  YZWaimaiCustomer
//
//  Created by hcy on 16/8/23.
//  Copyright © 2016年 hcy@yz. All rights reserved.
//

#import "YZHttpService.h"
#import "YZErrorMaker.h"
#import <AFNetworking.h>

@interface YZHttpServiceOption()
-(BOOL)shouldTransparentError:(NSError **)error resp:(NSDictionary *)resp;
@end


extern NSString *const YZLocalErrorDomain;
extern NSString *const YZRemoteErrorDomain;
#define kOpenNet  [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
#define kCloseNet  [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;

@implementation YZHttpService
static dispatch_queue_t requestQueue;
static AFHTTPSessionManager *sessionManager;
static YZHttpServiceOption *option;
+(void)initialize{
    if ([self class]!=[YZHttpService class]) {
        NSAssert(0, @"httpService not extend");
        return;
    }
    requestQueue=dispatch_queue_create("YZHttpRequestQueue", DISPATCH_QUEUE_SERIAL);
    sessionManager=[AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"image/jpeg",nil];
    sessionManager.securityPolicy.allowInvalidCertificates=YES;
    sessionManager.securityPolicy.validatesDomainName=NO;
    sessionManager.requestSerializer=[AFHTTPRequestSerializer serializer];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}
#pragma mark option
+(void)setOption:(YZHttpServiceOption *)aOption{
    option=aOption;
    [self setRequestType:aOption.requestType];
    [self setResponseType:aOption.responseType];
    
}
+(void)setRequestType:(YZHttpServiceType)type{
    switch (type) {
        case YZHttpServiceTypeHttp:
            sessionManager.requestSerializer=[AFHTTPRequestSerializer serializer];
            break;
        case YZHttpServiceTypeJson:
            sessionManager.requestSerializer=[AFJSONRequestSerializer serializer];
            break;
        default:
            break;
    }
    
}
+(void)setResponseType:(YZHttpServiceType)type{
    switch (type) {
        case YZHttpServiceTypeHttp:
            sessionManager.responseSerializer=[AFHTTPResponseSerializer serializer];
            break;
        case YZHttpServiceTypeJson:
            sessionManager.responseSerializer=[AFJSONResponseSerializer serializer];
            break;
        default:
            break;
    }
}
+(void)cleanAllRequest{
    [sessionManager.operationQueue cancelAllOperations];
}
+(BOOL)haveInternet{
    return [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus]>0;
}
#pragma mark post
+(id)post2Addr:(NSString *)addr params:(id)params success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    kOpenNet
    
    NSString* urlStr=[self urlStrWithServletAddr:addr];
    __block NSURLSessionDataTask *task=nil;
    dispatch_sync(requestQueue, ^{
        task= [sessionManager POST:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           // DDLogInfo(@"Post-taskEnd:%@ param:%@ -withResp:%@",task.currentRequest.URL,params,responseObject);
            kCloseNet
            NSError *error=[self checkSuccessWithDict:responseObject];
            if (!error) {
                if (success) {
                    success(responseObject);
                }
            }else{
                if (failure) {
                    failure(error);
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           // DDLogError(@"Post-taskEnd:%@,param:%@ -withError:%@",task.currentRequest.URL,params,[error localizedDescription]);
            kCloseNet
            if (failure) {
                failure(error);
            }
        }];
    });
        return task;
    
}
+(id)get2Addr:(NSString *)addr params:(id)params success:(SuccessBlock)success failure:(failureBlock)failure{
    NSString* urlStr=[self urlStrWithServletAddr:addr];
    
    NSURLSessionDataTask *task= [sessionManager GET:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //DDLogInfo(@"Get-taskEnd:%@ param:%@ -withResp:%@",task.currentRequest.URL,params,responseObject);
        NSError *error=[self checkSuccessWithDict:responseObject];
        if (!error) {
            if (success) {
                success(responseObject);
            }
        }else{
            if (failure) {
                failure(error);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      //  DDLogError(@"Get-taskEnd:%@,param:%@ -withError:%@",task.currentRequest.URL,params,[error localizedDescription]);
        if (failure) {
            failure(error);
        }
    }];
    return task;
}

#pragma mark upload
+(void)uploadFile:(NSString *)filePath param:(id)param toUrl:(NSString *)url formFileName:(NSString *)fileName progress:(void (^)(CGFloat))progress success:(SuccessBlock)success failure:(failureBlock)failure{
    //DDLogDebug(@"uploadFile:%@ toUrl:%@ param:%@",filePath,url,param);
    NSURL *fileUrl=[NSURL fileURLWithPath:filePath];
    NSError *requestError=nil;
    NSString *urlstr=[self urlStrWithServletAddr:url];
    NSMutableURLRequest *request=[[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlstr parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileURL:fileUrl name:fileName error:nil];
    } error:&requestError];
    if (requestError) {
        if (failure) {
            failure(requestError);
        }
        return;
    }
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [sessionManager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      
                     // NSLog(@"progress:%f",uploadProgress.fractionCompleted);
                      dispatch_async(dispatch_get_main_queue(), ^{
                          if (progress) {
                              progress((float)uploadProgress.fractionCompleted);
                          }
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                  //    DDLogDebug(@"upload-resp:%@,error:%@",responseObject,error);
                      if (error) {
                          if (failure) {
                              failure(error);
                          }
                      } else {
                          NSError *customError=[self checkSuccessWithDict:responseObject];
                          if (customError) {
                              if (failure) {
                                  failure(customError);
                              }
                          }else{
                              if (success) {
                                  success(responseObject);
                              }
                          }
                          
                      }
                  }];
    [uploadTask resume];
    
}

//+(void)testUpload{
//    NSURL *fileUrl=[NSURL fileURLWithPath:@"/Users/hcy/Desktop/1.jpeg"];
//
//    NSURL *uploadUrl=[NSURL URLWithString:@"http://yunzhichina.com:3080/api/v1/res/upload"];
//    NSDictionary*  dict=@{@"email":@"1910496551@qq.com",@"token":@"79e179b3-ec44-4663-82ae-2b122a4d9b2c"};
//    NSError *requestError=nil;
//    NSMutableURLRequest *request=[[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:[uploadUrl absoluteString] parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        [formData appendPartWithFileURL:fileUrl name:@"inputFile" error:nil];
//    } error:&requestError];
//
//    if (requestError) {
//        NSLog(@"requestError");
//    }
//    NSURLSessionUploadTask *uploadTask;
//    uploadTask = [sessionManager
//                  uploadTaskWithStreamedRequest:request
//                  progress:^(NSProgress * _Nonnull uploadProgress) {
//                      // This is not called back on the main queue.
//                      // You are responsible for dispatching to the main queue for UI updates
//                      NSLog(@"progress:%f",uploadProgress.fractionCompleted);
//                      dispatch_async(dispatch_get_main_queue(), ^{
//                          //Update the progress view
//
//                      });
//                  }
//                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//                      if (error) {
//                          NSLog(@"Error: %@", error);
//                      } else {
//                          NSLog(@"%@ %@", response, responseObject);
//                      }
//                  }];
//    [uploadTask resume];
//}

/**
 判断返回数据是否是正确的
 @param dict 返回数据
 @return 错误
 */
+(NSError *)checkSuccessWithDict:(NSDictionary *)dict{
    //类型和nil检查
    NSError *outError=nil;
    if(!dict){
        outError= [YZErrorMaker noRespDataError];
        if ([option shouldTransparentError:&outError resp:dict]) {
            return outError;
        }
    }
    BOOL result=NO;
    for (NSString *validTypeClsStr in option.validRespDataTypes) {
        Class cls=NSClassFromString(validTypeClsStr);
        if (cls && [dict isKindOfClass:cls]) {
            result=YES;
            break;
        }
    }
    if (!result) {
        outError=[YZErrorMaker respTypeError:NSStringFromClass([dict class])];
        if ([option shouldTransparentError:&outError resp:dict]) {
            return outError;
        }
    }
    //   虽然option加了有效性验证。但是现在要判断错误他必须得是json才可以。。别的暂时不支持
    if ([dict isKindOfClass:[NSDictionary class]]==NO) {
        return nil;
    }
    
    //获取成功字段
    
    NSArray *successKeys=[option.successCodeKey componentsSeparatedByString:@"."];
    id successCodeVal=[self getValFromKeyArr:successKeys dict:dict];
    if ([successCodeVal isKindOfClass:[NSError class]]) {
        return successCodeVal;
    }
    //判断成功字段
    BOOL isSuccess=[option.successCodeArr containsObject:successCodeVal];
    
//    for (id successCode in option.successCodeArr) {
//        if ([successCode isEqual:successCodeVal]==NO) {
//            isSuccess=NO;
//            break;
//        }
//    }
    //成功字段处理
    if(!isSuccess){
        NSArray *errorDescKeys=[option.errorDescKey componentsSeparatedByString:@"."];
        
        id errordesc=[self getValFromKeyArr:errorDescKeys dict:dict];
        if ([errordesc isKindOfClass:[NSError class]]) {
            DDLogError(@"errorDescKeyError");
            errordesc=@"";
        }
        //错误key
        if (option.errorCodeKey) {
            NSArray *errorCodeKeys=[option.errorCodeKey componentsSeparatedByString:@"."];
            id errorCodeVal=[self getValFromKeyArr:errorCodeKeys dict:dict];
            if (errorCodeVal) successCodeVal=errorCodeVal;
        }
        if([successCodeVal intValue]){
            outError=[YZErrorMaker respValError:errordesc customCode:[successCodeVal intValue]];
        }else{
        outError=  [YZErrorMaker respValError:errordesc];    
        }
        
        if ([option shouldTransparentError:&outError resp:dict]) {
            return outError;
        }else{
            return nil;
        }
        
    }else{
        return nil;
    }
    
}

+(id)getValFromKeyArr:(NSArray *)keyArr dict:(NSDictionary *)dict{
    
    NSDictionary *tmpDict=dict;
    id retVal=nil;
    for (NSInteger i=0; i<keyArr.count; i++) {
        NSString *key=keyArr[i];
        id val=tmpDict[key];
        if(!val){
            retVal=[YZErrorMaker respFormatError:key];
            break;
        }else{
            retVal=val;
        }
    }
    return  retVal;
    
}


+(NSString *)urlStrWithServletAddr:(NSString *)servletAddr{
    if (servletAddr.length) {
        if ([servletAddr hasPrefix:@"http"]) {
            return servletAddr;
        }else{
            if (option.urlStr.length) {
                return [option.urlStr stringByAppendingString:servletAddr];
            }else{
                return servletAddr;
            }
        }
    }else{
        return option.urlStr;
    }
    
}
@end


#pragma mark option
@implementation YZHttpServiceOption
+(instancetype)defaultOption{
    YZHttpServiceOption *option=[YZHttpServiceOption new];
    
    option.requestType=YZHttpServiceTypeHttp;
    option.responseType=YZHttpServiceTypeHttp;
    option.successCodeArr=@[@200,@204];
    option.successCodeKey=@"body.msgCode";
    option.errorDescKey=@"body.msgDesc";
    
    option.validRespDataTypes=@[NSStringFromClass([NSDictionary class]),NSStringFromClass([NSData class]),NSStringFromClass([NSString class])];
    option.checkedRespDataTypes=@[NSStringFromClass([NSDictionary class])];
    
    return option;
}

-(BOOL)shouldTransparentError:(NSError **)inError resp:(NSDictionary *)dict{
    if (self.errorJudgeClass) {
        NSError *error=*inError;
        SEL selector=@selector(shouldTransparentError:resp:);
       NSMethodSignature *methodSignature=[self.errorJudgeClass methodSignatureForSelector:selector];
        
        NSInvocation *invo=[NSInvocation invocationWithMethodSignature:methodSignature];
        [invo setTarget:self.errorJudgeClass];
        [invo setSelector:selector];
        if (error) {
            [invo setArgument:&error atIndex:2];
        }
        if (dict) {
            [invo setArgument:&dict atIndex:3];
        }
        
        [invo invoke];
        BOOL b=NO;
        [invo getReturnValue:&b];
        if (!b) {
            *inError=nil;
        }
        return b;
    }else{
        return NO;
    }
    
}
@end


