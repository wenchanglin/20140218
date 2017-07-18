//
//  YZErrorMaker+BanBo.m
//  kq_banbo_app
//
//  Created by hcy on 2017/3/7.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "YZErrorMaker+BanBo.h"
#import "BanBoErrorDefine.h"
@implementation YZErrorMaker (BanBo)
+(NSError *)noUserError{
    return [NSError errorWithDomain:YZRemoteErrorDomain code:BanBoRemoteErrorTokenInvalid userInfo:nil];
}
@end
