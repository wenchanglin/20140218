//
//  CumstonLeftBarItem.m
//  yixin_iphone
//
//  Created by user on 14-6-6.
//  Copyright (c) 2014年 Netease. All rights reserved.
//

#import "CustomLeftBarView.h"
#import "BadgeView.h"
@interface CustomLeftBarView()
@property(strong,nonatomic)UIButton *leftBtn;
@end
@implementation CustomLeftBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews
{
    self.badgeView = [BadgeView viewWithBadgeTip:@""];
    self.badgeView.frame = CGRectMake(30, 8, 0, 0);
    self.badgeView.hidden = YES;
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *buttonNormal = [UIImage imageNamed:@"bar_back"];
//    UIImage *buttonPressed= [UIImage imageNamed:@"btn_back_white_pressed"];
    
    [leftButton setImage:buttonNormal forState:UIControlStateNormal];
//    [leftButton setImage:buttonPressed forState:UIControlStateHighlighted];
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    leftButton.titleLabel.font=[UIFont systemFontOfSize:[UIFont systemFontSize]];
    leftButton.exclusiveTouch = YES;
    //嫌弃相应范围小
    [leftButton addTarget:self action:@selector(onLeftButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton sizeToFit];
    self.frame = CGRectMake(0,20,leftButton.width, 44.0);
    leftButton.centerY=self.height*.5;
    
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:leftButton];
    [self addSubview:self.badgeView];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onLeftButtonPressed:)];
    [self addGestureRecognizer:tap];
    
}

- (void)onLeftButtonPressed:(id)sender
{
    if (self.delegate)
    {
        if ([self.delegate respondsToSelector:@selector(onLeftButtonPressed)])
        {
            [self.delegate onLeftButtonPressed];
        }
    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
    _leftBtn.centerY=self.height*.5;
}
@end
