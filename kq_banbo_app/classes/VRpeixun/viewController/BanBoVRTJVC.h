//
//  BanBoVRTJVC.h
//  kq_banbo_app
//
//  Created by banbo on 2017/6/23.
//  Copyright © 2017年 yzChina. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "BanBoShiminListItem.h"
#import "BanBoProject.h"
@interface BanBoVRTJVC : UIViewController
-(instancetype)initWithListItem:(BanBoShiminListItem *)item project:(BanBoProject *)project;
@end
