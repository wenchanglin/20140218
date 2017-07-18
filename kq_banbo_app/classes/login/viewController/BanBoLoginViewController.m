//
//  BanBoLoginViewController.m
//  kq_banbo_app
//
//  Created by hcy on 2016/11/28.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoLoginViewController.h"
#import "AppDelegate.h"
//manager
#import "BanBoUserInfoManager.h"
//viewController
#import "BanBoSiteListViewController.h"

#import "BanBoProject.h"
#import "BanBoProjectMainViewController.h"
#import "jsTextField.h"
@interface BanBoLoginViewController ()<UITextFieldDelegate>
@property (strong, nonatomic)  jsTextField *userNameField;
@property (strong, nonatomic)  jsTextField *passwordField;
@property(strong,nonatomic) UIButton * loginBtn;
@property(nonatomic,strong) UIImageView * imageV;
@property(nonatomic,strong) UIImageView * logo;
@end

@implementation BanBoLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addImageView];
    [self addTextFieldAndLoginInObs];
    
    // [self testData];
//     [self switchRootVC:NO];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    if ([UIApplication sharedApplication].statusBarStyle!=UIStatusBarStyleLightContent) {
        [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    }
}
-(void)addImageView
{
    _imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _imageV.image = [UIImage imageNamed:@"登录图"];
    _imageV.userInteractionEnabled=YES;
    _imageV.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_imageV];
    _logo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"登录页logo1"]];
    _logo.frame = CGRectMake((SCREEN_WIDTH-96)/2, SCREEN_HEIGHT/6, 96, 96);
    _logo.contentMode = UIViewContentModeScaleAspectFill;
    [_imageV addSubview:_logo];
    UIImageView * loginimge = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"班博科技智慧工地"]];
    loginimge.frame = CGRectMake((SCREEN_WIDTH-160)/2, CGRectGetMaxY(_logo.frame)+7, 160, 20);
    [_imageV addSubview:loginimge];
    
}
-(void)addTextFieldAndLoginInObs{
    UIImageView * usernameIcon=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"用户名"]];
    usernameIcon.frame=CGRectMake(0, 0, 20, 20);
    _userNameField = [[jsTextField alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(_logo.frame)+80, SCREEN_WIDTH-60, 40) drawingLeft:usernameIcon];
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"username"]) {
        self.userNameField.text =[[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    }
    else
    {
        self.userNameField.text = @"";
    }
    _userNameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"登录名" attributes:@{NSForegroundColorAttributeName: [UIColor hcy_colorWithString:@"#e5e5e5"]}];
    _userNameField.font = [UIFont systemFontOfSize:18];
    _userNameField.borderStyle=UITextBorderStyleRoundedRect;
    _userNameField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [_userNameField setBackgroundColor:[UIColor hcy_colorWithRed:0 green:0 blue:0 alpha:0.4]];
    [_imageV addSubview:_userNameField];
    UIImageView * passwordIcon=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"密码"]];
    passwordIcon.frame=CGRectMake(0, 0, 20, 20);
    _passwordField = [[jsTextField alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(_userNameField.frame)+20, SCREEN_WIDTH-60, 40) drawingLeft:passwordIcon];
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"password"]) {
        self.passwordField.text =[[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
    }
    else
    {
        self.passwordField.text = @"";
    }
    _passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"密码" attributes:@{NSForegroundColorAttributeName: [UIColor hcy_colorWithString:@"#e5e5e5"]}];
    _passwordField.font = [UIFont systemFontOfSize:18];
    _passwordField.secureTextEntry = YES;
    _passwordField.borderStyle=UITextBorderStyleRoundedRect;
    _passwordField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [_passwordField setBackgroundColor:[UIColor hcy_colorWithRed:0 green:0 blue:0 alpha:0.4]];
    [_imageV addSubview:_passwordField];
    self.userNameField.delegate=self;
    self.passwordField.delegate=self;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTaped:)];
    [self.view addGestureRecognizer:tap];
    _loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(_passwordField.frame)+20, SCREEN_WIDTH-60, 40)];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(loginBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [_loginBtn setTitleColor:[UIColor hcy_colorWithString:@"#ffffff"] forState:UIControlStateNormal];
    [_loginBtn setBackgroundColor:[UIColor hcy_colorWithString:@"#e54042"]];
    _loginBtn.layer.cornerRadius = 4;
    _loginBtn.layer.borderColor = [UIColor hcy_colorWithString:@"#dd3234"].CGColor;
    _loginBtn.layer.borderWidth = 1;
    [_imageV addSubview:_loginBtn];
}
-(void)testData{
    //#ifdef DEBUG
    //#ifdef HCYDEBUG
    ////    NSString *tmpuser=@"13456789002";
    //    NSString *tmpuser=@"13456869777";
    //#else
    ////    NSString *tmpuser=@"15858975583";
    //    NSString *tmpuser=@"13456789100";
    //    NSString *tmpuser=@"13456869777"; //nvr监控  寿国梁帐号-正式服
    //#endif
    
    //    self.userNameField.text=tmpuser;
    //    self.passwordField.text=tmpuser;
    //#endif
}
#pragma mark action
-(void)viewTaped:(UITapGestureRecognizer *)tap{
    if ([self.userNameField isFirstResponder] || [self.passwordField isFirstResponder]) {
        [self.view endEditing:YES];
    }
    
}

