//
//  BanBoVRDetailVC.h
//  kq_banbo_app
//
//  Created by banbo on 2017/6/23.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BanBoProject.h"
#import "BanBoShiminListItem.h"
#import "BanBoColumnListViewController.h"
@interface BanBoVRDetailVC : UIViewController
@property(strong,nonatomic)BanBoColumnHeader *columnHeader;
@property(strong,nonatomic,readonly)BanBoShiminListItem *listItem;
@property(strong,nonatomic,readonly)BanBoProject *project;

-(void)refreshData:(NSDictionary *)parames;
-(instancetype)initWithListItem:(BanBoShiminListItem *)item project:(BanBoProject *)project;
@end
