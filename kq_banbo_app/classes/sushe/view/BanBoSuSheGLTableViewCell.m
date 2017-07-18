//
//  BanBoSuSheGLTableViewCell.m
//  kq_banbo_app
//
//  Created by banbo on 2017/4/19.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "BanBoSuSheGLTableViewCell.h"

@implementation BanBoSuSheGLTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI
{
    _arrowButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 10, 40, 40)];
    _arrowButton.backgroundColor = [UIColor hcy_colorWithString:@"#4cd084"];
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 10,SCREEN_WIDTH-75, 40)];
    _nameLabel.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:_arrowButton];
    [self.contentView addSubview:_nameLabel];
}
-(void)setModel:(BanBoSuSheGuanLiModel *)model
{
    _model = model;
    _nameLabel.text = [NSString stringWithFormat:@"%@",model.buildname];
}
@end
