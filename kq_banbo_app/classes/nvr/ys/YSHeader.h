//
//  YSHeader.h
//  kq_banbo_app
//
//  Created by hcy on 2017/3/7.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#ifndef YSHeader_h
#define YSHeader_h

#if 0

#define EZVIZ_GLOBAL_DEMO

#else

#define EZVIZ_OPEN_DEMO

#endif

#define DEMO_ONLINE //线上服务器

#import "EZOpenSDK.h"
#import "EZGlobalSDK.h"
#import "GlobalKit.h"
#ifdef EZVIZ_GLOBAL_DEMO

#define EZOPENSDK [EZGlobalSDK class]

#else

#define EZOPENSDK [EZOpenSDK class]

#endif


#endif /* YSHeader_h */