- (void)loginBtnClicked:(UIButton *)sender {
    if ([self checkCondition]) {
        self.view.userInteractionEnabled=NO;
        [self.view endEditing:YES];
        [self doLogin];
    }
}
-(void)doLogin{
    __weak typeof(self) wself=self;
    [HCYUtil showProgressWithStr:NSLocalizedString(@"登录中", nil)];
    [self.view endEditing:YES];
    [[BanBoUserInfoManager sharedInstance] loginWithAccount:self.userNameField.text pwd:self.passwordField.text completion:^(NSError *error) {
        if (!wself) {
            return ;
        }
        dispatch_async_main_safe(^{
            [HCYUtil dismissProgress];
            wself.view.userInteractionEnabled=YES;
            if (error) {
                [HCYUtil showError:error];
            }else{
                //切换控制器
                [wself switchRootVC:NO];
                NSUserDefaults * userdefault = [NSUserDefaults standardUserDefaults];
                [userdefault setObject:self.userNameField.text forKey:@"username"];
                [userdefault setObject:self.passwordField.text forKey:@"password"];
                [userdefault synchronize];
            }
        });
        
    }];
}

-(void)switchRootVC:(BOOL)isFirst{
    BanBoLoginInfoModel *currentInfo= [[BanBoUserInfoManager sharedInstance] currentLoginInfo];
    if(currentInfo){
        AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
        [appdelegate userLogin];
    }else{
        NSArray *loginInfos=[[BanBoUserInfoManager sharedInstance] loginInfos];
        if (loginInfos.count>1) {
            UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"请选择角色" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            for (NSInteger i=0; i<loginInfos.count; i++) {
                BanBoLoginInfoModel *infoModel=loginInfos[i];
                NSString *title=[NSString stringWithFormat:@"%@ %@",infoModel.subtitle,[[BanBoUserInfoManager sharedInstance] typeStrForRole:infoModel.user.roletype]];
                UIAlertAction *action=[UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[BanBoUserInfoManager sharedInstance]  setInfoIdx:i];
                    [self switchRootVC:isFirst];
                }];
                [controller addAction:action];
            }
            UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消登录" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [controller addAction:cancelAction];
            [self presentViewController:controller animated:YES completion:nil];
            
            //多角色选择
        }else if(loginInfos.count==1)
        {   //一个角色就选择那个就行
            [[BanBoUserInfoManager sharedInstance] setInfoIdx:0];
            [self switchRootVC:isFirst];
        }else{
            //没有角色信息
            if (isFirst==NO) {
                [HCYUtil toastMsg:@"当前登录用户没有角色信息" inView:self.view];
            }
            
        }
    }
}

-(BOOL)checkCondition{
    
    if (!self.userNameField.text.length) {
        [HCYUtil toastMsg:NSLocalizedString(@"请输入用户名", nil) inView:self.view];
        return NO;
    }
    if (!self.passwordField.text.length) {
        [HCYUtil toastMsg:NSLocalizedString(@"请输入密码", nil) inView:self.view];
        return NO;
    }
    return YES;
}
#pragma mark textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField==_userNameField) {
        [_passwordField becomeFirstResponder];
    }
    if (textField==_passwordField) {
        [self loginBtnClicked:nil];
    }
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    DDLogError(@"loginVC-dealloc");
}

@end
