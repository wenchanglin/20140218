//
//  BanBoVRDetailTableViewCell.h
//  kq_banbo_app
//
//  Created by banbo on 2017/6/26.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BanBoVRXiangQingModel.h"
#import "BanBoVRChaKanModel.h"
@interface BanBoVRXQYSubTVCell : UITableViewCell
@property(strong,nonatomic)UILabel *gonghaoLabel;
@property(strong,nonatomic)UILabel *gonghaoSubLabel;
@property(strong,nonatomic)UIView * gonghaoView;
@property(strong,nonatomic)UILabel *nameLabel;
@property(strong,nonatomic)UILabel *nameSubLabel;
@property(strong,nonatomic)UIView * nameView;
@property(strong,nonatomic)UILabel *caridLabel;
@property(strong,nonatomic)UILabel *caridSubLabel;
@property(strong,nonatomic)UIView * caridView;
@property(strong,nonatomic)UILabel * banzuLabel;
@property(strong,nonatomic)UILabel * banzuSubLabel;
@property(strong,nonatomic)UIView * banzuView;
@property(strong,nonatomic)UIView * fengeView;
-(void)setDatawithModel:(BanBoVRXiangQingModel*)model;
@end

@interface BanBoVRXQYErJiCell : UITableViewCell
@property(strong,nonatomic)UILabel * xuhaoLabel;
@property(strong,nonatomic)UILabel * guanqiaLabel;
@property(strong,nonatomic)UIImageView * passImageView;
@property(strong,nonatomic)UILabel * passTimeLabel;
@property(strong,nonatomic)UIView * guanqiaView;
-(void)setDataWithVRChaKanModel:(BanBoVRChaKanModel *)models;
@end
