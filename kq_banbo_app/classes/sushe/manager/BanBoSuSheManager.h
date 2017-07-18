//
//  BanBoShuSheManager.h
//  kq_banbo_app
//
//  Created by banbo on 2017/4/18.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "NIMSingleton.h"
typedef NS_ENUM(NSInteger,BanBoShuSheType)
{
    BanBoShuSheTypeSSGL=1,
    BanBoShuSheTypeYDGL,  //宿舍用电管理
};
@interface BanBoDormRequestParma : NSObject
@property(strong,nonatomic)NSNumber *banzhu;
@property(strong,nonatomic)NSNumber *xiaobanzhu;
@property(copy,nonatomic)NSString *user;
@end
typedef void(^BanBoSuSheCompletionBlock)(id data,NSError * error);
@interface BanBoSuSheManager : NIMSingleton
@property(nonatomic,strong)NSNumber * projectId;
/**
 获取工地宿舍有几号楼
 */
-(void)postAllDormCountWithProject:(NSNumber *)project completion:(BanBoSuSheCompletionBlock)completion;
/**
 获取每号楼有多少房间
 */
-(void)postAllRoomWithProject:(NSNumber *)project Bid:(NSNumber *)bid completion:(BanBoSuSheCompletionBlock)completion;
/**
 分配房间
 */
-(void)postRoomWithRid:(NSNumber *)rid withMaxGroupId:(NSNumber *)maxgroupid withGroupId:(NSNumber *)groupid completion:(BanBoSuSheCompletionBlock)completion;
+(NSNumber *)PanDuanBanZu:(NSString *)banzu;
@end
