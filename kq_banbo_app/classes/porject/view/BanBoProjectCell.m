
//
//  BanBoProjectCell.m
//  kq_banbo_app
//
//  Created by hcy on 2016/11/30.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoProjectCell.h"
#import "HCYColumnLayoutManager.h"
#import "BanBoProjectDetail.h"
@implementation BanBoProjectCell

@end
#pragma mark listCell
@interface BanBoProjectListCell()
@property(strong,nonatomic)UILabel *groupNameLabel;
@property(strong,nonatomic)UILabel *todayLabel;
@property(strong,nonatomic)UILabel *yestLabel;
@property(strong,nonatomic)UILabel *sevenDayLabel;
@property(strong,nonatomic)UILabel *thirtyDayLabel;
@property(strong,nonatomic)NSArray *labelIndexArr;
@end
@implementation BanBoProjectListCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *contentView=self.contentView;

        self.groupNameLabel=[self makeLabel];
        [contentView addSubview:self.groupNameLabel];
        
        self.todayLabel=[self makeLabel];
        [contentView addSubview:self.todayLabel];
        
        self.yestLabel=[self makeLabel];
        [contentView addSubview:self.yestLabel];
        
        self.sevenDayLabel=[self makeLabel];
        [contentView addSubview:self.sevenDayLabel];
        
        self.thirtyDayLabel=[self makeLabel];
        [contentView addSubview:self.thirtyDayLabel];
        
        self.labelIndexArr=@[self.groupNameLabel,self.todayLabel,self.yestLabel,self.sevenDayLabel,self.thirtyDayLabel];
    }
    return self;
}
-(UILabel *)makeLabel{
    UILabel *label= [YZLabelFactory blackLabel];
    label.textColor=BanboHomeLabelColor;
    label.textAlignment=NSTextAlignmentCenter;
    return label;
}
-(void)refrehWithItem:(BanBoProjectDetailCellObj *)item isLast:(BOOL)last userInfo:(NSDictionary *)userInfo{
    
    _groupNameLabel.text=[item titleAtIndex:0];
    _todayLabel.text=[item titleAtIndex:1];
    
    NSIndexPath *path=userInfo[BanBoColumnIndexPathKey];
    if (!path) {
        return;
    }
    NSInteger i=0;
    for (UILabel *label in self.labelIndexArr) {
        
        label.text=[item titleAtIndex:i];
        label.frame=[self myRectForIdx:i path:path];
        label.height=item.cellHeight;
        i++;
    }
}
-(NSString *)strWithInterger:(NSInteger)integer{
    return [NSString stringWithFormat:@"%ld",(long)integer];
    
}
-(CGRect)myRectForIdx:(NSInteger)columnIdx path:(NSIndexPath *)path{
    CGRect tmpRect= [self.columnLayoutManager rectForColumnAtIndex:columnIdx row:path];
//    tmpRect.size.height=self.height;
    return tmpRect;
}
@end
