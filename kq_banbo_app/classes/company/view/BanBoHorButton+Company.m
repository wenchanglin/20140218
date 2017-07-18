//
//  BanBoHorButton+Company.m
//  kq_banbo_app
//
//  Created by hcy on 2016/11/29.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoHorButton+Company.h"

@implementation BanBoHorButton (Company)
+(instancetype)projectBtnWithText:(NSString *)text{
    BanBoHorButton *btn=[BanBoHorButton new];
    
    [btn setImage:[UIImage imageNamed:@"gcicon"] forState:UIControlStateNormal];
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setTitleColor:BanboHomeLabelColor forState:UIControlStateNormal];
    [btn sizeToFit];
    
    return btn;
}
+(instancetype)kaoqinBtnWithText:(NSString *)text{
    BanBoHorButton *btn=[BanBoHorButton new];
    
    [btn setImage:[UIImage imageNamed:@"kaoqinicon"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"kaoqinred"] forState:UIControlStateSelected];
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setTitleColor:BanboHomeLabelColor forState:UIControlStateNormal];
    [btn sizeToFit];
    
    return btn;
}
+(instancetype)deviceBtnWithText:(NSString *)text{
    BanBoHorButton *btn=[BanBoHorButton new];
    
    [btn setImage:[UIImage imageNamed:@"shebeiicon"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"shebeired"] forState:UIControlStateSelected];
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setTitleColor:BanboHomeLabelColor forState:UIControlStateNormal];
    [btn sizeToFit];
    
    return btn;
}

@end
