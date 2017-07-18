//
//  BanBoPersonInfo.h
//  kq_banbo_app
//
//  Created by hcy on 2016/12/8.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoCellObj.h"
/**
 * 个人信息里的
 */
@interface BanBoHealthInfo : BanBoColumnCellObj
@property(copy,nonatomic)NSString *projectName;
@property(copy,nonatomic)NSString *statusStr;
@property(copy,nonatomic)NSString *updateDateStr;

@property(strong,nonatomic)UIFont *font;
@end
