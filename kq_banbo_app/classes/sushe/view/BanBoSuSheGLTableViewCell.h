//
//  BanBoSuSheGLTableViewCell.h
//  kq_banbo_app
//
//  Created by banbo on 2017/4/19.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BanBoSuSheGuanLiModel.h"
@interface BanBoSuSheGLTableViewCell : UITableViewCell
@property (strong, nonatomic) UIButton *arrowButton;//前面的button
@property (strong, nonatomic) UILabel *nameLabel;
@property(strong,nonatomic)BanBoSuSheGuanLiModel * model;
@end
