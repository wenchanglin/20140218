//
//  NVRSDKManager.h
//  kq_banbo_app
//
//  Created by hcy on 2017/2/20.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NVRLoginInfo,NVRChannel;
typedef void(^NVRLoginCompletionBlock)(NSArray *channels,NSError*error);
/**
 跟第三方交互用（别问名字为什么这样。呵呵）
 */
@interface NVRSDKManager : NSObject

/**
 释放资源
 */
-(void)clean;
/**
 登录设备

 @param info 设备信息
 @param completion 回调（包含所有的通道和所悟）
 */
-(void)loginDeviceWithInfo:(NVRLoginInfo *)info completion:(NVRLoginCompletionBlock)completion;

/**
 播放某个通道

 @param channel 通道
 @param view    视图
 @param completion 结果
 */
-(void)playChanel:(NVRChannel *)channel onView:(UIView *)view completion:(void(^)(NSError *error))completion;
@end


/**
 登录信息基础类
 */
@interface NVRLoginInfo : NSObject

@end

/**
 海康登录信息
 */
@interface HKLoginInfo : NVRLoginInfo
@property(copy,nonatomic)NSString *remoteUrl;
@property(assign,nonatomic)int port;
@property(copy,nonatomic)NSString *userName;
@property(copy,nonatomic)NSString *pwd;
@end
/**
 萤石登录信息
 */
@interface YSLoginInfo:NVRLoginInfo
@property(copy,nonatomic)NSString *appKey;
@property(copy,nonatomic)NSString *token;

@end

@interface NVRChannel : NSObject
@end
/**
 数字通道
 */
@interface HKChannel : NVRChannel
@property(copy,nonatomic)NSString *name;
@property(assign,nonatomic)int num;
-(NSString *)channelNumStr;
@end
