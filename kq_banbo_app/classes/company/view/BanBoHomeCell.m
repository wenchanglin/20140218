//
//  BanBoCompanyHomeCell.m
//  kq_banbo_app
//
//  Created by hcy on 2016/11/29.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoHomeCell.h"
#import "BanBoHomeDetail.h"
#import "BanBoHorButton+Company.h"
@interface BanBoHomeCell()


@end
@implementation BanBoHomeCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *separView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)];
        separView.backgroundColor=BanBoHomeSeparColor;
        [self.contentView addSubview:separView];
        self.separView=separView;
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)refrehWithItem:(id<YZMemberProtocol>)item isLast:(BOOL)last userInfo:(NSDictionary *)userInfo{
    self.data=item;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.separView.top=self.height-1;
    self.separView.width=self.width;
}

@end
#pragma mark companyCell
@interface BanboHomeSubCompanyCell()
@property(strong,nonatomic)UIImageView *iconView;
@property(strong,nonatomic)UILabel *nameLabel;
@property(strong,nonatomic)BanBoHorButton *projectBtn;
@property(strong,nonatomic)BanBoHorButton *deviceBtn;
@property(strong,nonatomic)BanBoHorButton *kaoqinBtn;
@end
@implementation BanboHomeSubCompanyCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubviews];
    }
    return self;
}
-(void)setupSubviews{
    UIView *view=self.contentView;
    
    UIImageView *iconView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_company"]];
    iconView.left=55;
    [view addSubview:iconView];

    self.iconView=iconView;
    
    UILabel *nameLabel=[YZLabelFactory blackLabel];
    nameLabel.textColor=BanboHomeLabelColor;
    [view addSubview:nameLabel];
    
    //根据安卓说的只显示6个字。自己算太麻烦。就设置一下喽~
    nameLabel.text=@"第一工程公司";
    [nameLabel sizeToFit];
    nameLabel.width+=5;
    nameLabel.text=@"";
    
    self.nameLabel=nameLabel;
    
    BanBoHorButton *projectBtn=[BanBoHorButton projectBtnWithText:@""];
    [view addSubview:projectBtn];
    self.projectBtn=projectBtn;
    
    BanBoHorButton *deviceBtn=[BanBoHorButton deviceBtnWithText:@""];
    [view addSubview:deviceBtn];
    self.deviceBtn=deviceBtn;
    
    BanBoHorButton *kaoqinBtn=[BanBoHorButton kaoqinBtnWithText:@""];
    [view addSubview:kaoqinBtn];
    self.kaoqinBtn=kaoqinBtn;
}
#pragma mark refresh
-(void)refrehWithItem:(BanBoHomeDetailInfoCellObj *)item isLast:(BOOL)last userInfo:(NSDictionary *)userInfo{
    [super refrehWithItem:item isLast:last userInfo:userInfo];
    BanBoHomeDetailInfoSubCompany *company=(BanBoHomeDetailInfoSubCompany *)item.data;
    self.nameLabel.text=company.name;
    [self.projectBtn setTitle:[NSString stringWithFormat:@"%ld",(long)company.DeviceProperly] forState:UIControlStateNormal];
    [self.deviceBtn setTitle:[NSString stringWithFormat:@"%ld",(long)company.DeviceProperly] forState:UIControlStateNormal];
    [self.kaoqinBtn setTitle:[NSString stringWithFormat:@"%ld",(long)company.CheckProperly] forState:UIControlStateNormal];
    
    [self.projectBtn sizeToFit];
    [self.deviceBtn sizeToFit];
    [self.kaoqinBtn sizeToFit];

    [self setNeedsLayout];
}


#pragma mark layout
-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat separLeft=10;
    self.separView.left=separLeft;
    self.separView.width-=separLeft*2;
    
    CGFloat viewCenterY=self.height*.5;
    CGFloat btnMargin=[BanBoLayoutParam homeBtnMargin];
    
    self.iconView.centerY=viewCenterY;
    
    _nameLabel.centerY=viewCenterY;
    _nameLabel.left=_iconView.right+12;

    _projectBtn.left=_nameLabel.right+btnMargin;
    _projectBtn.centerY=viewCenterY;
    
    _deviceBtn.left=_projectBtn.right+btnMargin;
    _deviceBtn.centerY=viewCenterY;
    
    _kaoqinBtn.left=_deviceBtn.right+btnMargin;
    _kaoqinBtn.centerY=viewCenterY;
    
}
@end
#pragma mark projectCell
@interface BanBoHomeProjectCell()
@property(strong,nonatomic)UILabel *nameLabel;
@property(strong,nonatomic)BanBoHorButton *deviceBtn;
@property(strong,nonatomic)BanBoHorButton *kaoqinBtn;
@end
@implementation BanBoHomeProjectCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubviews];
    }
    return self;
}
-(void)setupSubviews{
    UIView *view=self.contentView;
    
    UILabel *nameLabel=[YZLabelFactory blackLabel];
    nameLabel.textColor=BanboHomeLabelColor;
    nameLabel.text=@"第一工程公司";
    [nameLabel sizeToFit];
    nameLabel.width+=5;
    nameLabel.text=@"";
    
    [view addSubview:nameLabel];
    self.nameLabel=nameLabel;
    
    NSString *normalStr=NSLocalizedString(@"正常", nil);
    NSString *unNormalStr=NSLocalizedString(@"异常", nil);
    
    BanBoHorButton *deviceBtn=[BanBoHorButton deviceBtnWithText:normalStr];
    [deviceBtn setTitle:unNormalStr forState:UIControlStateSelected];
    [view addSubview:deviceBtn];
    self.deviceBtn=deviceBtn;
    
    BanBoHorButton *kaoqinBtn=[BanBoHorButton kaoqinBtnWithText:normalStr];
    [kaoqinBtn setTitle:unNormalStr forState:UIControlStateSelected];
    [view addSubview:kaoqinBtn];
    self.kaoqinBtn=kaoqinBtn;
    
}

-(void)refrehWithItem:(id<YZMemberProtocol>)item isLast:(BOOL)last userInfo:(NSDictionary *)userInfo{
    [super refrehWithItem:item isLast:last userInfo:userInfo];
    BanBoHomeDetailInfoProject *project=(BanBoHomeDetailInfoProject *)[(BanBoHomeDetailInfoCellObj *)item  data];
    self.nameLabel.text=project.name;
    
    BOOL devIsUnNormal= project.devType==0;
    [self.deviceBtn setSelected:devIsUnNormal];
    
    BOOL kaoqinIsUnNormal=project.KqType==0;
    [self.kaoqinBtn setSelected:kaoqinIsUnNormal];
    
    [self.deviceBtn sizeToFit];
    [self.kaoqinBtn sizeToFit];
    [self setNeedsLayout];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat labelLeft=80;
    CGFloat viewCenterY=self.height*.5;
    
    self.separView.left=labelLeft;
    self.separView.width=self.width-self.separView.left-10;
    
    _nameLabel.left=labelLeft;
    _nameLabel.centerY=viewCenterY;
    
    CGFloat btnMargin=[BanBoLayoutParam homeBtnMargin];
    _deviceBtn.left=_nameLabel.right+btnMargin;
    _deviceBtn.centerY=viewCenterY;
    
    _kaoqinBtn.left=_deviceBtn.right+btnMargin;
    _kaoqinBtn.centerY=viewCenterY;
    
}
@end



