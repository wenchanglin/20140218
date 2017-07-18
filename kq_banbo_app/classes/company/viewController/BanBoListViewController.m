//
//  BanBoListViewController.m
//  kq_banbo_app
//
//  Created by hcy on 2016/11/28.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoListViewController.h"

@interface BanBoListViewController ()

@end

@implementation BanBoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.topView];
    self.dataTableView.frame=[self banbo_dataTableFrame];
    self.dataTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.dataTableView.bounces=NO;
    // Do any additional setup after loading the view.
}
-(UIColor *)YZViewBgColor{
    return BanBoViewBgGrayColor;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(CGRect)banbo_dataTableFrame{
    return CGRectZero;
}
-(void)dealloc{
    DDLogInfo(@"i'm dealloc :%@",self);
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
