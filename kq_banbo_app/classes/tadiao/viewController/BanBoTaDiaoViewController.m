//
//  BanBoTaDiaoViewController.m
//  kq_banbo_app
//
//  Created by banbo on 2017/5/27.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "BanBoTaDiaoViewController.h"
#import "XXPageTabView.h"
#import "BanBoTaDiaoFatherViewController.h"

@interface BanBoTaDiaoViewController ()<XXPageTabViewDelegate>
@property (nonatomic, strong) XXPageTabView *pageTabView;
@property (nonatomic, strong) NSMutableArray * viewControllers;

@end

@implementation BanBoTaDiaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"塔吊";
   
    _viewControllers = [NSMutableArray array];
    for(int i=0;i<_tadiaoNameArray.count;i++){
        BanBoTaDiaoFatherViewController * tadiao  =[[BanBoTaDiaoFatherViewController alloc]init];
       
        tadiao.models = _tadiaoSubArray[i];
        tadiao.shebeimodel = _shebeiArray[i];
        tadiao.taDiaoid = _listArray[i];
        [_viewControllers addObject:tadiao];
     }
    self.pageTabView = [[XXPageTabView alloc]initWithChildControllers:_viewControllers childTitles:_tadiaoNameArray];
    self.pageTabView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-60);
    self.pageTabView.delegate = self;
    self.pageTabView.unSelectedColor = [UIColor hcy_colorWithString:@"#cccccc"];
    self.pageTabView.selectedColor = [UIColor hcy_colorWithString:@"#e54042"];
    self.pageTabView.titleStyle = XXPageTabTitleStyleGradient;
    self.pageTabView.bodyBounces = YES;
    self.pageTabView.indicatorStyle = XXPageTabIndicatorStyleFollowText;
    [self.view addSubview:self.pageTabView];    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)pageTabViewDidEndChange {
    if (_listArray.count==0) {
        return;
    }
    else
    {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"tadiaoIndex" object:nil userInfo:@{@"user":_listArray[self.pageTabView.selectedTabIndex]}];
    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.pageTabView removeFromSuperview];
}

@end
