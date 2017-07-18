//
//  YZErrorMaker.h
//  kq_banbo_app
//
//  Created by hcy on 2016/11/29.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YZErrorDefines.h"
extern NSString *const YZLocalErrorDomain;
extern NSString *const YZRemoteErrorDomain;
@interface YZErrorMaker : NSObject


/**
 没有返回数据

 @return 错误
 */
+(NSError *)noRespDataError;
/**
 服务器返回数据类型不对
 @param desc 自定义描述
 @return 错误
 */
+(NSError *)respTypeError:(NSString *)desc;


/**
 返回的数据格式不对

 @param desc 自定义描述
 @return 错误
 */
+(NSError *)respFormatError:(NSString *)desc;

/**
 返回值不对
 
 @param desc 自定义描述
 @return 错误
 */
+(NSError *)respValError:(NSString *)desc;
/**
 返回值不对
 
 @param desc 自定义描述
 @param code 错误code
 @return 错误
 */
+(NSError *)respValError:(NSString *)desc customCode:(NSInteger)code;



/**
 自定义服务器错误

 @param reason 理由
 @param code code
 @return 错误
 */
+(NSError *)customRemoteErrorWithReason:(NSString *)reason code:(NSInteger)code;
@end
