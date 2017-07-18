//
//  DtWebViewController.m
//  NIM
//
//  Created by hcy on 15/10/9.
//  Copyright © 2015年 YzChina. All rights reserved.
//

#import "DtWebViewController.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "CustomLeftBarView.h"
#import "HCYUtil.h"
#import "UIView+HCY.h"
@interface DtWebViewController ()<UIWebViewDelegate,NJKWebViewProgressDelegate,CustomLeftBarItemItemProtocol,UIActionSheetDelegate>{
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
    
}
@property(strong,nonatomic)UIWebView *webView;
@property(strong,nonatomic)UIProgressView *process;
@property(strong,nonatomic)CustomLeftBarView *customLeftBar;
@property(strong,nonatomic)UIButton *closeBtn;
@property(strong,nonatomic)NSURL *url;
@end

@implementation DtWebViewController

-(instancetype)initWithUrlStr:(NSString *)str{
    if (self=[super init]) {
        if (![str hasPrefix:@"http://"]) {
            str=[NSString stringWithFormat:@"http://%@",str];
        }
        
        NSURL *url=[NSURL URLWithString:str];
        self.url=url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURLRequest *req=[NSURLRequest requestWithURL:self.url];
    _webView=[[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_webView];
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [_webView loadRequest:req];
    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"icon_n-bar_more_white"] forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"icon_n-bar_more_white_pressed"] forState:UIControlStateHighlighted];
    rightBtn.frame=CGRectMake(0, 0, 24, 24);
    [rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightNilItem=[HCYUtil getNilBarItemWithWidth:-10];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItems=@[rightNilItem,rightItem];
    if (!_customLeftBar) {
        CustomLeftBarView *barView=[[CustomLeftBarView alloc] init];
        barView.delegate=self;
        _customLeftBar=barView;
        _customLeftBar.width=30.f;
    }
    self.navigationItem.leftBarButtonItems=nil;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:_customLeftBar];
}
-(void)onLeftButtonPressed{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        [self setItems];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)setItems{
    if (!_closeBtn) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font=[UIFont systemFontOfSize:11.f];
        btn.layer.borderColor=[UIColor lightGrayColor].CGColor;
        btn.layer.borderWidth=1.f;
        [btn setTitle:NSLocalizedString(@"Btn_close", @"") forState:UIControlStateNormal];
        btn.layer.cornerRadius=3.f;
        [btn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame=CGRectMake(0, 0, 30, 24);
        _closeBtn=btn;
    }
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithCustomView:_customLeftBar];
    
    UIBarButtonItem *nilItem=[HCYUtil getNilBarItemWithWidth:-50];
    if(_closeBtn){
        UIBarButtonItem *item2=[[UIBarButtonItem alloc] initWithCustomView:_closeBtn];
         self.navigationItem.leftBarButtonItems=@[item,nilItem,item2];
    }else{
    self.navigationItem.leftBarButtonItems=@[item,nilItem];
    }
}
-(void)closeBtnClick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightBtnClicked:(UIButton *)btn{
    UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"a_1", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Btn_cancel", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"a_2", @""),NSLocalizedString(@"a_3", @""), nil];
    [actionSheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==[actionSheet cancelButtonIndex]) {
        return;
    }
    switch (buttonIndex) {
        case 0:
        {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = self.url.absoluteString;
            [HCYUtil toastMsg:NSLocalizedString(@"a_4", @"") inView:self.view];
        }
            break;
        case 1:
        {
            [[UIApplication sharedApplication] openURL:self.url];
        }
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_progressView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_progressView removeFromSuperview];
}
#pragma mark  webViewdelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.title=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}
@end
