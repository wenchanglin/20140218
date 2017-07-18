//
//  BanBoVRListPeiXunCell.h
//  kq_banbo_app
//
//  Created by banbo on 2017/6/23.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "BanBoVRXiangQingModel.h"
@protocol VRTableViewDelegate<NSObject>
-(void)VRTableClick:(UITableViewCell *)cell;
@end
@interface BanBoVRListPeiXunCell : UITableViewCell
@property(nonatomic,strong)UILabel *xuhaoLabel;
@property(nonatomic,strong)UILabel * gonghaoLabel;
@property(nonatomic,strong)UILabel * nameLabel;
@property(nonatomic,strong)UILabel * peixunLabel;
@property(nonatomic,strong)UILabel * nopeixunlabel;
@property(nonatomic,strong)UIButton * checkBtn;
@property(nonatomic,strong)UIView * fengeView;
@property(nonatomic,weak)id<VRTableViewDelegate>delegate;
-(void)setDataWithModel:(BanBoVRXiangQingModel *)model;
@end
