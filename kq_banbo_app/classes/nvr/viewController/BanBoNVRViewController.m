//
//  BanBoNVRViewController.m
//  kq_banbo_app
//
//  Created by hcy on 2017/2/15.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "BanBoNVRViewController.h"
#import "BanBoProject.h"
#import "NVRSDKManager.h"
#import "BanBoLineHeaderView.h"
#import "BanBoCustomTabbarView.h"
#import "BanBoChannelSelectView.h"
#import "BanBoReportListViewController.h"
#import "BanBoHomeModelView.h"
#import "BanBoShiminViewController.h"
#import "YZTitleView+BanBo.h"
#import "BanBoNVRManager.h"
#import "BanBoUserInfoManager.h"
@interface BanBoNVRViewController ()<BanboCustomTabbarDelegate,BanBoChannelSelectViewDelegate,BanBoHomeModelViewActionDelegate>
@property(strong,nonatomic)BanBoProject *project;
@property(strong,nonatomic)NSArray *hkChannels;
@property(strong,nonatomic)NVRSDKManager *sdkManager;
@property(strong,nonatomic)HKChannel *selectChannel;

@property(strong,nonatomic)CALayer *placeHolderLayer;

@property(strong,nonatomic)UIView *contentView;
@property(strong,nonatomic)BanBoChannelSelectView *channelSelectView;
@property(strong,nonatomic)BanBoHomeModelView *homeModelView;
@property(strong,nonatomic)UISwitch *switchView;


@property(strong,nonatomic)BanBoLineHeaderView *locationNameView;
@property(strong,nonatomic)UITapGestureRecognizer *locationSelectGesture;
@property(strong,nonatomic)NSMutableArray *hiddenChannelIdArrM;
@end

