//
//  BanBoSuSheGlRoomModel.h
//  kq_banbo_app
//
//  Created by banbo on 2017/4/20.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BanBoSuSheGlRoomModel : NSObject
@property(nonatomic,assign)NSNumber *  bid;
@property(nonatomic,strong)NSString * buildname;
@property(nonatomic,assign)NSNumber *  clientid;
@property(nonatomic,assign)NSNumber *  addtime;
@property(nonatomic,strong)NSString * groupname;
@property(nonatomic,strong)NSString * maxgroupname;
@property(nonatomic,strong)NSString * remarks;
@property(nonatomic,strong)NSNumber * rid;
@property(nonatomic,assign)NSNumber * floorid;
@property(nonatomic,strong)NSNumber * roomid;
@property(nonatomic,strong)NSNumber * groupid;
@property(nonatomic,strong)NSNumber * maxgroupid;
@property(nonatomic,strong)NSNumber * buytime;
@property(nonatomic,strong)NSNumber * shutpowerset;
@property(nonatomic,strong)NSNumber * totalcharge;
@property(nonatomic,strong)NSNumber * dumpcharge;
@property(nonatomic,strong)NSNumber * currpower;


@end
