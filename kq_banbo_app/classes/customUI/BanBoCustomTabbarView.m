//
//  BanBoCustomTabbarView.m
//  kq_banbo_app
//
//  Created by hcy on 2016/11/30.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoCustomTabbarView.h"
#import "YZVerButton.h"
@interface BanBoCustomTabbarView()


@end
@implementation BanBoCustomTabbarView
+(instancetype)inst{
    BanBoCustomTabbarView *tabbar=[BanBoCustomTabbarView new];
    
    [tabbar setup];
    return tabbar;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    frame.size.width=SCREEN_WIDTH;
    frame.size.height=47;
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat tabbarHeight=47;
    }
    return self;
}

-(void)setup{
    self.backgroundColor=[UIColor whiteColor];
    self.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
    
    YZVerButton *reportBtn=[YZVerButton new];
    [reportBtn setImage:[UIImage imageNamed:@"baodao"] forState:UIControlStateNormal];
    [reportBtn setTitleColor:BanBoLabelGrayColor forState:UIControlStateNormal];
    [reportBtn setTitle:NSLocalizedString(@"报到", nil) forState:UIControlStateNormal];
    [reportBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [self addSubview:reportBtn];
    [reportBtn addTarget:self action:@selector(reportBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *addBtn=[UIButton new];
    [addBtn setImage:[UIImage imageNamed:@"椭圆home"] forState:UIControlStateNormal];
    [self addSubview:addBtn];
    [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    YZVerButton *nvrBtn=[YZVerButton new];
    nvrBtn.titleLabel.font=[YZLabelFactory normalFont];
    [nvrBtn setImage:[UIImage imageNamed:@"jiankong"] forState:UIControlStateNormal];
    [nvrBtn setTitle:NSLocalizedString(@"监控", nil) forState:UIControlStateNormal];
    [nvrBtn setTitleColor:BanBoLabelGrayColor forState:UIControlStateNormal];
    [nvrBtn addTarget:self action:@selector(nvrBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nvrBtn];
    
}

#pragma mark btnEvents

-(void)reportBtnClick:(UIButton *)btn{
    if([self.delegate respondsToSelector:@selector(customBar:toReport:)]){
        [self.delegate customBar:self toReport:btn];
    }
}
-(void)addBtnClick:(UIButton *)btn{
    if([self.delegate respondsToSelector:@selector(customBar:toAddBtn:)]){
        [self.delegate customBar:self toAddBtn:btn];
    }
}
-(void)nvrBtnClick:(UIButton *)btn{
    if([self.delegate respondsToSelector:@selector(customBar:toNVR:)]){
        [self.delegate customBar:self toNVR:btn];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat viewWidth=self.width/self.subviews.count;
    CGFloat left=0;
    for (UIView *subview in self.subviews) {
        subview.frame=CGRectMake(left, 0, viewWidth, self.height);
        left+=viewWidth;
    }
    
}
@end
