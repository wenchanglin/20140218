//
//  BanBoCompanyInfoModel.m
//  kq_banbo_app
//
//  Created by hcy on 2016/11/29.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoHomeDetail.h"
@implementation BanBoHomeDetail
+(instancetype)instWithResp:(NSDictionary *)resp contrId:(NSNumber *)contrId{
    BanBoHomeDetail *info=[BanBoHomeDetail mj_objectWithKeyValues:resp];
    [info readySub:resp contrId:contrId];
    return info;
}
-(void)readySub:(NSDictionary *)dict contrId:(NSNumber *)contrId{
    NSArray *resultArr=dict[@"result"];
    NSMutableArray *tmpInfoArrM=[NSMutableArray array];
    for (NSDictionary *result in resultArr) {
        NSString *key=result[@"type"];
        NSString *subKey=result[@"grouptype"];
        if ([key isEqualToString:@"total"]) {
            BanBoHomeDetailInfoTotal *total=[BanBoHomeDetailInfoTotal mj_objectWithKeyValues:result];
            self.totalInfo=total;
        }else if ([key isEqualToString:@"detail"]){
            if ([subKey isEqualToString:CompanyKey]) {
                BanBoHomeDetailInfoSubCompany *subCompany=[BanBoHomeDetailInfoSubCompany mj_objectWithKeyValues:result];
                [tmpInfoArrM addObject:subCompany];
            }else{
                self.subInfoIsProject=YES;
                BanBoHomeDetailInfoProject *project=[BanBoHomeDetailInfoProject mj_objectWithKeyValues:result];
                project.ContractorId=[contrId integerValue];
                [tmpInfoArrM addObject:project];
            }
        }
    }
    self.subInfo=[tmpInfoArrM copy];
}
-(NSString *)description{
    NSString *superDesc=[super description];
    return [NSString stringWithFormat:@"%@,total:%@,detail:%@",superDesc,_totalInfo,_subInfo];
}
-(NSUInteger)hash{
    return [self.objIdentifier hash];
}
-(BOOL)isEqual:(id)object{
    if ([object isKindOfClass:[self class]]) {
        return [self.objIdentifier isEqualToString:[(BanBoHomeDetail *)object objIdentifier]];
    }
    return NO;
}
@end
#pragma mark view
@implementation BanBoHomeDetailInfoCellObj
-(instancetype)initWithModel:(BanBoHomeDetailInfoBase *)model{
    if (self=[super init]) {
        self.data=model;
    }
    return self;
}
-(NSString *)cellClass{
    if ([self isProjectModel]) {
        return @"BanBoHomeProjectCell";
    }else{
        return @"BanboHomeSubCompanyCell";
    }
}
-(CGFloat)cellHeight{
    if ([self isProjectModel]) {
        return 31.f;
    }else{
        return 44.f;
    }
}
-(BOOL)isProjectModel{
    return [self.data isKindOfClass:[BanBoHomeDetailInfoProject class]];
}
-(NSString *)reuseId{
    return [self cellClass];
}
-(NSString *)groupTitle{
    return @"1";
}
-(id)sortKey{
    return @(self.sortNum);
}
-(NSString *)description{
    NSString *superDesc=[super description];
    return [NSString stringWithFormat:@"%@-:%@,sortNum:%ld",superDesc,[_data description],(long)self.sortNum];
    
}
-(NSUInteger)hash{
    return [self.data hash];
}
-(BOOL)isEqual:(id)object{
    if ([object isKindOfClass:[self class]]) {
        return [self.data isEqual:[(BanBoHomeDetailInfoCellObj *)object data]];
    }else{
        return NO;
    }
}
@end

#pragma mark 子类
@implementation BanBoHomeDetailInfoBase
-(NSString *)description{
    return [[self mj_keyValues] mj_JSONString];
}
@end
@implementation BanBoHomeDetailInfoTotal
@end
@implementation BanBoHomeDetailInfoSubCompany
-(NSUInteger)hash{
    return self.ContractorId;
}
-(BOOL)isEqual:(id)object{
    if ([object isKindOfClass:[self class]]) {
       return  self.ContractorId ==[(BanBoHomeDetailInfoSubCompany *)object ContractorId];
    }else{
        return NO;
    }
}
@end
@implementation BanBoHomeDetailInfoProject
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"name":@"ProjectName"};
}
-(NSUInteger)hash{
    return self.ClientId;
}
-(BOOL)isEqual:(id)object{
    if ([object isKindOfClass:[self class]]) {
        return  self.ClientId ==[(BanBoHomeDetailInfoProject *)object ClientId];
    }else{
        return NO;
    }
}
@end










