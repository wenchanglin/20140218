//
//  BanBoProjectManager.h
//  kq_banbo_app
//
//  Created by hcy on 2016/12/1.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "NIMSingleton.h"
#import "BanBoRecordsObj.h"
typedef void(^BanBoProjectManagerCompletionBlock) (id data,NSError *error);
typedef void(^BanBoProjectManagerUploadProgressBlock) (CGFloat progress);

@interface BanBoProjectManager : NIMSingleton

-(void)getRecordsTotalWithProjectId:(NSNumber *)projectId completion:(BanBoProjectManagerCompletionBlock)completion;
-(void)getRecordsDetailWithProjectId:(NSNumber *)projectId completion:(BanBoProjectManagerCompletionBlock)completion;
-(void)getHealthDataWithProjectId:(NSNumber *)projectId completion:(BanBoProjectManagerCompletionBlock)completion;

-(void)addRecordPreForProject:(NSNumber *)projectId completion:(BanBoProjectManagerCompletionBlock)completion;
-(void)getValidCardNumForProject:(NSNumber *)projectId completion:(BanBoProjectManagerCompletionBlock)completion;
-(void)uploadImage:(UIImage *)image forPicKey:(NSString *)picKey forProject:(NSNumber *)projectId progress:(BanBoProjectManagerUploadProgressBlock)progress completion:(BanBoProjectManagerCompletionBlock)completion;
-(void)saveReport:(NSDictionary *)personInfo forProject:(NSNumber *)project completion:(BanBoProjectManagerCompletionBlock)completion;
@end
