//
//  YZBaseViewController.m
//  YZWaimaiCustomer
//
//  Created by hcy on 16/9/1.
//  Copyright © 2016年 hcy@yz. All rights reserved.
//

#import "YZBaseViewController.h"

@interface YZBaseViewController ()

@end

@implementation YZBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[self YZViewBgColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIColor *)YZViewBgColor{
    return [UIColor grayColor];
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
