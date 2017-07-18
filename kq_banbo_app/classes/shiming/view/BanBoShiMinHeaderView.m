//
//  BanBoShiMinHeaderView.m
//  kq_banbo_app
//
//  Created by hcy on 2016/12/5.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoShiMinHeaderView.h"
#import "BanBoImageHeaderView.h"
#import "BanBoShiminCondiView.h"
#import "BanBoShiminListItem.h"
@interface BanBoShiMinHeaderView ()<BanBoShiminCondiViewDelegate>
@property(strong,nonatomic)BanBoImageHeaderView *header;
@property(strong,nonatomic)BanBoShiminCondiView *conditionView;
@property(copy,nonatomic)NSString *projectName;
@end
@implementation BanBoShiMinHeaderView
-(instancetype)initWithItem:(BanBoShiminListItem *)item projectName:(NSString *)projectName{
    if (self=[super init]) {
        self.projectName=projectName;
        [self setupSubviews];
    }
    return self;
}
-(void)setHeaderText:(NSString *)text{
    _header.text=text;
}
-(BanBoBanzhuItem *)banzhuItem{
    return _conditionView.banzhu;
}
-(BanBoBanzhuItem *)xiaobanzhuItem{
    return _conditionView.xiaobanzhu;
}
-(NSString *)userText{
    return _conditionView.gongren;
}
-(void)setupSubviews{
    BanBoImageHeaderView *header=[BanBoImageHeaderView new];
    header.text=self.projectName;
    [self addSubview:header];
    self.header=header;
    
    BanBoShiminCondiView *conditionView=[BanBoShiminCondiView new];
    conditionView.top=header.bottom;
    conditionView.delegate=self;
    [self addSubview:conditionView];
    self.conditionView=conditionView;
    
    self.bounds=CGRectMake(0, 0, self.width, conditionView.bottom);
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.header.width=self.width;
    
    self.conditionView.width=self.width;
    self.conditionView.top=self.header.bottom;
}

#pragma mark condiDelegate
-(void)conditionViewConditionChanged:(BanBoShiminCondiView *)conditionView{
    if([self.delegate respondsToSelector:@selector(headerViewConditionChanged:)]){
        [self.delegate headerViewConditionChanged:self];
    }
}
-(void)conditionView:(BanBoShiminCondiView *)view searchBtnClicked:(UIButton *)searchBtn{
    if ([self.delegate respondsToSelector:@selector(headerViewSearchBtnClicked:)]) {
        [self.delegate headerViewSearchBtnClicked:self];
    }
}

@end
