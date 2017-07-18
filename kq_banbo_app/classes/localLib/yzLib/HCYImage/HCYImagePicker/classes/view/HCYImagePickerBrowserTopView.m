//
//  HCYImagePickerBrowserTopView.m
//  HCYImagePickerDemo
//
//  Created by hcy on 16/8/16.
//  Copyright © 2016年 hcy. All rights reserved.
//

#import "HCYImagePickerBrowserTopView.h"
#import "HCYImagePickerCollector.h"
#import "UIView+DanteImagePicker.h"
@interface HCYImagePickerBrowserTopView()


@end
@implementation HCYImagePickerBrowserTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self p_setupSubviews];
    }
    return self;
}
-(void)p_setupSubviews{
    
    self.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
    
    UIColor *bgColor=[UIColor colorWithRed:40/255.f green:40/255.f blue:40/255.f alpha:1.f];
    [self setBackgroundColor:bgColor];
    
    UIControl *control=[[UIControl alloc] initWithFrame:CGRectMake(0, 20, 64, 44)];
    UIImageView *imageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hcyimagepicker_arrowback"]];
    imageView.top=10;
    imageView.left=15;
    imageView.width=13;
    imageView.height=24;
    [control addSubview:imageView];
    [self addSubview:control];
    self.backControl=control;
    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"hcyimagepicker_preview_uncheck@2x"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"hcyimagepicker_overlay_checked@2x"] forState:UIControlStateHighlighted];
    [rightBtn setImage:[UIImage imageNamed:@"hcyimagepicker_overlay_checked@2x"] forState:UIControlStateSelected];
    rightBtn.top=30;
    rightBtn.width=24;
    rightBtn.height=24;
    rightBtn.right=self.width-20;
    [self addSubview:rightBtn];
    self.selectBtn=rightBtn;
    
    _titleLabel=[UILabel new];
    _titleLabel.textColor=[UIColor whiteColor];
    [self addSubview:_titleLabel];
    
}
-(void)back{
    
}

-(void)refreshWithItem:(id<HCYImagePickerContentItem>)item{
    [super refreshWithItem:item];
    _selectBtn.selected=[item isSelected];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    _titleLabel.centerX=self.width*.5;
    _titleLabel.bottom=self.height-10;
}

@end
