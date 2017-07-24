//
//  AppDelegate.m
//  kq_banbo_app
//
//  Created by hcy on 2016/11/23.
//  Copyright © 2016年 . All rights reserved.
//

#import "AppDelegate.h"
//#import <IQKeyboardManager.h>
#import <SDWebImageManager.h>
#import <UIImageView+WebCache.h>
#import "NIMSingleton.h"
#import "BanBoLoginViewController.h"
#import "BanBoUserInfoManager.h"
#import "BanBoSiteListViewController.h"
#import "BanBoProjectMainViewController.h"
#import "BanBoProject.h"
#import "UncaughtExceptionHandler.h"
#import "BanBoErrorDefine.h"
#import "YZHttpService.h"
@interface AppDelegate ()<YZHttpErrorExec,UIAlertViewDelegate>

@end
extern NSString *const BanBoLogoutNotification;

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   // SWIZZ_IT
    [self config];
    self.window=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyWindow];
    if ([[BanBoUserInfoManager sharedInstance] currentLoginInfo]) {
        [self userLogin];
    }else{
        [self userLogout];
    }
    [self.window makeKeyAndVisible];
    [self checkAppUpdate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout:) name:BanBoLogoutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logout:) name:BanBoTokenInvalidNotification object:nil];
    
   
    return YES;
}
-(void)checkAppUpdate
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        NSString * URL = @"https://itunes.apple.com/search?term=班博&country=cn&entity=software";
        //[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",AppID];
        URL = [URL stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
        if (!data) {
            return ;
        }
        NSError *error;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        // NSLog(@"jsonDic%@",jsonDict);
        jsonDict = [jsonDict[@"results"] firstObject];
        
        if (!error && jsonDict) {
            NSString *newVersion =jsonDict[@"version"];
            NSString *nowVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
            
            NSString *dot = @".";
            NSString *whiteSpace = @"";
            int newV = [newVersion stringByReplacingOccurrencesOfString:dot withString:whiteSpace].intValue;
            int nowV = [nowVersion stringByReplacingOccurrencesOfString:dot withString:whiteSpace].intValue;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(newV > nowV)
                {
                    NSString * title = @"版本信息";
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:jsonDict[@"releaseNotes"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新",nil];
                    [alert show];
                    
                }
                
            });
        }
    });
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        // 此处加入应用在app store的地址，方便用户去更新，一种实现方式如下：
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@?ls=1&mt=8",  AppID]];
        [[UIApplication sharedApplication] openURL:url];
    }
    
}

-(void)userLogin{
    BanBoLoginInfoModel *currentInfo=[[BanBoUserInfoManager sharedInstance] currentLoginInfo];
    if (currentInfo) {
        [[NIMSingletonManager sharedManager] createSingletonManager];
    }else{
        return;
    }
    
    BanBoUser *user= currentInfo.user;
    UIViewController *vc=nil;
    switch (user.roletype) {
            //总公司
        case BanBoUSerTypeIT:
        case BanBoUSerTypeBS:
            //分公司
        case BanBoUSerTypeSubIT:
        case BanBoUSerTypeSubBS:
            
        {
            vc=[BanBoSiteListViewController new];
            
        }
            break;
            //工地
        case BanBoUSerTypePM:
        case BanBoUSerTypeLWC:
        case BanBoUSerTypeLWM:
        {
            BanBoProject *project=[BanBoProject new];
            project.projectId=@(user.clientid);
            project.name=currentInfo.subtitle;
            vc=[[BanBoProjectMainViewController alloc] initWithProject:project];
        }
            break;
        default:
            [HCYUtil toastMsg:[NSString stringWithFormat:@"不支持的角色类型:%ld",(long)user.roletype] inView:nil];
            break;
    }
    if (vc) {
        DtMainNavigationController *navi=[[DtMainNavigationController alloc] initWithRootViewController:vc];
        UIWindow *keyWindow=[UIApplication sharedApplication].keyWindow;
        if (!keyWindow) {
            keyWindow=[[[UIApplication sharedApplication] windows] firstObject];
        }
        if (keyWindow) {
            keyWindow.rootViewController=navi;
        }
    }
}
-(void)userLogout{
    [self logout:nil];
}
-(void)logout:(NSNotification *)notification{
    UIViewController *currentVC=[UIApplication sharedApplication].keyWindow.rootViewController;
    if ([currentVC isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navi=(UINavigationController *)currentVC;
        if (navi.viewControllers.count) {
            currentVC=[navi.viewControllers firstObject];
        }
    }
    if ([currentVC isKindOfClass:[BanBoLoginViewController class]]) {
        return;
    }
    if([notification.name isEqualToString:BanBoTokenInvalidNotification]){
        [[BanBoUserInfoManager sharedInstance] removeCache];
        [HCYUtil toastMsg:@"登录失效,请重新登录" inView:nil];
    }
    else if ([notification.name isEqualToString:BanBoLogoutNotification])
    {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"username"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"password"];
        
    }
    [[NIMSingletonManager sharedManager] destroySingletonManager];
    BanBoLoginViewController * login = [[BanBoLoginViewController alloc]init];
    if (login) {
        [UIApplication sharedApplication].keyWindow.rootViewController = login;
    }
    
//    UIStoryboard *board=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UIViewController *vc= [board instantiateInitialViewController];
//    if (vc) {
//        [UIApplication sharedApplication].keyWindow.rootViewController=vc;
//    }
}
#pragma mark errorJudge
+(BOOL)shouldTransparentError:(NSError *)error resp:(NSDictionary *)resp{
    if (error.code==BanBoRemoteErrorTokenInvalid) {
        [[NSNotificationCenter defaultCenter] postNotificationName:BanBoTokenInvalidNotification object:nil];
        return NO;
    }
    
    return YES;
}

#pragma mark config
-(void)config{
    [self configHTTP];
    [self configLog];
    [self configCrashLog];
    [EZOpenSDK initLibWithAppKey:@"6bebd2e72a334af5ba1810284c145669"];

}
-(void)configHTTP{
    YZHttpServiceOption *option=[YZHttpServiceOption defaultOption];
    option.urlStr=@"http://mapi.51zhgd.com/";
//    option.urlStr=@"http://120.26.57.155:8888/kq_banbo_app/";
//    option.urlStr=@"http://192.168.0.211:8080/kq_banbo_app/";
    option.responseType=YZHttpServiceTypeJson;
    option.successCodeKey=@"code"; 
    option.errorDescKey=@"resultDes";
    option.successCodeArr=@[@200,@204,@"00000"];
    option.errorJudgeClass=[self class];
    [YZHttpService setOption:option];
}
-(void)configCrashLog{
    InstallUncaughtExceptionHandler();

}

-(void)configLog{
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    DDTTYLogger *ttyLogger=[DDTTYLogger sharedInstance];
    [ttyLogger setColorsEnabled:YES];
    [DDLog addLogger:ttyLogger];
//    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:fileLogger];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
