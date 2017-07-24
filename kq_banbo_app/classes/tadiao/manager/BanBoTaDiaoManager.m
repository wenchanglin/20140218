//
//  BanBoTaDiaoManager.m
//  kq_banbo_app
//
//  Created by banbo on 2017/6/9.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "BanBoTaDiaoManager.h"
#import <AFHTTPSessionManager+Synchronous.h>
#import <AFNetworking.h>
@implementation BanBoTaDiaoManager

-(void)postTaDiaoListWithProject:(NSNumber *)projectid completion:(BanBoTaDiaoCompletionBlock)completion
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.completionQueue = dispatch_queue_create("TaDiaoListQueue", NULL);
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", nil];
    NSError * error = nil;
    NSString * string = [NSString stringWithFormat:@"%@td/jsonListTowerCrane.html",huanjingtou];
    NSDictionary * param = @{@"clientId":projectid};
    NSDictionary * result = [manager syncPOST:string parameters:param task:NULL error:&error];
    //NSLog(@"1:%@",result);
    if([((NSNumber *)[result objectForKey:@"code"])intValue]==1) {
        NSDictionary * arraay = result[@"data"];
        NSArray * sf = arraay[@"list"];
        completion(sf,nil);
    }
    else if ([((NSNumber *)[result objectForKey:@"code"])intValue]==-1)
    {
        //completion(result[@"message"],nil);
        //[HCYUtil showErrorWithStr:responseObject[@"message"]];
    }
}
-(void)postTaDiaoDataWithSheBeiId:(NSNumber *)shibeiId completion:(BanBoTaDiaoCompletionBlock)completion
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.completionQueue = dispatch_queue_create("TaDiaoShiShiQueue", NULL);
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", nil];
    NSError * error = nil;
    NSString * string2 = [NSString stringWithFormat:@"%@td/jsonGetTowerCraneData.html",huanjingtou];
    NSDictionary * param = @{@"deviceId":shibeiId};
    NSDictionary * result = [manager syncPOST:string2 parameters:param task:NULL error:&error];
    //NSLog(@"2:%@",result);
    if([((NSNumber *)[result objectForKey:@"code"])intValue]==1)
    {
//         NSLog(@"塔吊实时数据:%@",result);
        NSDictionary * dict = result[@"data"];
        completion(dict,nil);
    }
    else if ([((NSNumber *)[result objectForKey:@"code"])intValue]==-1)
    {
        completion(result[@"message"],nil);
        //[HCYUtil showErrorWithStr:responseObject[@"message"]];
    }
}
@end
