//
//  BanBoHealthInfoCollectViewController+SubClassFactory.h
//  kq_banbo_app
//
//  Created by hcy on 2016/12/9.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoHealthInfoCollectViewController.h"

/**
 方便调用的地方用别的导入太多头文件
 */
@interface BanBoHealthInfoCollectViewController (SubClassFactory)
+(instancetype)dailyPhoto;
+(instancetype)CardInfo;
+(instancetype)BloodPressure;
+(instancetype)Cardiogram;
+(instancetype)testObj;
@end
