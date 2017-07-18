//
//  BanBoShuSheManager.m
//  kq_banbo_app
//
//  Created by banbo on 2017/4/18.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "BanBoSuSheManager.h"
#import "BanBoUserInfoManager.h"
#import "YZHttpService.h"
#import "BanBoRecordsObj.h"
@implementation BanBoSuSheManager
-(void)postAllDormCountWithProject:(NSNumber *)project completion:(BanBoSuSheCompletionBlock)completion
{
    [YZHttpService post2Addr:Inter_RequestAllDorm params:@{@"clientid":project} success:^(id responseObject) {
        NSArray * val = responseObject[@"result"];
        // DDLogInfo(@"获取宿舍所有楼:%@",val);
        completion(val,nil);
    } failure:^(NSError *error) {
        //        DDLogError(@"获取宿舍楼失败:%@",error);
        completion(nil,error);
    }];
}
-(void)postAllRoomWithProject:(NSNumber *)project Bid:(NSNumber *)bid completion:(BanBoSuSheCompletionBlock)completion
{
   
    [YZHttpService post2Addr:Inter_RequestAllRoom params:@{@"clientid":project,@"bid":bid} success:^(id responseObject) {
        NSArray * vals = responseObject[@"result"];
        //DDLogInfo(@"获取每楼多少房间成功:%@",vals);
        completion(vals,nil);
    } failure:^(NSError *error) {
        //DDLogError(@"获取每楼多少房间失败:%@",error);
        completion(nil,error);
    }];
    
}
-(void)postRoomWithRid:(NSNumber *)rid withMaxGroupId:(NSNumber *)maxgroupid withGroupId:(NSNumber *)groupid completion:(BanBoSuSheCompletionBlock)completion
{

    [YZHttpService post2Addr:Inter_AssignGroupToRoom params:@{@"rid":rid,@"maxgroupid":maxgroupid,@"groupid":groupid} success:^(id responseObject) {
         // DDLogInfo(@"分配房间成功:%@",responseObject);
        completion(responseObject[@"resultDes"],nil);
    } failure:^(NSError *error) {
         //DDLogError(@"分配房间失败:%@",error);
        completion(error,nil);
    }];
}
+(NSNumber *)PanDuanBanZu:(NSString *)banzu
{
    NSNumber * groupid;
    if ([banzu isEqualToString:@"泥工"]) {
        groupid = @8;
    }
    return groupid;
}
-(NSMutableDictionary *)param{
    NSMutableDictionary *param= [[BanBoUserInfoManager sharedInstance] userInfoParam];
    [param setObject:self.projectId?:@(-1) forKey:@"clientid"];
    
    return param;
}
@end
@implementation BanBoDormRequestParma
-(instancetype)init
{
    if (self = [super init]) {
        self.banzhu = (@1);
        self.xiaobanzhu = @(-1);
        self.user = @"";
    }
    return self;
}

@end
