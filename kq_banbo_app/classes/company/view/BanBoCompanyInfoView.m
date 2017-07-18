//
//  BanBoCompanyInfoView.m
//  kq_banbo_app
//
//  Created by hcy on 2016/11/28.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoCompanyInfoView.h"
#import "BanBoHorButton+Company.h"
@interface BanBoCompanyInfoView()
@property(strong,nonatomic)UIImageView *iconView;
@property(strong,nonatomic)UILabel *companyNameLabel;
@property(strong,nonatomic)BanBoHorButton *projectBtn;
@property(strong,nonatomic)BanBoHorButton *deviceBtn;
@property(strong,nonatomic)BanBoHorButton *kaoqinBtn;
@end
@implementation BanBoCompanyInfoView
#define projectDefaultText @"在建工程"
#define deviceDefaultText  @"设备"
#define kaoqinDefaultText  @"考勤"
- (instancetype)initWithFrame:(CGRect)frame
{
    frame.size.height=72;
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
        self.backgroundColor=[UIColor whiteColor];
        self.layer.cornerRadius=5;
    }
    return self;
}
#pragma mark subView
-(void)setupSubviews{
//    UIImageView *iconView=[UIImageView new];
    UIImageView *iconView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jiangong"]];
    
    iconView.top=14;
    iconView.left=23;
    iconView.width=35;
//    iconView.height=self.height-iconView.top-15;
    
//    iconView.image=[UIImage imageNamed:@"jiangong"];
    
    [self addSubview:iconView];
    self.iconView=iconView;
    
    UILabel *companyLabel=[YZLabelFactory blueLabel];
    [self addSubview:companyLabel];
    self.companyNameLabel=companyLabel;
    
    BanBoHorButton *projectBtn=[BanBoHorButton projectBtnWithText:projectDefaultText];
    [self addSubview:projectBtn];
    self.projectBtn=projectBtn;
    
    BanBoHorButton *deviceBtn=[BanBoHorButton deviceBtnWithText:deviceDefaultText];
    [self addSubview:deviceBtn];
    self.deviceBtn=deviceBtn;
    
    BanBoHorButton *kaoqinBtn=[BanBoHorButton kaoqinBtnWithText:kaoqinDefaultText];
    [self addSubview:kaoqinBtn];
    self.kaoqinBtn=kaoqinBtn;
    
    UIView *separView=[[UIView alloc] initWithFrame:CGRectMake(0, self.height-1, self.width, 1)];
    separView.backgroundColor=BanBoHomeSeparColor;
    separView.autoresizingMask=(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin);
    [self addSubview:separView];
}

#pragma mark set
-(void)setCompanyName:(NSString *)companyName{
    if ([companyName isEqualToString:_companyName]) {
        return;
    }
    _companyName=[companyName copy];
    
    [self.companyNameLabel setText:companyName];
    [self.companyNameLabel sizeToFit];
    [self setNeedsLayout];
}
-(void)setProjectCount:(NSInteger)projectCount{
    if (projectCount==_projectCount) {
        return;
    }
    _projectCount=projectCount;
    [self.projectBtn setTitle:[NSString stringWithFormat:@"%@ %ld",projectDefaultText,(long)projectCount] forState:UIControlStateNormal];
    [self.projectBtn sizeToFit];
    [self setNeedsLayout];
}
-(void)setDeviceCount:(NSInteger)deviceCount{
    if (deviceCount==_deviceCount) {
        return;
    }
    _deviceCount=deviceCount;
    [self.deviceBtn setTitle:[NSString stringWithFormat:@"%@ %ld",deviceDefaultText,(long)deviceCount] forState:UIControlStateNormal];
    [self.deviceBtn sizeToFit];
    [self setNeedsLayout];
}
-(void)setKaoqinCount:(NSInteger)kaoqinCount{
    if (kaoqinCount==_kaoqinCount && kaoqinCount!=0) {
        return;
    }
    _kaoqinCount=kaoqinCount;
    [self.kaoqinBtn setTitle:[NSString stringWithFormat:@"%@ %ld",kaoqinDefaultText,(long)kaoqinCount] forState:UIControlStateNormal];
    [self.kaoqinBtn sizeToFit];
}
#pragma mark layout
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat labelLeft=9;
    CGFloat btnMargin=[BanBoLayoutParam homeBtnMargin];
    
    _companyNameLabel.top=16;
    _companyNameLabel.left=self.iconView.right+labelLeft;
    
    _projectBtn.bottom=_iconView.bottom+2;
    _projectBtn.left=_companyNameLabel.left;
    
    
    _deviceBtn.left=_projectBtn.right+btnMargin;
    _deviceBtn.bottom=_projectBtn.bottom;
    
    _kaoqinBtn.left=_deviceBtn.right+btnMargin;
    _kaoqinBtn.bottom=_projectBtn.bottom;
    
    
    
}
@end
