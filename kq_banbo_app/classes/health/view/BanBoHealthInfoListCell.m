//
//  BanBoHealthInfoListCell.m
//  kq_banbo_app
//
//  Created by hcy on 2016/12/8.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoHealthInfoListCell.h"
#import "BanBoHealthInfo.h"

@interface BanBoHealthInfoListCell()
@property(strong,nonatomic)UILabel *projectNameLabel;
@property(strong,nonatomic)UILabel *statusLabel;
@property(strong,nonatomic)UILabel *updateStrLabel;

@property(strong,nonatomic)UIButton *viewBtn;
@property(strong,nonatomic)UIButton *collectBtn;


@property(strong,nonatomic)BanBoHealthInfo *info;
@end
NSString*const BanBoHealthInfoViewBtnClicked=@"BanBoHealthInfoViewBtnClicked";//查看
NSString*const BanBoHealthInfoCollectBtnClicked=@"BanBoHealthInfoCollectBtnClicked";//采集
@implementation BanBoHealthInfoListCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _projectNameLabel=[YZLabelFactory blueLabel];
        [self.contentView addSubview:_projectNameLabel];
        _statusLabel=[YZLabelFactory blackLabel];
        _statusLabel.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:_statusLabel];
        
        _updateStrLabel=[YZLabelFactory blackLabel];
        _updateStrLabel.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:_updateStrLabel];
        
        
        _viewBtn=[self btnWithBgColor:[UIColor hcy_colorWithString:@"#fdc437"] title:@"查 看"];
        [_viewBtn addTarget:self action:@selector(viewBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_viewBtn];
        
        _collectBtn=[self btnWithBgColor:[UIColor hcy_colorWithString:@"#fd5b5b"] title:@"采 集"];
    
        [_collectBtn addTarget:self action:@selector(collectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_collectBtn];

    }
    return self;
}
-(UIButton *)btnWithBgColor:(UIColor *)bgColor title:(NSString *)title{
    UIButton *btn=[UIButton new];

    btn.titleLabel.font=[YZLabelFactory normalFont];
    [btn setBackgroundColor:bgColor];
    
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setAdjustsImageWhenHighlighted:NO];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn sizeToFit];
    btn.layer.cornerRadius=4;
    
    return btn;
}

-(void)refrehWithItem:(BanBoHealthInfo *)item isLast:(BOOL)last userInfo:(NSDictionary *)userInfo{
    _projectNameLabel.text=item.projectName;
    _statusLabel.text=item.statusStr;
    _updateStrLabel.text=item.updateDateStr;
    
    self.info=item;
    //比较low
    if([item.statusStr isEqualToString:@"有"]){
        [_viewBtn setTitle:@"查 看" forState:UIControlStateNormal];
        [_viewBtn setBackgroundColor:[UIColor hcy_colorWithString:@"#fdc437"]];
        _viewBtn.userInteractionEnabled=YES;
    }else{
        [_viewBtn setTitle:@"暂 无" forState:UIControlStateNormal];
        [_viewBtn setBackgroundColor:[UIColor hcy_colorWithString:@"#daa930"]];
        _viewBtn.userInteractionEnabled=NO;
    }
    NSIndexPath *path=userInfo[BanBoColumnIndexPathKey];
    if (path) {
        _projectNameLabel.frame=[self.columnLayoutManager rectForColumnAtIndex:0 row:path];
        _statusLabel.frame=[self.columnLayoutManager rectForColumnAtIndex:1 row:path];
        _updateStrLabel.frame=[self.columnLayoutManager rectForColumnAtIndex:2 row:path];
        _viewBtn.frame=[self.columnLayoutManager rectForColumnAtIndex:3 row:path];
        _collectBtn.frame=[self.columnLayoutManager rectForColumnAtIndex:4 row:path];
  
        [self setNeedsLayout];
    }
}
#pragma mark btnEvents
-(void)viewBtnClicked:(UIButton *)btn{
    DDLogInfo(@"viewBtnClicked");
    YZListCellEvent *event=[YZListCellEvent new];
    event.cell=self;
    event.data=self.info;
    event.eventName=BanBoHealthInfoViewBtnClicked;
    
    [super list_sendEvents:event];
}

-(void)collectBtnClicked:(UIButton *)btn{
    DDLogInfo(@"collectBtnClicked");
    YZListCellEvent *event=[YZListCellEvent new];
    event.cell=self;
    event.data=self.info;
    event.eventName=BanBoHealthInfoCollectBtnClicked;
    
    [super list_sendEvents:event];
}

#pragma mark other
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
}
-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    _projectNameLabel.height=self.height;
    
    _statusLabel.height=self.height;
    
    _updateStrLabel.height=self.height;
    
    
    CGFloat btnHeight=self.height*.6;
    
    _viewBtn.height=btnHeight;
    _viewBtn.centerY=self.height*.5;
    
    _collectBtn.height=btnHeight;
    _collectBtn.centerY=self.height*.5;
    
    
//    _collectionBgBtn.height=self.height;
//    _collectionBgBtn.width=(self.width-_updateStrLabel.right)*.8;
//    _collectionBgBtn.right=self.width;
//    _collectBtn.centerX=_collectionBgBtn.width*.5;
//    _collectBtn.centerY=self.height*.5;
//    _collectBtn.right=self.width;

//    _separView.left=0;
//    _separView.width=self.width;
//    _separView.top=self.height-1;
   
}
@end
