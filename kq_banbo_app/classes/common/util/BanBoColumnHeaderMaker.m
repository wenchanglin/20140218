//
//  BanBoColumnHeaderMaker.m
//  kq_banbo_app
//
//  Created by hcy on 2017/1/16.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "BanBoColumnHeaderMaker.h"
#import "BanBoColumnListViewController.h"
@interface BanBoColumnHeaderMaker()
@property(strong,nonatomic)NSArray *headerArr;
@end
@implementation BanBoColumnHeaderMaker

static BanBoColumnHeaderMaker *headerMaker;
+(instancetype)sharedInst{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        headerMaker=[BanBoColumnHeaderMaker new];
    });
    return headerMaker;
}
+(BanBoColumnHeader *)gzlbHeader{
    return  [[self sharedInst] headerArr][0];
}
+(BanBoColumnHeader *)grmcHeader{
return  [[self sharedInst] headerArr][1];
}
+(BanBoColumnHeader *)xxglHeader{
    return  [[self sharedInst] headerArr][2];
}
+(BanBoColumnHeader *)kqglHeader{
    return  [[self sharedInst] headerArr][3];
}
+(BanBoColumnHeader *)yhkhHeader{
    return  [[self sharedInst] headerArr][4];
}
//+(BanBoColumnHeader *)kqtjHeader{
//    return  [[self sharedInst] headerArr][5];
//}
+(BanBoColumnHeader *)healthHeader{
    return  [[self sharedInst] headerArr][5];
}
+(BanBoColumnHeader *)personalHeader{
    return  [[self sharedInst] headerArr][6];
}
+(BanBoColumnHeader *)VRXQYeHeader
{
    return [[self sharedInst] headerArr][7];
}
-(NSArray *)headerArr{
    if(!_headerArr){
        _headerArr=@[[self headerWithTitles:@[@"序 号",@"工号",@"姓 名",[self lastMonth],[self lastLastMonth],[self thisYear]] color:nil],
                     [self headerWithTitles:@[@"序 号",@"工号",@"姓 名",@"班组",@"小班组",@"进场时间"] color:nil],
                     [self headerWithTitles:@[@"序 号",@"工号",@"姓 名",@"合同签署时间",@"工商保险时间"] color:nil],
                     [self headerWithTitles:@[@"序 号",@"工号",@"姓 名",[self thisMonth],[self lastMonth],[self thisYear]] color:nil],
                     [self headerWithTitles:@[@"序 号",@"工号",@"姓 名",@"开户银行",@"银行卡号"] color:nil],
                     [self headerWithTitles:@[@"序 号",@"工号",@"姓 名",@"身份证",@"生活照",@"血压",@"心电图"] color:nil],
                     [self headerWithTitles:@[@"序 号",@"工 号",@"姓 名",@"工 班",@"是否同步",@"报到时间"] color:@[[UIColor hcy_colorWithString:@"#9a9a9a"],[UIColor  hcy_colorWithString:@"#333333"],[UIColor hcy_colorWithString:@"#666666"]]],
                     [self headerWithTitles:@[@"序号",@"工号",@"姓名",@"培训",@"未培训",@"通过"] color:nil]];
        
    }
    return _headerArr;
}
-(BanBoColumnHeader *)headerWithTitles:(NSArray *)titles color:(NSArray *)colorArr{
    BanBoColumnHeader *header=[BanBoColumnHeader new];
    
    header.cellClass=@"BanboMutLabelColumnCell";
    header.titles=titles;
    header.cellHeight=34;
    if (colorArr) {
        header.textColorArr=colorArr;
    }
    return header;
}
#pragma mark 辅助
-(NSString *)thisMonth{
    NSInteger i= [YZDateHelper monthByAddMonth:0];
    return [NSString stringWithFormat:@"%ld月",(long)i];
}
-(NSString *)lastMonth{
    NSInteger i= [YZDateHelper monthByAddMonth:-1];
    return [NSString stringWithFormat:@"%ld月",(long)i];
}
-(NSString *)lastLastMonth{
    NSInteger i= [YZDateHelper monthByAddMonth:-2];
    return [NSString stringWithFormat:@"%ld月",(long)i];
}
-(NSString *)thisYear{
    NSInteger i= [YZDateHelper yeaderByAddYear:0];
    return [NSString stringWithFormat:@"%ld年",(long)i];
}

@end

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

