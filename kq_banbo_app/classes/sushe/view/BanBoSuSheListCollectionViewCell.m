//
//  BanBoSuSheListCollectionViewCell.m
//  kq_banbo_app
//
//  Created by banbo on 2017/4/18.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "BanBoSuSheListCollectionViewCell.h"
@interface BanBoSuSheListCollectionViewCell()
@property(strong,nonatomic)UIImageView *iconView;

@property(strong,nonatomic)UILabel *titleLabel;
@end
@implementation BanBoSuSheListCollectionViewCell
-(UIImageView *)iconView
{
    if (!_iconView) {
        UIImageView * imageview = [UIImageView new];
        [self.contentView addSubview:imageview];
        _iconView = imageview;
    }
    return _iconView;
}
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [YZLabelFactory blackLabel];
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}
-(void)refreshWithItem:(BanBoShiminListItem *)item
{
    self.iconView.image = [UIImage imageNamed:item.imageName];
    self.titleLabel.text = item.title;
    [self.titleLabel sizeToFit];
    [self setNeedsLayout];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    _iconView.top = 0;
    _iconView.width = self.width*[BanBoLayoutParam shiminImagePercent];
    _iconView.height = _iconView.width;
    _iconView.centerX = self.width*.5;
    _titleLabel.top = _iconView.bottom+10;
    _titleLabel.centerX = self.width*.5;
}
@end
