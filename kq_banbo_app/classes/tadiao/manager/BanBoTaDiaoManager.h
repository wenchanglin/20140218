//
//  BanBoTaDiaoManager.h
//  kq_banbo_app
//
//  Created by banbo on 2017/6/9.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIMSingleton.h"
@interface BanBoTaDiaoManager : NIMSingleton
typedef void(^BanBoTaDiaoCompletionBlock)(id data,NSError * error);
@property(nonatomic,strong)NSNumber * projectId;
-(void)postTaDiaoListWithProject:(NSNumber *)projectid completion:(BanBoTaDiaoCompletionBlock)completion;
-(void)postTaDiaoDataWithSheBeiId:(NSNumber *)shibeiId completion:(BanBoTaDiaoCompletionBlock)completion;

@end
