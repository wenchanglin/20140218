//
//  BanBoShiMinItemListViewController.h
//  kq_banbo_app
//
//  Created by hcy on 2016/12/5.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoShiMinListViewController.h"
#import "BanBoShiMinManager.h"
@class  BanBoShiminListItem,BanBoProject;

/**
 实名制6个cell点击来的基础页面
 */
@interface BanBoShiMinItemListViewController : BanBoShiMinListViewController
@property(strong,nonatomic)BanBoColumnHeader *columnHeader;
@property(strong,nonatomic,readonly)BanBoShiminListItem *listItem;
@property(strong,nonatomic,readonly)BanBoProject *project;
-(NSDictionary *)columnHeaderDict;
/**
 刷新数据

 @param isBottom 是否增量
 */
-(void)refreshData:(BOOL)isBottom;
-(instancetype)initWithListItem:(BanBoShiminListItem *)item project:(BanBoProject *)project;
@end
