//
//  YZErrorMaker.m
//  kq_banbo_app
//
//  Created by hcy on 2016/11/29.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "YZErrorMaker.h"
NSString *const YZLocalErrorDomain=@"YZLocalErrorDomain";
NSString *const YZRemoteErrorDomain=@"YZRemoteErrorDomain";
@implementation YZErrorMaker


#pragma mark remoteError
+(NSError *)noRespDataError{
    return [self remoteErrorWithCode:YZRemoteErrorCodeNoRespData reason:[self descWithDefault:NSLocalizedString(@"没有返回数据", nil) custom:nil]];
}
+(NSError *)respTypeError:(NSString *)desc{
    return [self remoteErrorWithCode:YZRemoteErrorCodeRespTypeError reason:[self descWithDefault:NSLocalizedString(@"返回类型不对", nil) custom:desc]];
}
+(NSError *)respFormatError:(NSString *)desc{
    return [self remoteErrorWithCode:YZRemoteErrorCodeRespTypeError reason:[self descWithDefault:NSLocalizedString(@"返回值结构不正确", nil) custom:desc]];
}
+(NSError *)respValError:(NSString *)desc{
   return  [self respValError:desc customCode:YZRemoteErrorCodeRespValError];
}
+(NSError *)respValError:(NSString *)desc customCode:(NSInteger)code{
      return [self remoteErrorWithCode:code reason:[self descWithDefault:NSLocalizedString(@"返回值不正确", nil) custom:desc]];
}

+(NSError *)customRemoteErrorWithReason:(NSString *)reason code:(NSInteger)code{
    return [self remoteErrorWithCode:code?:YZRemoteErrorCodeUnKnown reason:reason];
}


#pragma mark private
+(NSString *)descWithDefault:(NSString *)defaultDesc custom:(NSString *)customDesc{
    if (customDesc) {
        return customDesc;
    }else{
        return defaultDesc;
    }
    
}
+(NSError *)remoteErrorWithCode:(NSInteger)code reason:(NSString *)reason{
    return [NSError errorWithDomain:YZRemoteErrorDomain code:code userInfo:@{NSLocalizedDescriptionKey:reason}];
    
}
@end
