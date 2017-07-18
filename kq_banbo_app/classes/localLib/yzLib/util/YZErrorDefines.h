//
//  YZErrorDefines.h
//  BingMall
//
//  Created by hcy on 2017/2/7.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#ifndef YZErrorDefines_h
#define YZErrorDefines_h
//错误定义
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,YZLocalErrorCode){
    YZLocalErrorCodeParam
};

typedef NS_ENUM(NSInteger,YZRemoteErrorCode){
    YZRemoteErrorCodeNoRespData=2000,
    YZRemoteErrorCodeRespTypeError,
    YZRemoteErrorCodeRespFormatError,
    YZRemoteErrorCodeRespValError,
    YZRemoteErrorCodeUnKnown=9999
};

#endif /* YZErrorDefines_h */
