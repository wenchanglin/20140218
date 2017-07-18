//
//  BanBoHealthManager.h
//  kq_banbo_app
//
//  Created by hcy on 2017/1/6.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "NIMSingleton.h"
#import "BloodPressureBlueTooth.h"
#import "IDCardBlueTooth.h"
@class BanBoShiminUser;
typedef void(^BanBoHealthManagerUploadProgressBlock) (CGFloat progress);
typedef void(^BanBoHealthManagerCompletionBlock) (id data,NSError *error);
@interface BanBoHealthManager : NIMSingleton

/**
 添加血压信息

 @param info 信息
 @param projectId 工地id
 @param userId 用户id
 @param completion 回调
 */
-(void)addBloodPressure:(BloodPressureInfo *)info forProject:(NSNumber *)projectId user:(NSNumber *)userId completion:(BanBoHealthManagerCompletionBlock)completion;

-(void)getBloodPressure4User:(BanBoShiminUser *)user inProject:(NSNumber *)projectId completion:(BanBoHealthManagerCompletionBlock)completion;
/**
 获取头像
 
 @param headPic 头像
 @param cardId 结果字符串
 @param projectId 工程id
 @param completion 回调
 */
-(void)getHeadPic:(NSString *)headPic forUser:(NSString *)cardId inProject:(NSNumber *)projectId completion:(BanBoHealthManagerCompletionBlock)completion;
/**
 上传生活照

 @param image 照片
 @param cardId 身份证
 @param projectId 工地
 @param progress 进度
 @param completion 回调
 */
-(void)uploadDailyImage:(UIImage *)image forUser:(NSString *)cardId inProject:(NSNumber *)projectId   progres:(BanBoHealthManagerUploadProgressBlock)progress completion:(BanBoHealthManagerCompletionBlock)completion;
/**
 上传身份证照片

 @param images 正面+反面
 @param cardId 身份证
 @param projectId 工地
 @param progress 进度
 @param completion 回调
 */
-(void)uploadCardImages:(NSArray *)images forUser:(NSString *)cardId inProject:(NSNumber *)projectId   progres:(BanBoHealthManagerUploadProgressBlock)progress completion:(BanBoHealthManagerCompletionBlock)completion;

/**
 添加心电图信息

 @param hr hr
 @param result 结果字符串
 @param userId 用户ID
 @param projectId 工程id
 @param completion 回调
 */
-(void)addCardiorgramWithHR:(NSNumber *)hr result:(NSString *)result forUser:(NSInteger )userId inProject:(NSNumber *)projectId completion:(BanBoHealthManagerCompletionBlock)completion;
/**
 获取生活照图片
 @param lifepicture 生活照接口
 @param cardId 用户ID
 @param completion 回调
 */
-(void)getLifePic:(NSString *)lifepicture forUser:(NSString * )cardId completion:(BanBoHealthManagerCompletionBlock)completion;
/**
 获取身份证正反面
 @param cardpic 身份证接口
 @param cardId 用户ID
 @param type _1 正面 _2 反面
 @param completion 回调
 */
-(void)getCardPic:(NSString *)cardpic forUser:(NSString *)cardId  Type:(NSString *)type completion:(BanBoHealthManagerCompletionBlock)completion;
@end
