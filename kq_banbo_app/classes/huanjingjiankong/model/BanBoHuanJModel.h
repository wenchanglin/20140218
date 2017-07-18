//
//  BanBoHuanJModel.h
//  kq_banbo_app
//
//  Created by banbo on 2017/5/2.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BanBoHuanJModel : NSObject
@property(nonatomic,strong)NSArray * waring;
@property(nonatomic,strong)NSString * windScale;
/**设备的名字*/
@property(nonatomic,strong)NSString * equipmentName;
@property(nonatomic,strong)NSString * pm2p5Msg;
@property(nonatomic,strong)NSString *  pm10Msg;
@property(nonatomic,strong)NSString * pm2p5;/**pm2.5*/
@property(nonatomic,strong)NSString * pm10;/**pm10*/
@property(nonatomic,strong)NSNumber * rtdId;/**设备mac*/
@property(nonatomic,strong)NSString * humi;/**湿度*/
@property(nonatomic,strong)NSString * tsp;/**TSP*/
@property(nonatomic,strong)NSString *temp;/**温度*/
@property(nonatomic,strong)NSString *ws;/**风速*/
@property(nonatomic,strong)NSString *wdir;/**风向*/
@property(nonatomic,strong)NSString *atm;/**大气压*/
@property(nonatomic,strong)NSString *nvh;/**噪声*/
@property(nonatomic,strong)NSString * createTime;/**插入数据库的时间*/
@property(nonatomic,strong)NSString * dataTime;/**设备返回采样时间*/
@property(nonatomic,strong)NSNumber * equipmentId;/**设备ID*/

@end
