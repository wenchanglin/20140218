//
//  BanBoLineHeaderView.m
//  kq_banbo_app
//
//  Created by hcy on 2016/12/1.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoLineHeaderView.h"
@interface BanBoLineHeaderView()

@end
@implementation BanBoLineHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        self.leftLabel=[YZLabelFactory blueLabel];
        self.leftLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.leftLabel];
        
        self.rightLabel=[YZLabelFactory blackLabel];
        [self addSubview:self.rightLabel];
        
        UIView *verSeparView=[self separView];
        [self addSubview:verSeparView];
        self.verSeparView=verSeparView;
        self.verSeparPercent=0.8;
    
        UIView *bottomSeparView=[self separView];
        bottomSeparView.width=self.width;
        [self addSubview:bottomSeparView];
        self.bottomSeparView=bottomSeparView;
        
        self.verSeparLeftToLeftLabel=5;
        self.rightLabelLeftToVerSepar=20;
    }
    return self;
}
-(UIView *)separView{
    UIView *view=[UIView new];
    view.backgroundColor=[UIColor hcy_colorWithString:@"#e0e0e0"];
    return view;
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    _leftLabel.top=0;
    _leftLabel.height=self.height;
    
    _verSeparView.width=1;
    _verSeparView.centerY=self.height*.5;
    _verSeparView.height=self.height*self.verSeparPercent;
    _verSeparView.left=_leftLabel.right+self.verSeparLeftToLeftLabel;
    
    _rightLabel.left=_verSeparView.right+self.rightLabelLeftToVerSepar;
    _rightLabel.height=self.height;
    _rightLabel.width=(self.width-_rightLabel.left);
    
    
    _bottomSeparView.top=self.height-1;
    _bottomSeparView.height=1;
    if (_bottomSeparView.width==0) {
        _bottomSeparView.width=self.width-_bottomSeparView.left;
    }
}
@end
