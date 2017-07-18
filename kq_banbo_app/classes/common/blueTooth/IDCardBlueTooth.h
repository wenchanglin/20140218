//
//  IDCardBlueTooth.h
//  Test
//
//  Created by hcy on 2016/12/19.
//  Copyright © 2016年 hcy. All rights reserved.
//

#import "BaseBlueTooth.h"

@interface IDCardBlueTooth : BaseBlueTooth

@end
@interface IDCardInfo : NSObject
@property(copy,nonatomic)NSString *name;
@property(copy,nonatomic)NSString *address;
@property(copy,nonatomic)NSString *gender;
@property(copy,nonatomic)NSString *nation;
@property(copy,nonatomic)NSString *birthDay;
@property(copy,nonatomic)NSString *id_num;
@property(copy,nonatomic)NSString *sign_office;
@property(copy,nonatomic)NSString *useful_s_date;
@property(copy,nonatomic)NSString *useful_e_date;
-(NSDictionary *)param;
@property(assign,nonatomic)NSInteger sexNum;
@end
