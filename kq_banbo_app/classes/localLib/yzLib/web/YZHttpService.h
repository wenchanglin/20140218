//
//  YZHttpService.h
//  YZWaimaiCustomer
//
//  Created by hcy on 16/8/23.
//  Copyright © 2016年 hcy@yz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class YZHttpServiceOption;
typedef void(^YZHttpCompletionBlock)(id data,NSError *error);
@protocol YZHttpErrorExec <NSObject>
@required

/**
 是否需要透传这个错误

 @param error 错误
 @param resp 返回的json（如果error不够用。可以通过这个来判断）
 @return 是否需要
 */
+(BOOL)shouldTransparentError:(NSError *)error resp:(NSDictionary *)resp;

@end

/**
 *  网络服务类，不允许继承
 */
@interface YZHttpService : NSObject
typedef NS_ENUM(NSInteger, YZHttpServiceType){
    YZHttpServiceTypeHttp=0,
    YZHttpServiceTypeJson,
};
typedef void(^SuccessBlock)(id responseObject);
typedef void(^failureBlock)(NSError *error);


/**
 取消所有请求
 */
+(void)cleanAllRequest;

/**
 是否有网络
 
 @return 是否有网络
 */
+(BOOL)haveInternet;

+(void)setOption:(YZHttpServiceOption *)option;

/**
 *  使用http方式封装body请求
 *
 *  @param addr    地址
 *  @param params  参数
 *  @param success 成功回调
 *  @param failure 失败回调
 *
 *  @return task
 */
+(id)post2Addr:(NSString *)addr params:(id)params success:(SuccessBlock)success failure:(failureBlock)failure;


/**
 发送get请求
 
 @param addr 地址
 @param params 参数
 @param success 成功回调
 @param failure 失败回调
 @return task
 */
+(id)get2Addr:(NSString *)addr params:(id)params success:(SuccessBlock)success failure:(failureBlock)failure;

/**
 上传文件
 
 @param filePath 本地地址
 @param param 参数
 @param url url
 @param fileName 表单中文件名
 @param progress 进度回调
 @param success 成功回调
 @param failure 失败回调
 */
+(void)uploadFile:(NSString *)filePath param:(id)param toUrl:(NSString *)url formFileName:(NSString *)fileName progress:(void(^)(CGFloat progress))progress success:(SuccessBlock)success failure:(failureBlock)failure;
@end

/**
 网络服务配置
 */
@interface YZHttpServiceOption : NSObject

/**
 服务器地址
 */
@property(copy,nonatomic)NSString *urlStr;
/**
 默认配置
 request=http
 respone=http
 successCode=200，204
 successKey=body.msgCode
 errorDescKey=body.msgDesc
 validRespDataTypes  dictionary,nsdata,nsstring
 checkedRespDataType  dictionary
 errorJudgeClass nil
 @return 默认配置
 */
+(instancetype)defaultOption;
/**
 请求类型
 */
@property(assign,nonatomic)YZHttpServiceType requestType;
/**
 返回类型
 */
@property(assign,nonatomic)YZHttpServiceType responseType;
/**
 成功的code值判断（可以是nsstring，也可以是nsnumber。也可以混着来~）
 */
@property(strong,nonatomic)NSArray *successCodeArr;

/**
 返回值从用来判断的key。支持.语法
 */
@property(copy,nonatomic)NSString *successCodeKey;

/**
 错误码的key
 默认是nil。因为一般正常的服务器就应该是一个返回码。
 但是真碰到奇葩也没办法。。
 */
@property(copy,nonatomic)NSString *errorCodeKey;
/**
 如果不正确用来封装错误的描述key 。支持.语法
 */
@property(copy,nonatomic)NSString *errorDescKey;

/**
 认为有效的返回类型
 */
@property(strong,nonatomic)NSArray *validRespDataTypes;
/**
 需要进行错误check的responseData类型
 */
@property(strong,nonatomic)NSArray *checkedRespDataTypes;

/**
 错误判断类
 */
@property(strong,nonatomic)Class errorJudgeClass;
@end