@implementation BanBoNVRViewController
-(instancetype)initWithProject:(BanBoProject *)project{
    if(self=[super init]){
        self.project=project;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.sdkManager=[NVRSDKManager new];
    NSLog(@"nvr-viewDidLoad");
    self.navigationController.interactivePopGestureRecognizer.enabled=NO;
    self.view.backgroundColor=BanBoViewBgGrayColor;
    YZTitleView *titleView=[YZTitleView banbo_inst];
    [titleView showInNaviItem:self.navigationItem];
    
    [self setupSubviews];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"nvr-viewWillAppear");
    __weak typeof(self) wself=self;
    [HCYUtil toastMsg:@"获取监控信息" inView:self.view];
    [[BanBoNVRManager sharedInstance] getNVRInfoWithProject:self.project.projectId completion:^(id data, NSError *error) {
        if (wself) {
            if (error) {
                [HCYUtil showError:error];
                return ;
            }
            [wself loginDevice:data];
        }
    }];

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.sdkManager clean];
}
#pragma mark subView
-(void)setupSubviews{
    //header
    BanBoLineHeaderView *projectNameView=[self lineViewWithTitle:@"工 地 "];
    
    projectNameView.rightLabel.text=self.project.name;
    [projectNameView.rightLabel sizeToFit];
    projectNameView.frame=CGRectMake(0,64, self.view.height, 40);
    [self.view addSubview:projectNameView];
    
    BanBoLineHeaderView *locationNameView=[self lineViewWithTitle:@"位 置 "];
    locationNameView.frame=CGRectMake(0,projectNameView.bottom, self.view.height, 40);
    [self.view addSubview:locationNameView];
    self.locationNameView=locationNameView;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectLocation:)];
    [locationNameView addGestureRecognizer:tap];
    tap.enabled=NO;
    self.locationSelectGesture=tap;
    
    
    //content
    CGFloat contentViewHeight=floor(550.f/1319.f*self.view.height);
    
    UIView *contentView=[[UIView alloc] initWithFrame:CGRectMake(0, locationNameView.bottom, self.view.width, contentViewHeight)];
    [self.view addSubview:contentView];
    self.contentView=contentView;
    [self.view addSubview:contentView];
    
    CALayer *placeHolderLayer=[CALayer new];
    placeHolderLayer.contents=(__bridge id _Nullable)([UIImage imageNamed:@"jiankongluxiang"].CGImage);
    placeHolderLayer.frame=contentView.bounds;
    [self.contentView.layer addSublayer:placeHolderLayer];
    self.placeHolderLayer=placeHolderLayer;
    
    //control
    CGFloat controlViewHeight=floor(78/550.f*contentViewHeight);
    UIView *controlView=[[UIView alloc] initWithFrame:CGRectMake(0, contentView.bottom, self.view.width, controlViewHeight)];
    controlView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:controlView];
    
    CGFloat controlSubViewOffset=36;
    //control-voice
    UIImageView *voiceImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"voice"]];
    [controlView addSubview:voiceImageView];
    voiceImageView.left=controlSubViewOffset;
    voiceImageView.centerY=controlViewHeight*.5;
    //cotrol-scale
    UIImageView *suofangImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"suofang"]];
    [controlView addSubview:suofangImageView];
    suofangImageView.right=self.view.width-controlSubViewOffset;
    suofangImageView.centerY=controlViewHeight*.5;
    //control-share
    if ([[BanBoUserInfoManager sharedInstance] currentLoginInfo].user.roletype==BanBoUSerTypePM) {
        UISwitch *switchView=[UISwitch new];
        [switchView sizeToFit];
        [switchView addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        self.switchView=switchView;
        
        UILabel *switchTextLabel=[YZLabelFactory blackLabel];
        switchTextLabel.font=[YZLabelFactory bigFont];
        switchTextLabel.text=@"公开显示";
        [switchTextLabel sizeToFit];
        
        CGFloat margin=5;
        UIView *shareView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, switchTextLabel.width+switchView.width+margin+1, controlView.height)];
        
        [shareView addSubview:switchView];
        [shareView addSubview:switchTextLabel];
        
        switchTextLabel.left=switchView.right+margin;
        switchTextLabel.centerY=controlView.height*.5;

        switchView.centerY=controlView.height*.5;
        
        [controlView addSubview:shareView];
        
        shareView.centerX=controlView.width*.5;
        
    }
    
    //separ
    UIView *separView=[[UIView alloc] initWithFrame:CGRectMake(0, controlView.bottom, self.view.width, 4)];
    separView.backgroundColor=[UIColor hcy_colorWithString:@"#e6e6e6"];
    [self.view addSubview:separView];
    
    //tabbar
    BanBoCustomTabbarView *tabbar=[BanBoCustomTabbarView inst];
    tabbar.delegate=self;
    tabbar.top=self.view.height-tabbar.height;
    [self.view addSubview:tabbar];
    
    //locationControl
    UIImageView *imageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yaogan"]];
    imageView.contentMode=UIViewContentModeCenter;
    imageView.frame=CGRectMake(0,separView.bottom, self.view.width, tabbar.top-separView.bottom);
    [self.view addSubview:imageView];
    
    //selectView
    BanBoChannelSelectView *channelSelectView=[BanBoChannelSelectView new];
    [channelSelectView setChannelTop:locationNameView.bottom];
    channelSelectView.delegate=self;
    self.channelSelectView=channelSelectView;
    
    //homeModel
    BanBoHomeModelView *modelView=[BanBoHomeModelView new];
    modelView.actionDelegate=self;
    _homeModelView=modelView;
}
-(BanBoLineHeaderView *)lineViewWithTitle:(NSString *)title{
    BanBoLineHeaderView *lineView=[BanBoLineHeaderView new];
    
    lineView.leftLabel.text=title;
    [lineView.leftLabel sizeToFit];
    lineView.leftLabel.left=15;
    lineView.verSeparLeftToLeftLabel=15;
    lineView.rightLabelLeftToVerSepar=15;
    lineView.verSeparPercent=0.7;
    
    return lineView;
}

#pragma mark channel
-(void)setSelectChannel:(HKChannel *)channel{
    dispatch_async_main_safe(^{
        _selectChannel=channel;
        self.locationNameView.rightLabel.text=channel.name;
        [self.locationNameView.rightLabel sizeToFit];
        self.switchView.on=![self.hiddenChannelIdArrM containsObject:[channel channelNumStr]];
    });
}
-(void)switchValueChanged:(UISwitch *)view{
    HKChannel *channel=self.selectChannel;
    if (!channel) {
        return;
    }
    NSString *channelNumStr=[channel channelNumStr];
    
    if ([self.hiddenChannelIdArrM containsObject:channelNumStr]) {
        [self.hiddenChannelIdArrM removeObject:channelNumStr];
    }else{
        [self.hiddenChannelIdArrM addObject:channelNumStr];
    }
    
    NSString *aNote=[self.hiddenChannelIdArrM componentsJoinedByString:@","];
    //只有一个的情况
    if ([aNote hasPrefix:@","] && aNote.length>1) {
        aNote=[aNote substringFromIndex:1];
    }
    [[BanBoNVRManager sharedInstance] updateHiddenChannels:aNote forProject:self.project.projectId completion:^(id data, NSError *error) {
        
    }];
}

