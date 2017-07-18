//
//  BanBoNVRInfo.m
//  kq_banbo_app
//
//  Created by hcy on 2017/2/15.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "BanBoNVRInfo.h"

@implementation BanBoNVRInfo
#pragma mark 构造
+(instancetype)instWithResp:(NSDictionary *)resp{
    return [[self alloc] initWithResp:resp];
    
}
-(instancetype)initWithResp:(NSDictionary *)resp{
    if (self=[super init]) {
        self.clientid=[resp[@"clientid"] integerValue];
        self.localAddress=[self addressWithStr:resp[@"localaddress"]];
        self.nid=[resp[@"nid"] integerValue];
        self.note=resp[@"note"];
        self.remoteAddress=[self addressWithStr:resp[@"remoteaddress"]];
        self.ssid=resp[@"ssid"];
    }
    return self;
}
-(BanBoNVRInfoAddress)addressWithStr:(NSString *)str{
    BanBoNVRInfoAddress address={"",1};
    
    NSArray *strArr=[str componentsSeparatedByString:@":"];
    if (strArr.count==2) {
        address.ipaddr=(char *)[strArr[0] UTF8String];
        address.port=[strArr[1] intValue];
    }
    
    return address;
}

@end
