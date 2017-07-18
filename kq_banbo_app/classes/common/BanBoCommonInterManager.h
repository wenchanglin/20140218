//
//  BanBoCommonInterManager.h
//  kq_banbo_app
//
//  Created by hcy on 2017/1/19.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "NIMSingleton.h"
@class BanboBlueToothInfo;
typedef void (^BanBoCommonInterCompletionBlock)(id data,NSError *error);
@interface BanBoCommonInterManager : NIMSingleton
-(void)checkBlueToothWithInfo:(BanboBlueToothInfo *)info completion:(BanBoCommonInterCompletionBlock)completion;
@end


/**
 蓝牙信息
 */
@interface BanboBlueToothInfo : NSObject
@property(copy,nonatomic)NSString *name;
@property(copy,nonatomic)NSString *identifier;
@end
