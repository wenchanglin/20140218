//
//  BanBoYongDianTableViewCell.m
//  kq_banbo_app
//
//  Created by banbo on 2017/4/24.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "BanBoYongDianTableViewCell.h"

@implementation BanBoYongDianTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI
{
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, 10, 80, 40)];
    _nameLabel.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:_nameLabel];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _currPowerLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-80)/2, 10, 80, 40)];
    _currPowerLabel.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:_currPowerLabel];
    _currPowerLabel.textAlignment = NSTextAlignmentCenter;
    _dumpChargeLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-90, 15, 80, 30)];
    _dumpChargeLabel.font = [UIFont systemFontOfSize:18];
    _dumpChargeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_dumpChargeLabel];
}
-(void)setModel:(BanBoSuSheGlRoomModel *)model
{
    _model = model;
    _nameLabel.text = [NSString stringWithFormat:@"%@房间",model.roomid];
    if(model.currpower ==nil||[model.currpower isKindOfClass:[NSNull class]])
    {
    _currPowerLabel.text = @"0.0";
    }
    else
    {
    _currPowerLabel.text = [NSString stringWithFormat:@"%@",model.currpower];
    }
    if(model.dumpcharge ==nil||[model.dumpcharge isKindOfClass:[NSNull class]])
    {
    _dumpChargeLabel.text =@"0.0";
    }
    else
    {
    _dumpChargeLabel.text = [NSString stringWithFormat:@"%@",model.dumpcharge];
    }
}
@end
