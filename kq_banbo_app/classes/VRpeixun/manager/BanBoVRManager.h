//
//  BanBoVRManager.h
//  kq_banbo_app
//
//  Created by banbo on 2017/6/23.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "NIMSingleton.h"
#import "NIMSingleton.h"
typedef void(^BanBoVRManagerCompletion)(id data,NSNumber * allrow,NSError *error);
@interface BanBoVRManager : NIMSingleton
typedef NS_ENUM(NSUInteger,BanBoVRType) {
    BanBoVRTypeTJ= 1,//VR培训统计
    BanBoVRTypeDetail,//VR培训详情页
};
-(void)postVRTongJiWithProjectId:(NSNumber *)projectid completion:(BanBoVRManagerCompletion)completion;
-(void)postVRXiangQingWithParameter:(NSDictionary *)parameter completion:(BanBoVRManagerCompletion)completion;
-(void)postVRXiangqingSubWithParameter:(NSDictionary *)parameter completion:(BanBoVRManagerCompletion)completion;
@end
