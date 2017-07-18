//
//  BanBoCellObj.h
//  kq_banbo_app
//
//  Created by hcy on 2016/12/7.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YZListHeader.h"
#import "HCYColumnLayoutManager.h"
/**
 cell模型的基类
 */
@interface BanBoCellObj : NSObject<YZListItem>
@property(assign,nonatomic)CGFloat cellHeight;
@property(assign,nonatomic)NSInteger sortNum;
@end

/**
 多列的cell模型对象
 */
@interface BanBoColumnCellObj : BanBoCellObj<HCYColumnModel>

/**
 加这个的原因是因为先阶段项目所有的cell用的都是一个。但是如果碰到实名制-工人名册那种情况就很尴尬了。改变列数
 */
@property(copy,nonatomic)NSString *customReuseId;
@end
