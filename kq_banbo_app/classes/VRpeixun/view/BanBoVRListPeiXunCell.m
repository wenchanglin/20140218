//
//  BanBoVRListPeiXunCell.m
//  kq_banbo_app
//
//  Created by banbo on 2017/6/23.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "BanBoVRListPeiXunCell.h"

@implementation BanBoVRListPeiXunCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)setDataWithModel:(BanBoVRXiangQingModel *)model
{
    _gonghaoLabel.text = [NSString stringWithFormat:@"%@",model.currWorkNo];
    _nameLabel.text = model.userName;
    _peixunLabel.text = [NSString stringWithFormat:@"%@关",model.passcount];
    int  nopeixun = [model.total intValue]-[model.passcount intValue];
    _nopeixunlabel.text = [NSString stringWithFormat:@"%d关",nopeixun];
    
}
-(void)createUI
{
    float w = SCREEN_WIDTH/6;
    _xuhaoLabel = [self createBlackLabelwithFrame:CGRectMake(0, 5, w, 40)  textColor:[UIColor hcy_colorWithString:@"#4c4c4c"]];
    [self.contentView addSubview:_xuhaoLabel];
    _gonghaoLabel = [self createBlackLabelwithFrame:CGRectMake(w,5, w, 40) textColor:[UIColor hcy_colorWithString:@"#4c4c4c"]];
    [self.contentView addSubview:_gonghaoLabel];
    _nameLabel = [self createBlackLabelwithFrame:CGRectMake(w*2, 5, w, 40) textColor:[UIColor hcy_colorWithString:@"#4c4c4c"]];
    [self.contentView addSubview:_nameLabel];
    _peixunLabel = [self createBlackLabelwithFrame:CGRectMake(w*3, 5, w, 40) textColor:[UIColor hcy_colorWithString:@"#4ac120"]];
    [self.contentView addSubview:_peixunLabel];
    _nopeixunlabel = [self createBlackLabelwithFrame:CGRectMake(w*4, 5, w, 40) textColor:[UIColor hcy_colorWithString:@"#e54042"]];
    [self.contentView addSubview:_nopeixunlabel];
    _checkBtn = [[UIButton alloc]initWithFrame:CGRectMake(w*5+1, 13, w-5, 25)];
    [_checkBtn setTitle:@"查看" forState:UIControlStateNormal];
    _checkBtn.titleLabel.font = [YZLabelFactory normal14Font];
    [_checkBtn setTintColor:[UIColor hcy_colorWithString:@"#ffffff"]];
    [_checkBtn setBackgroundColor:[UIColor hcy_colorWithString:@"#fda803"]];
    [_checkBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_checkBtn];
    _fengeView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_xuhaoLabel.frame)+2, SCREEN_WIDTH, 1)];
    _fengeView.backgroundColor = [UIColor hcy_colorWithString:@"#e0e0e0"];
    [self.contentView addSubview:_fengeView];
}
-(void)btnClick:(UIButton *)button
{
    [self.delegate VRTableClick:self];
}
-(UILabel *)createBlackLabelwithFrame:(CGRect)frame  textColor:(UIColor *)color
{
    UILabel * label = [[UILabel alloc]initWithFrame:frame];
    label.textColor = color;
    label.numberOfLines =0;
    label.font = [YZLabelFactory normal14Font];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}
@end
