//
//  BanBoLoginModel.m
//  kq_banbo_app
//
//  Created by hcy on 2016/11/28.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoLoginModel.h"
@implementation BanBoLoginModel
-(NSString *)description{
    NSString *superDesc=[super description];
    return [NSString stringWithFormat:@"%@ -info:%@",superDesc,_loginInfoArr];
    
}
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"loginInfoArr":@"result"};
}
+(NSDictionary *)mj_objectClassInArray{
    return @{@"loginInfoArr":@"BanBoLoginInfoModel"};
    
}
@end
@implementation BanBoLoginInfoModel
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super init]) {
        self.title=[aDecoder decodeObjectForKey:@"title"];
        self.subtitle=[aDecoder decodeObjectForKey:@"subtitle"];
        self.token=[aDecoder decodeObjectForKey:@"token"];
        NSData *userData=[aDecoder decodeObjectForKey:@"user"];
        if (userData) {
            self.user=[NSKeyedUnarchiver unarchiveObjectWithData:userData];
        }
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.title.length?self.title:@""  forKey:@"title"];
    [aCoder encodeObject:self.subtitle.length?self.subtitle:@""  forKey:@"subtitle"];
    [aCoder encodeObject:self.token.length?self.token:@""  forKey:@"token"];
    if (self.user) {
        NSData *userData=[NSKeyedArchiver archivedDataWithRootObject:self.user];
        [aCoder encodeObject:userData  forKey:@"user"];
    }
}
-(NSString *)description{
    NSString *superDesc=[super description];
    return [NSString stringWithFormat:@"%@-title:%@,subTitle:%@,user:%@",superDesc,_title,_subtitle,_user];
}

@end
@implementation BanBoUser
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.username=[coder decodeObjectForKey:@"username"];
        self.userpsw=[coder decodeObjectForKey:@"userpsw"];
    
        self.luid=[[coder decodeObjectForKey:@"luid"] integerValue];
        self.roletype=[[coder decodeObjectForKey:@"roletype"] integerValue];
        self.contractorid=[[coder decodeObjectForKey:@"contractorid"] integerValue];
        self.clientid=[[coder decodeObjectForKey:@"clientid"] integerValue];
        self.addtime=[[coder decodeObjectForKey:@"addtime"] integerValue];
        self.remark=[coder decodeObjectForKey:@"remark"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:@(self.luid) forKey:@"luid"];
    [aCoder encodeObject:self.username forKey:@"username"];
    [aCoder encodeObject:self.userpsw forKey:@"userpsw"];
    [aCoder encodeObject:@(self.roletype) forKey:@"roletype"];
    [aCoder encodeObject:@(self.contractorid) forKey:@"contractorid"];
    [aCoder encodeObject:@(self.clientid) forKey:@"clientid"];
    [aCoder encodeObject:@(self.addtime) forKey:@"addtime"];
    [aCoder encodeObject:self.remark forKey:@"remark"];
}

-(NSString *)description{
    NSString *superDesc=[super description];
    return [NSString stringWithFormat:@"%@-%@",superDesc,[[self mj_keyValues] mj_JSONString]];
}

@end
