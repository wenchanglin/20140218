//
//  BanBoShiminListCell.m
//  kq_banbo_app
//
//  Created by hcy on 2016/12/2.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoShiminListCell.h"
#import "BanBoShiminListItem.h"
@interface BanBoShiminListCell()
@property(strong,nonatomic)UIImageView *iconView;

@property(strong,nonatomic)UILabel *titleLabel;
@end
@implementation BanBoShiminListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(UIImageView *)iconView{
    if(!_iconView){
        UIImageView *imageView=[UIImageView new];
        [self.contentView addSubview:imageView];
        _iconView=imageView;
    }
    return _iconView;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel=[YZLabelFactory blackLabel];
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}
-(void)refreshWithItem:(BanBoShiminListItem *)item{
    self.iconView.image=[UIImage imageNamed:item.imageName];
    
    self.titleLabel.text=item.title;
    [self.titleLabel sizeToFit];
    [self setNeedsLayout];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    _iconView.top=0;
    _iconView.width=self.width*[BanBoLayoutParam shiminImagePercent];
    _iconView.height=_iconView.width;
    _iconView.centerX=self.width*.5;
    
    _titleLabel.top=_iconView.bottom+10;
    _titleLabel.centerX=self.width*.5;
}
@end
