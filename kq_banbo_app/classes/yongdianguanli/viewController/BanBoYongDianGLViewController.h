//
//  BanBoYongDianGLViewController.h
//  kq_banbo_app
//
//  Created by banbo on 2017/4/24.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BanBoShiminListItem.h"
#import "BanBoProject.h"

@interface BanBoYongDianGLViewController : UIViewController
-(instancetype)initWithListItem:(BanBoShiminListItem *)item project:(BanBoProject *)project;

@end