-(NSArray *)checkValidChannels:(NSArray *)channels{
    if ([[BanBoUserInfoManager sharedInstance]  currentLoginInfo].user.roletype==BanBoUSerTypePM) {
        return channels;
    }else{
        NSMutableArray *validChannels=[NSMutableArray array];
        for (HKChannel *channel in channels) {
            if ([self.hiddenChannelIdArrM containsObject:[channel channelNumStr]] ==NO) {
                [validChannels addObject:channel];
            }
        }
        return validChannels;
    }
}

-(void)selectLocation:(UITapGestureRecognizer *)gesture{
    [self.channelSelectView showInView:self.view fromWhere:@"" dur:0.25];
}
-(void)channelSelectView:(BanBoChannelSelectView *)view selectChannel:(HKChannel *)channel{
    [view dismiss];
    [self playChannel:channel];
    
}
-(void)playChannel:(HKChannel *)channel{
    __weak typeof(self) wself=self;
    [wself setSelectChannel:channel];
    [HCYUtil showProgressWithStr:@"正在读取视频"];
    [self.sdkManager playChanel:channel onView:wself.contentView completion:^(NSError *error) {
        dispatch_async_main_safe(^{
            [HCYUtil dismissProgress];
            if (error) {
                [HCYUtil showError:error];
                wself.placeHolderLayer.hidden=YES;
            }else{
                self.placeHolderLayer.hidden=NO;
            }
        });
    }];
}
#pragma mark login
-(void)loginDevice:(BanBoNVRInfo *)nvrInfo{
    if (!nvrInfo.remoteAddress.ipaddr) {
        return;
    }
    NSArray *arr=[nvrInfo.note componentsSeparatedByString:@","];
    self.hiddenChannelIdArrM=[arr mutableCopy];
    
    HKLoginInfo *info=[HKLoginInfo new];
    
    info.remoteUrl=[NSString stringWithUTF8String:nvrInfo.remoteAddress.ipaddr];
    info.port= nvrInfo.remoteAddress.port;
    info.userName= @"admin";
    info.pwd= @"banbo601";
    [HCYUtil showProgressWithStr:@"连接中..."];
    __weak typeof(self) wself=self;
    [self.sdkManager loginDeviceWithInfo:info completion:^(NSArray *channels, NSError *error) {
        [HCYUtil dismissProgress];
        if (error) {
            [HCYUtil showError:error];
            return;
        }
        dispatch_async_main_safe(^{
            NSArray *vaildChannels=[wself checkValidChannels:channels];
            if (vaildChannels.count) {
                wself.hkChannels=vaildChannels;
                [wself.channelSelectView  setChannels:vaildChannels];
                if (channels.count) {
                    wself.locationSelectGesture.enabled=YES;
                    HKChannel *channel=vaildChannels[0];
                    [wself playChannel:channel];
                }
            }
        });
        
    }];
}
#pragma mark tabbarDelegate 其实用个tabController是最好的。。可是。。懒了
-(void)customBar:(BanBoCustomTabbarView *)tabbar toReport:(UIButton *)btn{
    BanBoReportListViewController *list=[[BanBoReportListViewController alloc] initWithProject:self.project];
    [self gotoViewController:list];//高127 低77 脉搏63
}

-(void)customBar:(BanBoCustomTabbarView *)tabbar toAddBtn:(UIButton *)btn{
    [self.homeModelView showInView:self.view];
}
#pragma mark homeModelViewActions
-(void)toShimin:(UIButton *)btn{
    BanBoShiminViewController *vc=[[BanBoShiminViewController alloc] initWithProject:self.project];
    [self gotoViewController:vc];
}

#pragma mark common
-(void)gotoViewController:(UIViewController *)vc{
    UINavigationController *navi=self.navigationController;
  
    [navi popToRootViewControllerAnimated:NO];
    [navi pushViewController:vc animated:NO];
}
-(void)dealloc{
    DDLogInfo(@"BanboNVRViewController-dealloc");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
