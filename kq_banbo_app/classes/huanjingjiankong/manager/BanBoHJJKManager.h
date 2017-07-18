//
//  BanBoHJJKManager.h
//  kq_banbo_app
//
//  Created by banbo on 2017/5/4.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIMSingleton.h"
typedef void(^BanBoHJJKCompletionBlock) (id data,NSError *error);
@interface BanBoHJJKManager : NIMSingleton
@property(nonatomic,strong)NSNumber * projectId;
/**
 获取环境设备列表
 */
-(void)postSheBeiListWithProject:(NSNumber *)projectid completion:(BanBoHJJKCompletionBlock)completion;
-(void)posthuanJSShiDataWithSheBeiId:(NSNumber *)shibeiId completion:(BanBoHJJKCompletionBlock)completion;
@end
