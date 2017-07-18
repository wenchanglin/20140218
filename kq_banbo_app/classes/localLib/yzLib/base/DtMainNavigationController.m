//
//  DtMainNavgitionController.m
//  DtWeibo
//
//  Created by hcy on 11/7/14.
//  Copyright (c) 2014 hcy. All rights reserved.
//
#import "UIView+HCY.h"
#import "DtMainNavigationController.h"
#import <Availability.h>
#import "HCYUtil.h"
#import "CustomLeftBarView.h"
@interface DtMainNavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate,CustomLeftBarItemItemProtocol>
@property(weak,nonatomic)UIGestureRecognizer *gest;

@end

@implementation DtMainNavigationController


+(void)initialize{
    
    [self setBarTheme];
    [self setItemTheme];
}

+(void)setBarTheme{
    
    UINavigationBar *navBar=[UINavigationBar appearance];
    [navBar setBarTintColor:[UIColor hcy_colorWithString:@"#e54042"]];
    //[navBar setBarTintColor:BanBoNaviBgColor];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    
    NSMutableDictionary *textAttrs=[NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName]=[UIColor whiteColor];
    
    [navBar setTitleTextAttributes:textAttrs];
}
-(void)viewDidLoad{
    [super viewDidLoad];
    if (!_gest) {
        _gest=self.interactivePopGestureRecognizer;
    }
    _gest.delegate=self;
}
+(void)setItemTheme{

    UIBarButtonItem *item=[UIBarButtonItem appearance];
    [item setTintColor:[UIColor whiteColor]];
    NSMutableDictionary *textAttrs=[NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName]=[UIColor whiteColor];
    [item setTitleTextAttributes:[textAttrs copy ]forState:UIControlStateNormal];
    
}


-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed=YES;
        if (viewController.navigationItem.leftBarButtonItems.count==0) {
            CustomLeftBarView *view=[CustomLeftBarView new];
            view.delegate=self;
            UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithCustomView:view];
            viewController.navigationItem.leftBarButtonItems=@[[self getNilBarItemWithWidth:-10],item];
        }
    }
  [super pushViewController:viewController animated:animated];
}


-(UIBarButtonItem *)getNilBarItemWithWidth:(CGFloat )width{

   UIBarButtonItem*  negativeSpacer=  [[UIBarButtonItem alloc]
             initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = width;
    return negativeSpacer;
}
-(void)onLeftButtonPressed{
    [self backBtnClick];
}
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
 
    [self cleanTabbar];
}

-(NSArray *)popToRootViewControllerAnimated:(BOOL)animated{
    NSArray *arr=[super popToRootViewControllerAnimated:animated];
    [self cleanTabbar];
    
    return arr;
}

-(void)backBtnClick{
    [self popViewControllerAnimated:YES];
    if (self.viewControllers.count==1) {
    }
}
-(void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion{
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}
-(NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
    NSArray *arr=[super popToViewController:viewController animated:animated];
    [self cleanTabbar];

    return arr;
}

-(void)cleanTabbar{
    for (UIView *child in self.tabBarController.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
//    if (self.viewControllers.count==1) {
//        self.tabBarController.tabBar.hidden=NO;
//    }else{
//        self.tabBarController.tabBar.hidden=YES;
//    }
}
@end
