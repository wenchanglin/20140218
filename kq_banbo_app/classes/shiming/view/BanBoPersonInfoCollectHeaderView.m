//
//  BanBoPersonInfoCollectHeaderView.m
//  kq_banbo_app
//
//  Created by hcy on 2016/12/8.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoPersonInfoCollectHeaderView.h"
#import "BanBoLineHeaderView.h"
#import "BanBoShiminDetail.h"
#import "BanBoHealthManager.h"
#import "IDCardBlueTooth.h"
@interface BanBoPersonInfoCollectHeaderView()
@property(strong,nonatomic)BanBoShiminUser *user;
@property(strong,nonatomic)BanBoLineHeaderView *nameLabel;
@property(strong,nonatomic)BanBoLineHeaderView *workNoLabel;
@property(strong,nonatomic)BanBoLineHeaderView *groupLabel;
@property(strong,nonatomic)BanBoLineHeaderView *subGroupLabel;

@property(strong,nonatomic)UIImageView *iconView;
@end
#define LabelTopMargin 5
#define IconTopMargin 7.5
#define IconHeight 139
#define LabelHeight 35
#define IconRightMargin 20
@implementation BanBoPersonInfoCollectHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    frame.size.height=IconHeight+IconTopMargin*2;
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        [self setupSubviews];
        
    }
    return self;
}

-(void)setupSubviews{
    BanBoLineHeaderView *nameLabel=[self makeLineHeaderView];
    nameLabel.leftLabel.text=@" 姓  名 ";
    [nameLabel.leftLabel sizeToFit];
    [self addSubview:nameLabel];
    _nameLabel=nameLabel;
    
    BanBoLineHeaderView *workNoLabel=[self makeLineHeaderView];
    workNoLabel.leftLabel.text=@" 工  号 ";
    [workNoLabel.leftLabel sizeToFit];
    [self addSubview:workNoLabel];
    _workNoLabel=workNoLabel;
    
    BanBoLineHeaderView *groupLabel=[self makeLineHeaderView];
    groupLabel.leftLabel.text=@" 大 工 班 ";
    [groupLabel.leftLabel sizeToFit];
    [self addSubview:groupLabel];
    _groupLabel=groupLabel;
    
    BanBoLineHeaderView *subGroupLabel=[self makeLineHeaderView];
    subGroupLabel.leftLabel.text=@" 小 工 班 ";
    [subGroupLabel.leftLabel sizeToFit];
    [self addSubview:subGroupLabel];
    subGroupLabel.rightLabel.adjustsFontSizeToFitWidth=YES;
    _subGroupLabel=subGroupLabel;
    
    nameLabel.leftLabel.width=subGroupLabel.leftLabel.width;
    workNoLabel.leftLabel.width=subGroupLabel.leftLabel.width;
    groupLabel.leftLabel.width=subGroupLabel.leftLabel.width;
    
    UIImageView *iconView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 115, IconHeight)];
    // iconView.image=[UIImage imageNamed:@"gongren"];
    iconView.layer.borderColor=BanBoViewBgGrayColor.CGColor;
    iconView.layer.borderWidth=1;
    //为了不被拉伸的很丑
    iconView.contentMode=UIViewContentModeScaleAspectFill;
    iconView.layer.masksToBounds=YES;
    [self addSubview:iconView];
    _iconView=iconView;
    
}

-(BanBoLineHeaderView *)makeLineHeaderView{
    BanBoLineHeaderView *lineHeader=[BanBoLineHeaderView new];
    
    CGFloat lineViewHeight=LabelHeight;
    CGFloat lineViewLeft=20;
    
    lineHeader.bottomSeparView.left=lineViewLeft;
    lineHeader.leftLabel.left=lineViewLeft;
    lineHeader.height=lineViewHeight;
    lineHeader.left=0;
    
    return lineHeader;
}
#pragma mark refresh
-(void)refreshWithUser:(BanBoShiminUser *)user{
    _nameLabel.rightLabel.text=user.UserName;
    _workNoLabel.rightLabel.text=[NSString stringWithFormat:@"%ld",(long)user.WorkNo];
    _groupLabel.rightLabel.text=user.GroupName;
    _subGroupLabel.rightLabel.text=user.SubGroupName;
    [HCYUtil showProgressWithStr:@"下载头像中"];
    [[BanBoHealthManager sharedInstance]getHeadPic:Inter_GetHeadPic forUser:user.CardId inProject:self.project.projectId completion:^(id data, NSError *error) {
        _iconView.image = [UIImage imageWithData:data];
        [HCYUtil dismissProgress];
        //DDLogInfo(@"life:%@",data);
    }];
    [_nameLabel.rightLabel sizeToFit];
    [_workNoLabel.rightLabel sizeToFit];
    [_groupLabel.rightLabel sizeToFit];
    [_subGroupLabel.rightLabel sizeToFit];
    
    [self setNeedsLayout];
}

#pragma mark layout
-(void)layoutSubviews{
    [super layoutSubviews];
    _iconView.top=IconTopMargin;
    _iconView.right=self.width-20;
    
    CGFloat labelWidth=_iconView.left-20;
    
    _nameLabel.top=LabelTopMargin;
    _nameLabel.width=labelWidth;
    
    _workNoLabel.top=_nameLabel.bottom;
    _workNoLabel.width=labelWidth;
    
    _groupLabel.top=_workNoLabel.bottom;
    _groupLabel.width=labelWidth;
    
    _subGroupLabel.top=_groupLabel.bottom;
    _subGroupLabel.width=labelWidth;
}
@end
