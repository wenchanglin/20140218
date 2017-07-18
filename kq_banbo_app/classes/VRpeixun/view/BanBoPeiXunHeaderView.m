//
//  BanBoPeiXunHeaderView.m
//  kq_banbo_app
//
//  Created by banbo on 2017/6/26.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "BanBoPeiXunHeaderView.h"
#import "BanBoVRCondiView.h"
#import "BanBoVRDetailHeaderView.h"
@interface BanBoPeiXunHeaderView()<BanBoVRCondiViewDelegate>
@property(strong,nonatomic)BanBoVRCondiView *conditionView;
@property(nonatomic,strong)BanBoVRDetailHeaderView * header;
@property(copy,nonatomic)NSString *projectName;
@end

@implementation BanBoPeiXunHeaderView
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
    BanBoVRDetailHeaderView *header=[BanBoVRDetailHeaderView new];
    header.text=self.projectName;
    [self addSubview:header];
    self.header=header;
    
    BanBoVRCondiView *conditionView=[BanBoVRCondiView new];
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
-(void)conditionViewConditionChanged:(BanBoVRCondiView *)conditionView{
    if([self.delegate respondsToSelector:@selector(headerViewConditionChanged:)]){
        [self.delegate headerViewConditionChanged:self];
    }
}
-(void)conditionView:(BanBoVRCondiView *)view searchBtnClicked:(UIButton *)searchBtn{
    if ([self.delegate respondsToSelector:@selector(headerViewSearchBtnClicked:)]) {
        [self.delegate headerViewSearchBtnClicked:self];
    }
}



@end
