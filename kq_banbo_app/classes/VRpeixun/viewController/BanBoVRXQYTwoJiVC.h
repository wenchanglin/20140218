//
//  BanBoVRXQYTwoJiVC.h
//  kq_banbo_app
//
//  Created by banbo on 2017/6/28.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BanBoVRXiangQingModel.h"
#import "BanBoProject.h"
@interface BanBoVRXQYTwoJiVC : UIViewController
@property(nonatomic,strong)BanBoVRXiangQingModel * xiaomodel;
-(instancetype)initwithProject:(BanBoProject *)project withgonghao:(NSNumber *)gonghao;
@end
