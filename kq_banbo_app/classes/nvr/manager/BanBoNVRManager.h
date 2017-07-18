//
//  BanBoNVRManager.h
//  kq_banbo_app
//
//  Created by hcy on 2017/2/22.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "NIMSingleton.h"
#import "BanBoNVRInfo.h"
typedef void(^BanBoNVRCompletionBlock)(id data,NSError *error);
@interface BanBoNVRManager : NIMSingleton
//海康sdk的
-(void)getNVRInfoWithProject:(NSNumber *)projectId completion:(BanBoNVRCompletionBlock)completion;
-(void)updateHiddenChannels:(NSString *)notes forProject:(NSNumber *)projectId completion:(BanBoNVRCompletionBlock)completion;
//萤石sdk的
-(void)getYSNVRInfoWithProject:(NSNumber *)projectId completion:(BanBoNVRCompletionBlock)completion;
-(void)getYSSerialNumbWithProject:(NSNumber *)projectId completion:(BanBoNVRCompletionBlock)completion;
@end
