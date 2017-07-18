//
//  BanBoVRTJCell.h
//  kq_banbo_app
//
//  Created by banbo on 2017/6/23.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BanBoVRTongJiModel.h"
@interface BanBoVRTJCell : UITableViewCell
@property(nonatomic,strong)UILabel * banzuLabel;
@property(nonatomic,strong)UILabel * banzuPeopleLabel;
@property(nonatomic,strong)UILabel * passPeopleLabel;
-(void)setDataWithModel:(BanBoVRTongJiModel *)model;
@end
