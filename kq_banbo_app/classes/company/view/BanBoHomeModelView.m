//
//  BanBoHomeModelView.m
//  kq_banbo_app
//
//  Created by hcy on 2016/12/1.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoHomeModelView.h"
#import "YZVerButton.h"
@interface BanBoHomeModelView()
@property(strong,nonatomic)YZVerButton *shiminBtn;
@property(strong,nonatomic)YZVerButton *susheBtn;
@property(strong,nonatomic)YZVerButton *peixunBtn;
@property(strong,nonatomic)YZVerButton * huanjingBtn;

@end

@implementation BanBoHomeModelView
@synthesize containerView=_containerView;
- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.enableTapBgToClose=YES;
        self.dismissAfterClick=YES;
        [self setupSubviews];
       
    }
    return self;
}
-(void)showInView:(UIView *)supView{
    [super showInView:supView fromWhere:kCATransitionFromBottom dur:0.25];

}
-(CGFloat)bgLayerShowVal{
    return .36;
}
-(CGFloat)bgLayerHiddenVal{
    return 0;
}
-(void)setupSubviews{
    CGFloat containerHeight=[self contentHeight]+[self bottomHeight];
    UIView *containerView=[[UIView alloc] initWithFrame:CGRectMake(0, self.height-containerHeight*2, self.width, containerHeight*2)];
    containerView.autoresizingMask=(UIViewAutoresizingFlexibleWidth|UIStackViewAlignmentTop);
    

    UIButton *bottomView=[[UIButton alloc] initWithFrame:CGRectMake(0,[self contentHeight]*2, self.width, [self bottomHeight])];
    [bottomView setBackgroundColor:[UIColor whiteColor]];
    [bottomView setImage:[UIImage imageNamed:@"quxiao"] forState:UIControlStateNormal];
    bottomView.adjustsImageWhenHighlighted=NO;
    [containerView addSubview:bottomView];
    [bottomView addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *separView=[[UIView alloc] init];
    separView.height=2;
    separView.left=0;
    separView.width=self.width;
    separView.backgroundColor=BanBoViewBgGrayColor;
    separView.top=bottomView.top;
    [containerView addSubview:separView];
    
    
    UIView *contentView=[[UIView alloc] init];
    contentView.left=0;
    contentView.width=self.width;
    contentView.height=[self contentHeight];
    contentView.bottom=bottomView.top;
    contentView.backgroundColor=[UIColor whiteColor];
    [containerView addSubview:contentView];
    
    self.shiminBtn=[self makeBtnWithText:@"实名制" image:@"shiminzhi"];
    [contentView addSubview:self.shiminBtn];
    self.shiminBtn.tag=1;
    
    self.susheBtn=[self makeBtnWithText:@"宿舍" image:@"sushe"];
    [contentView addSubview:self.susheBtn];
    self.susheBtn.tag=2;
    
    self.peixunBtn=[self makeBtnWithText:@"培训" image:@"peixun"];
    [contentView addSubview:self.peixunBtn];
    self.peixunBtn.tag=3;
    self.huanjingBtn = [self makeBtnWithText:@"环境监控" image:@"huanjingjiankong"];
    self.huanjingBtn.tag =4;
    [contentView addSubview:self.huanjingBtn];
    SEL btnSelector=@selector(btnClick:);
    [self.shiminBtn addTarget:self action:btnSelector forControlEvents:UIControlEventTouchUpInside];
    [self.susheBtn addTarget:self action:btnSelector forControlEvents:UIControlEventTouchUpInside];
    [self.peixunBtn addTarget:self action:btnSelector forControlEvents:UIControlEventTouchUpInside];
    [self.huanjingBtn addTarget:self action:btnSelector forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat btnWidth=contentView.width/3;
    CGFloat btnHeight=contentView.height*.6;
    CGFloat centerY=contentView.height*.5;
    
    self.shiminBtn.width=btnWidth;
    self.susheBtn.width=btnWidth;
    self.peixunBtn.width=btnWidth;
    self.huanjingBtn.width = btnWidth;
    self.shiminBtn.height=btnHeight;
    self.susheBtn.height=btnHeight;
    self.peixunBtn.height=btnHeight;
    self.huanjingBtn.height = btnHeight;
    self.shiminBtn.center=CGPointMake(btnWidth*.5, centerY);
    self.susheBtn.center=CGPointMake(contentView.width*.5, centerY);
    self.peixunBtn.center=CGPointMake(self.susheBtn.centerX+btnWidth, centerY);
    self.huanjingBtn.center = CGPointMake(self.shiminBtn.bottom+20, centerY);
    [self addSubview:containerView];
    _containerView=containerView;
}
-(void)btnClick:(UIButton *)btn{
    if (self.actionDelegate==nil) {
        return;
    }
    SEL delegateSel=nil;
    switch (btn.tag) {
        case 1:
        {
            delegateSel=@selector(toShimin:);
        }
            break;
        case 2:
        {
            delegateSel=@selector(toSuShe:);
        }
            break;
        case 3:
        {
            delegateSel=@selector(toPeixun:);
        }
            break;
        default:
            break;
    }
    if (delegateSel && [self.actionDelegate respondsToSelector:delegateSel])  {
        [self.actionDelegate performSelector:delegateSel withObject:btn];
    }
    if (delegateSel && self.dismissAfterClick) {
        [self closeBtnClick:nil];
    }
    
}

-(YZVerButton *)makeBtnWithText:(NSString *)text image:(NSString *)imageName{
    YZVerButton *btn=[YZVerButton new];
    btn.adjustsImageWhenHighlighted=NO;
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor hcy_colorWithString:@"#666666"] forState:UIControlStateNormal];
    [btn sizeToFit];
    return btn;
}

-(void)closeBtnClick:(UIButton *)btn{
    [super dismissToWhere:kCATransitionFromBottom dur:0.25];
}

-(CGFloat)contentHeight{
    return 358*.5;
}
-(CGFloat)bottomHeight{
    return 95*.5;
}

@end
