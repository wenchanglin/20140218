//
//  YZWMGraySectionHeaderView.m
//  YZWaimaiCustomer
//
//  Created by hcy on 2016/9/23.
//  Copyright © 2016年 hcy@yz. All rights reserved.
//

#import "YZWMGraySectionHeaderView.h"
#import "UIColor+HCY.h"
#import "UIView+HCY.h"
@interface YZWMGraySectionHeaderView()
@property(strong,nonatomic)UILabel *label;

@end
@implementation YZWMGraySectionHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor hcy_colorWithRed:239 green:239 blue:239 alpha:1];
        _label=[UILabel new];
        _label.textColor=[UIColor whiteColor];
        [self addSubview:_label];
    }
    return self;
}

-(void)sizeToFit{
    [_label sizeToFit];
    self.bounds=_label.bounds;
}
-(void)setText:(NSString *)text{
    _text=[text copy];
    _label.text=text;
    [self refresh];
}
-(void)setFont:(UIFont *)font{
    _label.font=font;
    [self refresh];
}
-(void)setTextColor:(UIColor *)textColor{
    _label.textColor=textColor;
    [self refresh];
}
-(void)refresh{
    [_label sizeToFit];
    [self setNeedsLayout];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    _label.top=0;
    _label.left=SCREEN_WIDTH*.05;
    _label.height=self.height;
    
}
@end
