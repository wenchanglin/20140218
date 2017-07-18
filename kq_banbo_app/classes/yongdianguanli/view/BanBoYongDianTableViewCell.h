//
//  BanBoYongDianTableViewCell.h
//  kq_banbo_app
//
//  Created by banbo on 2017/4/24.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BanBoSuSheGlRoomModel.h"
@interface BanBoYongDianTableViewCell : UITableViewCell
@property (strong, nonatomic) UILabel *nameLabel;
@property(nonatomic,strong)UILabel *currPowerLabel;
@property(nonatomic,strong)UILabel *dumpChargeLabel;
@property(strong,nonatomic)BanBoSuSheGlRoomModel * model;

@end
