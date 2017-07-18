//
//  BanBoBanzhuObj.m
//  kq_banbo_app
//
//  Created by hcy on 2016/12/5.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoBanzhuObj.h"

@implementation BanBoBanzhuObj
+(instancetype)instWithResp:(NSDictionary *)resp{
    return [BanBoBanzhuObj mj_objectWithKeyValues:resp];
}
+(NSDictionary *)mj_objectClassInArray{
    return @{@"result":@"BanBoBanzhuItem"};
}
-(NSString *)description{
    NSString *superDesc=[super description];
    return [NSString stringWithFormat:@"self:%@,result:%@",superDesc,_result];
}
@end

@implementation BanBoBanzhuItem
-(NSString *)description{
    return [[self mj_keyValues] mj_JSONString];
}

-(BOOL)isDefaultItem{
    return self.gid==-1;
}
- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    }else if([other isKindOfClass:[self class]]){
        BanBoBanzhuItem *item=(BanBoBanzhuItem *)other;
        return item.gid==self.gid;
    }else{
        return NO;
    }
}

- (NSUInteger)hash
{
    return self.gid;
}
@end
