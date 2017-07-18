//
//  BanBoVRDetailTableViewCell.m
//  kq_banbo_app
//
//  Created by banbo on 2017/6/26.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "BanBoVRXQYSubTVCell.h"

@implementation BanBoVRXQYSubTVCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)setDatawithModel:(BanBoVRXiangQingModel *)model
{
    _gonghaoSubLabel.text = [NSString stringWithFormat:@"%@",model.currWorkNo];
    _nameSubLabel.text  = model.userName;
    _caridSubLabel.text =model.cardId;
    _banzuSubLabel.text = model.groupName;
}
-(void)createUI
{
    _gonghaoLabel = [self createLabelWithFrame:CGRectMake(20, 5, 60, 30) withText:@"工号:" withNSTextAlignment:NSTextAlignmentLeft];//[[UILabel
    [self.contentView addSubview:_gonghaoLabel];
    _gonghaoSubLabel = [self createLabelWithFrame:CGRectMake(SCREEN_WIDTH/2-30, 5, SCREEN_WIDTH/2-20, 30) withText:@"1227" withNSTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_gonghaoSubLabel];
    _gonghaoView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_gonghaoLabel.frame)+5,SCREEN_WIDTH-20, 1)];
    _gonghaoView.backgroundColor = [UIColor hcy_colorWithString:@"#e0e0e0"];
    [self.contentView addSubview:_gonghaoView];
    _nameLabel = [self createLabelWithFrame:CGRectMake(20, CGRectGetMaxY(_gonghaoView.frame)+5, 60, 30) withText:@"姓名:" withNSTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_nameLabel];
    _nameSubLabel = [self createLabelWithFrame:CGRectMake(SCREEN_WIDTH/2-30, CGRectGetMaxY(_gonghaoView.frame)+5, SCREEN_WIDTH/2-20, 30) withText:@"叶玉珍" withNSTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_nameSubLabel];
    _nameView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_nameLabel.frame)+5,SCREEN_WIDTH-20, 1)];
    _nameView.backgroundColor = [UIColor hcy_colorWithString:@"#e0e0e0"];
    [self.contentView addSubview:_nameView];
    _caridLabel = [self createLabelWithFrame:CGRectMake(20, CGRectGetMaxY(_nameView.frame)+5, 90, 30) withText:@"身份证号:" withNSTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_caridLabel];
    _caridSubLabel = [self createLabelWithFrame:CGRectMake(SCREEN_WIDTH/2-30, CGRectGetMaxY(_nameView.frame)+5, SCREEN_WIDTH/2, 30) withText:@"511224196701157386" withNSTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_caridSubLabel];
    _caridView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_caridLabel.frame)+5,SCREEN_WIDTH-20, 1)];
    _caridView.backgroundColor = [UIColor hcy_colorWithString:@"#e0e0e0"];
    [self.contentView addSubview:_caridView];
    _banzuLabel = [self createLabelWithFrame:CGRectMake(20, CGRectGetMaxY(_caridView.frame)+5, 60, 30) withText:@"班组:" withNSTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_banzuLabel];
    _banzuSubLabel  = [self createLabelWithFrame:CGRectMake(SCREEN_WIDTH/2-30, CGRectGetMaxY(_caridView.frame)+5, SCREEN_WIDTH/2-10, 30) withText:@"机械组" withNSTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_banzuSubLabel];
    _banzuView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_banzuLabel.frame)+5,SCREEN_WIDTH, 1)];
    _banzuView.backgroundColor = [UIColor hcy_colorWithString:@"#e0e0e0"];
    [self.contentView addSubview:_banzuView];
    _fengeView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_banzuView.frame), SCREEN_WIDTH, 10)];
    _fengeView.backgroundColor = [UIColor hcy_colorWithString:@"#f7f7f7"];
    [self.contentView addSubview:_fengeView];
}
-(UILabel *)createLabelWithFrame:(CGRect)rect withText:(NSString *)text withNSTextAlignment:(NSTextAlignment)alignment
{
    UILabel * label  = [[UILabel alloc]initWithFrame:rect];
    label.textAlignment = alignment;
    label.text =text;
    label.textColor = [UIColor hcy_colorWithString:@"#4c4c4c"];
    label.font = [YZLabelFactory normal14Font];
    return label;
}
@end

@implementation BanBoVRXQYErJiCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createTwoUI];
    }
    return self;
}
-(void)setDataWithVRChaKanModel:(BanBoVRChaKanModel *)models
{
    _xuhaoLabel.text = [NSString stringWithFormat:@"%@",models.mission];
    _guanqiaLabel.text = models.missioninfo;
    if([models.iswin intValue]==0)
    {
        _passImageView.image = [UIImage imageNamed:@"未通过"];
    }
    else if ([models.iswin intValue]==1)
    {
        _passImageView.image=[UIImage imageNamed:@"通过"];
    }
    if ([models.time isEqualToString:@""]) {
        _passTimeLabel.text = @"暂无记录";
    }
    else
    {
    _passTimeLabel.text = models.time;
    }
}
-(void)createTwoUI
{
    float x = 0;
    float w = SCREEN_WIDTH/4;
    _xuhaoLabel = [self createLabelWithFrame:CGRectMake(w*0+x, 5, w, 30) withText:@"" withNSTextAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:_xuhaoLabel];
    _guanqiaLabel = [self createLabelWithFrame:CGRectMake(w*1+x, 5, w, 30) withText:@"" withNSTextAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:_guanqiaLabel];
    _passImageView = [[UIImageView alloc]initWithFrame:CGRectMake(w*2+(w/2.5), 12, 15, 15)];
    _passImageView.image= [UIImage imageNamed:@""];
    [self.contentView addSubview:_passImageView];
    _passTimeLabel = [self createLabelWithFrame:CGRectMake(w*3-15, 5, w+20, 30) withText:@"2017-2-12" withNSTextAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:_passTimeLabel];
    _guanqiaView =[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_xuhaoLabel.frame)+5, SCREEN_WIDTH, 1)];
    _guanqiaView.backgroundColor = [UIColor hcy_colorWithString:@"#e0e0e0"];
    [self.contentView addSubview:_guanqiaView];
    
}
-(UILabel *)createLabelWithFrame:(CGRect)rect withText:(NSString *)text withNSTextAlignment:(NSTextAlignment)alignment
{
    UILabel * label  = [[UILabel alloc]initWithFrame:rect];
    label.textAlignment = alignment;
    label.text =text;
    label.textColor = [UIColor hcy_colorWithString:@"#4c4c4c"];
    label.font = [YZLabelFactory normal14Font];
    return label;
}
@end
