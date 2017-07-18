//
//  BanBoRoomFenPeiVC.m
//  kq_banbo_app
//
//  Created by banbo on 2017/4/21.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "BanBoRoomFenPeiVC.h"
#import "YZTitleView+BanBo.h"
#import "BanBoSuSheImageHeaderView.h"
#import "BanBoSuSheCondiView.h"
#import "BanBoSuSheManager.h"
#import "BanBoShiMinManager.h"
@interface BanBoRoomFenPeiVC ()<BanBoSuSheCondiViewDelegate>
@property(strong,nonatomic)BanBoSuSheCondiView *conditionView;
@property(nonatomic,strong)NSNumber * groupid;
@end

@implementation BanBoRoomFenPeiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BanBoViewBgGrayColor;
    YZTitleView *titleView=[YZTitleView banbo_inst];
    [titleView showInNaviItem:self.navigationItem];
    [self setupSubviews];
}


-(void)setupSubviews
{
    BanBoSuSheImageHeaderView * header = [[BanBoSuSheImageHeaderView alloc]init];
    header.top = 64;
    header.text = [NSString stringWithFormat:@"%@->%@",self.louStr,_models.roomid];
    [self.view addSubview:header];
    BanBoSuSheCondiView * conditionView = [BanBoSuSheCondiView new];
    conditionView.top = header.bottom;
    conditionView.width = self.view.width;
    conditionView.delegate =self;
    _conditionView.banzhuLabel.rightLabel.text =BanzhuSelectDefaultText;
    _conditionView.xiaobanzhuLabel.rightLabel.text =BanzhuSelectDefaultText;
    [self.view addSubview:conditionView];
    self.conditionView = conditionView;
    UIButton * baocunBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-160)/2, CGRectGetMaxY(_conditionView.frame), 160, 40)];
    [self.view addSubview:baocunBtn];
    [baocunBtn setTitle:@"保存分配" forState:UIControlStateNormal];
    baocunBtn.layer.cornerRadius = 10;
    baocunBtn.layer.masksToBounds = YES;
    [baocunBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [baocunBtn setBackgroundColor:BanBoNaviBgColor];
    [baocunBtn addTarget:self action:@selector(baocun:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)baocun:(UIButton *)button
{
    [[BanBoSuSheManager sharedInstance]postRoomWithRid:_models.rid withMaxGroupId:_models.maxgroupid withGroupId:_models.groupid completion:^(id data, NSError *error) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"保存分配成功" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
        [self cleanCache];
    }];
    
}
-(void)cleanCache{
    [self cleanBanzhu];
    [self cleanXiaoBanzhu];
}
-(void)cleanBanzhu{
    self.conditionView.banzhuLabel.rightLabel=nil;
    [[YZCacheManager sharedInstance] removeCacheForKey:YZCacheKeyBanzhuItem type:YZCacheTypeMemory];
}
-(void)cleanXiaoBanzhu{
    self.conditionView.xiaobanzhuLabel.rightLabel=nil;
    [[YZCacheManager sharedInstance] removeCacheForKey:YZCacheKeyXiaoBanzhuItem type:YZCacheTypeMemory];
}
#pragma mark - condiDelegate
-(void)conditionViewConditionChanged:(BanBoSuSheCondiView *)conditionView{
    _models.maxgroupid = @(conditionView.xiaobanzhu.maxgroupid);
    _models.groupid = @(conditionView.xiaobanzhu.groupid);

}

@end
