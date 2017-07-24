//
//  BanBoHJJKManager.m
//  kq_banbo_app
//
//  Created by banbo on 2017/5/4.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "BanBoHJJKManager.h"
#import <AFNetworking.h>
#import <AFHTTPSessionManager+Synchronous.h>
@implementation BanBoHJJKManager
-(void)postSheBeiListWithProject:(NSNumber *)projectid completion:(BanBoHJJKCompletionBlock)completion
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.completionQueue = dispatch_queue_create("HuanJingListQueue", NULL);
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", nil];
    NSError * error = nil;
    
    NSString * string = [NSString stringWithFormat:@"%@/dhrtd/jsonDhEquipmentList.html",huanjingtou];
    NSDictionary * param = @{@"clientId":projectid};
    NSDictionary * result = [manager syncPOST:string parameters:param task:NULL error:&error];
    if([((NSNumber *)[result objectForKey:@"code"])intValue]==1) {
        NSDictionary * arr = result[@"data"];
        NSArray * arr2 = arr[@"dataList"];
        completion(arr2,nil);
    }
    else if ([((NSNumber *)[result objectForKey:@"code"])intValue]==-1)
    {
        //completion(result[@"message"],nil);
        [HCYUtil showErrorWithStr:result[@"message"]];
    }
    
}
-(void)posthuanJSShiDataWithSheBeiId:(NSNumber *)shibeiId completion:(BanBoHJJKCompletionBlock)completion
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.completionQueue = dispatch_queue_create("HuanJingShiShiQueue", NULL);
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", nil];
    NSError * error = nil;
    NSString * string2 = [NSString stringWithFormat:@"%@/dhrtd/jsonDhRtd.html",huanjingtou];
    NSDictionary * param = @{@"equipmentId":shibeiId};
    NSDictionary * result = [manager syncPOST:string2 parameters:param task:NULL error:&error];
    if([((NSNumber *)[result objectForKey:@"code"])intValue]==1)
    {
//        NSLog(@"环境实时数据:%@",result);
        NSDictionary * dict = result[@"data"];
        completion(dict,nil);
    }
    else if ([((NSNumber *)[result objectForKey:@"code"])intValue]==-1)
    {
        
        //[HCYUtil showErrorWithStr:responseObject[@"message"]];
    }
    
}
@end
