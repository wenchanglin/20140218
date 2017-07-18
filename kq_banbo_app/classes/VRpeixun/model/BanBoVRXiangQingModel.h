//
//  BanBoVRXiangQingModel.h
//  kq_banbo_app
//
//  Created by banbo on 2017/6/26.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BanBoVRXiangQingModel : NSObject
/**工号*/
@property(nonatomic,strong)NSNumber * currWorkNo;
/**姓名*/
@property(nonatomic,strong)NSString *userName;
/**班组*/
@property(nonatomic,strong)NSString * groupName;
//@property(nonatomic,strong)NSNumber *cardId;
@property(nonatomic,strong)NSString *cardId;

/**培训通过多少关*/
@property(nonatomic,strong)NSNumber *passcount;
/**总共培训多少关*/
@property(nonatomic,strong)NSNumber * total;
/**总条数*/
@property(nonatomic,strong)NSNumber * allrow;
@end
