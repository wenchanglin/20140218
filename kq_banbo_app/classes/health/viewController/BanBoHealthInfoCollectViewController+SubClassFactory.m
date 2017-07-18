//
//  BanBoHealthInfoCollectViewController+SubClassFactory.m
//  kq_banbo_app
//
//  Created by hcy on 2016/12/9.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoHealthInfoCollectViewController+SubClassFactory.h"

#import "BanBoDailyPhotoCollectViewController.h"
#import "BanBoCardInfoCollectViewController.h"
#import "BanBoBloodPressureCollectViewController.h"
#import "BanBoCardiogramCollectViewController.h"
@implementation BanBoHealthInfoCollectViewController (SubClassFactory)
+(instancetype)dailyPhoto{
    return [BanBoDailyPhotoCollectViewController new];
}
+(instancetype)CardInfo{
    return [BanBoCardInfoCollectViewController new];
}
+(instancetype)BloodPressure{
    return [BanBoBloodPressureCollectViewController new];
}
+(instancetype)Cardiogram{
    return [BanBoCardiogramCollectViewController new];
}
+(instancetype)testObj{
    return [BanBoHealthInfoCollectViewController new];
}
@end
