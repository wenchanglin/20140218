//
//  BanBoSuSheRoomTableViewCell.m
//  kq_banbo_app
//
//  Created by banbo on 2017/4/21.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "BanBoSuSheRoomTableViewCell.h"

@implementation BanBoSuSheRoomTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI
{
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 10, 80, 40)];
    _nameLabel.font = [UIFont systemFontOfSize:18];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
     [self.contentView addSubview:_nameLabel];
    _subNameLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-80)/2, 10, 80, 40)];
    _subNameLabel.font = [UIFont systemFontOfSize:18];
    _subNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_subNameLabel];
    _fenPeiButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-90, 15, 80, 30)];
    [self.contentView addSubview:_fenPeiButton];
    _fenPeiButton.layer.cornerRadius =4;
    _fenPeiButton.layer.masksToBounds = YES;
    [_fenPeiButton addTarget:self action:@selector(fenPei:) forControlEvents:UIControlEventTouchUpInside];
    
    [_fenPeiButton setTitle:@"分配" forState:UIControlStateNormal];
    [_fenPeiButton setBackgroundColor:[UIColor hcy_colorWithString:@"#fec538"]];
    [_fenPeiButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.userInteractionEnabled = YES;
   
    
}
-(void)fenPei:(UIButton *)button
{
    [self.delegate myTableClick:self];
}
-(void)setModel:(BanBoSuSheGlRoomModel *)model
{
    _model = model;
    _nameLabel.text = [NSString stringWithFormat:@"%@房间",model.roomid];
    if ([model.groupname isEqualToString:@""]||[model.groupname isKindOfClass:[NSNull class]]||model.groupname==nil) {
        _subNameLabel.text = @"未分配";
    }
    else
    {
        _subNameLabel.text = [NSString stringWithFormat:@"%@",model.groupname];
    }
}
@end
