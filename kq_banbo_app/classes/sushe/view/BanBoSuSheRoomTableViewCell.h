//
//  BanBoSuSheRoomTableViewCell.h
//  kq_banbo_app
//
//  Created by banbo on 2017/4/21.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BanBoSuSheGlRoomModel.h"
@protocol myTableViewDelegate<NSObject>
-(void)myTableClick:(UITableViewCell *)cell;
@end
@interface BanBoSuSheRoomTableViewCell : UITableViewCell
@property (strong, nonatomic) UIButton *arrowButton;//前面的button
@property (strong, nonatomic) UILabel *nameLabel;
@property(strong,nonatomic)UILabel * subNameLabel;
@property(strong,nonatomic) UIButton * fenPeiButton;
@property(strong,nonatomic)BanBoSuSheGlRoomModel * model;
@property(weak,nonatomic)id<myTableViewDelegate>delegate;
@end
