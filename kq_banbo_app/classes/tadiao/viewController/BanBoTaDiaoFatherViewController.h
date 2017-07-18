//
//  BanBoTaDiaoFatherViewController.h
//  kq_banbo_app
//
//  Created by banbo on 2017/5/27.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BanBoTaDiaoModel.h"
#import "BanBoTaDiaoSheBeiModel.h"
@interface BanBoTaDiaoFatherViewController : UIViewController
@property(nonatomic,strong) BanBoTaDiaoModel * models;
@property(nonatomic,strong)BanBoTaDiaoSheBeiModel * shebeimodel;
@property(nonatomic,strong)NSNumber * taDiaoid;
@end
