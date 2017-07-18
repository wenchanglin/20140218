//
//  BanBoShiminUser.m
//  kq_banbo_app
//
//  Created by hcy on 2016/12/6.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoShiminDetail.h"

@implementation BanBoShiminDetail
+(instancetype)instWithResp:(NSDictionary *)resp{
    return [BanBoShiminDetail mj_objectWithKeyValues:resp];
}
+(NSDictionary *)mj_objectClassInArray{
    return @{@"result":@"BanBoShiminUser"};
}
@end
@implementation BanBoShiminUser

@end
@implementation BanboShiminUserCellObj
-(id)sortKey{
    return @(self.user.WorkNo);
}

-(NSString *)groupTitle{
    return @"";
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.font=[YZLabelFactory normalFont];
    }
    return self;
}
-(NSString *)titleAtIndex:(NSInteger)idx{

    switch (idx) {
        case 0:
        {
            return [NSString stringWithFormat:@"%ld",(long)self.xuhao];
        }
            break;
        case 1:
        {
            return [NSString stringWithFormat:@"%ld",(long)self.user.WorkNo];
        }
            break;
        case 2:
        {
            return self.user.UserName;
        }
            break;
    }
    return [self valAtIdx:idx];;
}
-(NSString *)valAtIdx:(NSInteger)idx{
    switch (self.type) {
        case BanBoShiminTypeGZLB:
        {
            if (idx==3) {
                return [self strWithMoney:self.user.PayThisMonth];
            }
            if (idx==4) {
                return [self strWithMoney:self.user.PayLastMonth];
            }
            if (idx==5) {
                return [self strWithMoney:self.user.PayYear];
    
            }
        }
            break;
        case BanBoShiminTypeGRMC:
        {
            if (idx==3) {
                return self.user.GroupName;
            }
            if (idx==4) {
                return self.user.SubGroupName;
            }
            if (idx==5) {
                NSArray *arr= [self.user.EnterDate componentsSeparatedByString:@" "];
                return arr.count?arr[0]:self.user.EnterDate;
            }
        }
            break;
        case BanBoShiminTypeXXGL:
        {
            if (idx==3) {
                return self.user.ContractDate;
            }
            if (idx==4) {
                return self.user.InsuranceDate;
            }
        }
            break;
        case BanBoShiminTypeKQGL:
        {
            if (idx==3) {
                return [NSString stringWithFormat:@"%ld",(long)self.user.CheckThisMonth];
            }
            if (idx==4) {
                return [NSString stringWithFormat:@"%ld",(long)self.user.CheckLastMonth];
            }
            if (idx==5) {
                return [NSString stringWithFormat:@"%ld",(long)self.user.CheckYear];
            }
        }
            break;
        case BanBoShiminTypeYHKH:
        {
            if (idx==3) {
                return self.user.BankCardNo;
            }
            if (idx==4) {
                return self.user.BankName;
            }
        }
            break;
        case BanBoShiminTypeJKGL:
        {
            if (idx==3) {
                return  [self healthStrWithField:self.user.CardIdUpload useFieldVal:NO];
            }
            if (idx==4) {
                return  [self healthStrWithField:self.user.LifePicUpload useFieldVal:NO];
            }
            if (idx==5) {
                return [self healthStrWithField:self.user.BloodMax useFieldVal:YES];
            }
            if (idx==6) {
                return [self healthStrWithField:self.user.HeartRate useFieldVal:YES];
            }
            
            
        }
        default:
            break;
    }
    return @"";
}
-(NSString *)healthStrWithField:(NSString *)field useFieldVal:(BOOL)use{
    if(field && field.length){
        if (![field isEqualToString:@"无"]) {
            if (use) {
                return field;
            }else{
                return @"有";
            }
        }
    }
    return @"无";
    
}
-(NSString *)strWithMoney:(CGFloat)money{
    if (money==(NSInteger)money) {
        return [NSString stringWithFormat:@"%ld",(long)money];
    }else{
        return [NSString stringWithFormat:@"%.2f",money];
    }
}
//-(CGFloat)cellHeight{
//    CGFloat cellHeight=[super cellHeight];
//    DDLogDebug(@"BaoBoShimMinCellObj:%@ getCellHeight:%f",self,cellHeight);
//    return cellHeight;
//}
//-(void)setCellHeight:(CGFloat)cellHeight{
//    DDLogDebug(@"BaoBoShimMinCellObj:%@ setCellHeight:%f",self,cellHeight);
//    [super setCellHeight:cellHeight];
//}
-(UIFont *)fontAtIndex:(NSInteger)idx{
    return self.font;
}
@end
