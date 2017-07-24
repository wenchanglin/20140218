//
//  BanBoTaDiaoModel.h
//  kq_banbo_app
//
//  Created by banbo on 2017/5/27.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BanBoTaDiaoModel : NSObject
@property(nonatomic,strong) NSString * dateTime;
@property(nonatomic)NSNumber * deviceId;
@property(nonatomic)NSString * dwRotate;
@property(nonatomic,strong)NSString * latitude;
@property(nonatomic,strong)NSString *longitude;
@property(nonatomic)NSString * wDip;
@property(nonatomic)NSString * wHeight;
@property(nonatomic)NSString * wLoad;
@property(nonatomic)NSNumber * wMargin;
@property(nonatomic)NSNumber * wRate;
@property(nonatomic)NSNumber * wTorque;
@property(nonatomic,strong)NSString * recordNumber;
@property(nonatomic)NSString * wWindvel;
@property(nonatomic)NSNumber * wFCodeVRate;
@property(nonatomic)NSNumber * wFRateVCode;
@property(nonatomic,strong)NSString *recordName;
@end
