//
//  BanBoReportListCell.m
//  kq_banbo_app
//
//  Created by hcy on 2017/1/16.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "BanBoReportListCell.h"
#import "BanBoRecordsObj.h"
@interface BanBoReportListCell()
@property(strong,nonatomic)UIImageView *statusImageView;
@property(strong,nonatomic)UIImageView *arrowImageView;
@end
@implementation BanBoReportListCell

-(void)createLabelWithCount:(NSInteger)count font:(UIFont *)font colorDict:(NSDictionary *)textColorDict{
    [super createLabelWithCount:count font:font colorDict:textColorDict];
    [self labelAtIdx:4].textAlignment=NSTextAlignmentLeft;
    UIImageView *statusImageView=[UIImageView new];
    [self.contentView addSubview:statusImageView];
    self.statusImageView=statusImageView;
    
    UIImageView *imageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
    [self.contentView addSubview:imageView];
    self.arrowImageView=imageView;
}
-(void)refrehWithItem:(id<YZMemberProtocol>)item isLast:(BOOL)last userInfo:(NSDictionary *)userInfo{
    [super refrehWithItem:item isLast:last userInfo:userInfo];
    if ([item isKindOfClass:[BanBoRecordCellObj class]]) {
        BanBoRecordCellObj *cellObj=(BanBoRecordCellObj *)item;
        BanBoRecordData *data =cellObj.data;
        if(data.xuhao<1) return;
        CGRect labelRect=[self.columnLayoutManager rectForColumnAtIndex:4 row:[NSIndexPath indexPathForRow:data.xuhao-1 inSection:0]];
        if([data.status isEqualToString:@"Waiting"]){
            self.statusImageView.image=[UIImage imageNamed:@"dengdaizhong"];
        }else{
            self.statusImageView.image=[UIImage imageNamed:@"tongbuzhong"];
        }
        [self.statusImageView sizeToFit];
        self.statusImageView.right=CGRectGetMaxX(labelRect)-5;
    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.statusImageView.centerY=self.height*.5;
    
    self.arrowImageView.centerY=self.height*.5;
    self.arrowImageView.right=self.width-2;
}
@end
