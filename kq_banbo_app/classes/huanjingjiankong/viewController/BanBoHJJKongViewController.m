//
//  BanBoCeShiViewController.m
//  kq_banbo_app
//
//  Created by banbo on 2017/5/9.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "BanBoHJJKongViewController.h"
#import "XXPageTabView.h"
#import "BanBoHJJKFatherVC.h"
@interface BanBoHJJKongViewController ()<XXPageTabViewDelegate>
@property (nonatomic, strong) XXPageTabView *pageTabView;
@end

@implementation BanBoHJJKongViewController
{
    NSMutableArray * _viewControllers;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"环境监控";
    _viewControllers = [NSMutableArray array];
    for (int i=0; i<_array.count; i++) {
        BanBoHJJKFatherVC * vc = [[BanBoHJJKFatherVC alloc]init];
        vc.modelsef  = _subArray[i];
        vc.HuanJid = _VCarray[i];
        [_viewControllers addObject:vc];
    }
    self.pageTabView = [[XXPageTabView alloc]initWithChildControllers:_viewControllers childTitles:_array];
    self.pageTabView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-60);
    self.pageTabView.delegate = self;
    self.pageTabView.unSelectedColor = BanBoLabelGrayColor;
    self.pageTabView.selectedColor = BanBoBlueColor;
    self.pageTabView.titleStyle = XXPageTabTitleStyleGradient;
    self.pageTabView.indicatorStyle = XXPageTabIndicatorStyleFollowText;
    self.pageTabView.bodyBounces = YES;
    [self.view addSubview:self.pageTabView];
    
    self.view.backgroundColor = [UIColor lightGrayColor];

   
}
- (void)pageTabViewDidEndChange {
   // NSLog(@"#####%zd", self.pageTabView.selectedTabIndex);
    NSInteger i= self.pageTabView.selectedTabIndex;
    if (_VCarray.count==0) {
        return;
    }
    else
    {
     [[NSNotificationCenter defaultCenter]postNotificationName:@"huanjingIndex" object:nil userInfo:@{@"user":_VCarray[i]}];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.pageTabView removeFromSuperview];
}


@end
