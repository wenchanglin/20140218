//
//  BanBoNewReportViewController.m
//  kq_banbo_app
//
//  Created by hcy on 2016/12/14.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoNewReportViewController.h"
#import "BanBoProject.h"
#import "BanBoNewReportView.h"
#import "YZTitleView+BanBo.h"
#import "BanBoImageHeaderView.h"
#import "BanBoLineHeaderView.h"
#import "IDCardBlueTooth.h"
#import "BanBoProjectManager.h"
@interface BanBoNewReportViewController ()<HCYBlueToothDelegate>
@property(strong,nonatomic)BanBoProject *project;

@property(strong,nonatomic)BanBoNewReportView *reportView;
@property(strong,nonatomic)UILabel *idCardLabel;
@property(strong,nonatomic)UILabel *addressLabel;

@property(strong,nonatomic)IDCardBlueTooth *blueTooth;
@property(strong,nonatomic)IDCardInfo *info;
@property(assign,nonatomic)BOOL needReadData;
@property(strong,nonatomic)NSDictionary *numParam;
@end

@implementation BanBoNewReportViewController
-(instancetype)initWithProject:(BanBoProject *)project{
    if (self=[super init]) {
        self.project=project;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=BanBoViewBgGrayColor;
    YZTitleView *titleView=[YZTitleView banbo_inst];
    [titleView showInNaviItem:self.navigationItem];
    self.blueTooth.delegate=self;
    [self setupSubviews];
    [self getData];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.blueTooth stopScan];
//    [HCYUtil dismissProgress];
}

#pragma mark subviews
-(void)setupSubviews{
    BanBoImageHeaderView *header=[BanBoImageHeaderView new];
    header.top=64;
    header.text=[NSString stringWithFormat:@"%@录入信息",self.project.name];
    [self.view addSubview:header];
    
    BanBoNewReportView *reportTopView=[[BanBoNewReportView alloc] initWithFrame:CGRectMake(0, header.bottom, self.view.width, 1000)];
    reportTopView.contentView=self.view;
    [self.view addSubview:reportTopView];
    self.reportView=reportTopView;
    
    BanBoLineHeaderView *idCardView=[self lineViewWithTitle:@"身份证号码"];
    idCardView.frame=CGRectMake(0, reportTopView.bottom+10, self.view.height, 40);
    [self.view addSubview:idCardView];
    self.idCardLabel=idCardView.rightLabel;
    
    BanBoLineHeaderView *addressView= [self lineViewWithTitle:@"现家庭住址"];
    addressView.frame=CGRectMake(0, idCardView.bottom, self.view.width, idCardView.height*1.5);
    [self.view addSubview:addressView];
    self.addressLabel=addressView.rightLabel;
    self.addressLabel.numberOfLines=2;
    
    CGFloat leftHeight=self.view.height-addressView.bottom;
     //2-btnH-1-btnH-1-btnH-2 btnH=4sep
    CGFloat separ=leftHeight/18;
    CGFloat btnHeight=separ*4;
    UIButton *connectBtn=[self btnWithTitle:@"设备重连" bgColor:[UIColor hcy_colorWithString:@"#99ccfe"]];
    connectBtn.height=btnHeight;
    connectBtn.top=addressView.bottom+separ*2;
    [connectBtn addTarget:self action:@selector(connectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:connectBtn];
    
    UIButton *readBtn=[self btnWithTitle:@"主动读卡" bgColor:[UIColor hcy_colorWithString:@"#f9e196"]];
    readBtn.height=btnHeight;
    readBtn.top=connectBtn.bottom+separ;
    [readBtn addTarget:self action:@selector(readBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:readBtn];

    UIButton *saveBtn=[self btnWithTitle:@"保  存" bgColor:[UIColor hcy_colorWithString:@"#13b8f5"]];
    saveBtn.height=btnHeight;
    saveBtn.top=readBtn.bottom+separ;
    [saveBtn addTarget:self action:@selector(saveBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    
}
#pragma mark - data
-(void)getData{
    self.reportView.numView.userInteractionEnabled=NO;
    __weak typeof(self)wself=self;
    [[BanBoProjectManager sharedInstance] getValidCardNumForProject:self.project.projectId completion:^(id data, NSError *error) {
        if (!wself) {
            return ;
        }
        dispatch_async_main_safe(^{
            if (error) {
                [HCYUtil showError:error];
            }else{
                wself.numParam=data;
                NSNumber *num=data[@"workno"];
                wself.reportView.numView.currentNumber=[num integerValue];
            }
            wself.reportView.numView.userInteractionEnabled=YES;//就算出错了。可以手输
        });
    }];
    
}

#pragma mark btnEvents
-(void)connectBtnClicked:(UIButton *)btn{
    if (self.blueTooth.peripheral!=nil) {
        DDLogDebug(@"已经连接");
        [HCYUtil toastMsg:@"已经连接" inView:self.view];
    }else{
        [HCYUtil showProgressWithStr:@"连接中"];
        [self.blueTooth connectPeripheral];
        self.needReadData=NO;
    }
}
-(void)readBtnClicked:(UIButton *)btn{
    if (self.blueTooth.peripheral!=nil) {
        [HCYUtil showProgressWithStr:@"读卡中"];
        [self.blueTooth readData];
    }else{
        [self connectBtnClicked:nil];
        self.needReadData=YES;
    }
}
-(void)saveBtnClicked:(UIButton *)btn{
    if ([self checkCondition]) {
        [HCYUtil showProgressWithStr:@"正在上传图片"];
        __weak typeof(self) wself=self;
        [[BanBoProjectManager sharedInstance] uploadImage:self.reportView.iconView.image forPicKey:self.idCardLabel.text forProject:self.project.projectId progress:nil completion:^(id data, NSError *error) {
            if (!wself) {
                return ;
            }
            dispatch_async_main_safe(^{
                [HCYUtil dismissProgress];
                if (error) {
                    [HCYUtil showError:error];
                }else{
                    [wself saveReport:data];
                }
            });
        }];
        
    }else{
        
    }
}
-(void)saveReport:(NSString *)fileUrl{
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    [param addEntriesFromDictionary:self.info.param];
    [param setObject:@(self.reportView.groupId) forKey:@"GroupId"];
    [param setObject:@(self.reportView.subGroupId) forKey:@"SubGroupId"];
    [param setObject:fileUrl forKey:@"FilePath"];
    [param setObject:self.numParam[@"cid"] forKey:@"Cid"];
    [param setObject:self.numParam[@"cardno"] forKey:@"CurrCardNo"];
    [param setObject:@(self.reportView.numView.currentNumber) forKey:@"CurrWorkNo"];
    
    [[BanBoProjectManager sharedInstance] saveReport:param forProject:self.project.projectId completion:^(id data, NSError *error) {
        [HCYUtil toastMsg:@"保存成功" inView:self.view];
        [HCYUtil dismissProgress];
        if (error) {
            //[HCYUtil showError:error];
            return ;
        }
    }];
}
#pragma mark - blueToothDelegate
-(void)bluetooth:(BaseBlueTooth *)blueTooth changeState:(CBCentralManagerState)state{
    if (state==CBManagerStatePoweredOn) {
        [self readBtnClicked:nil];
    }
}

-(void)bluetooth:(BaseBlueTooth *)blueTooth commondResult:(IDCardInfo *)data error:(NSError *)error{
    [HCYUtil dismissProgress];
    if (error) {
        [HCYUtil showError:error];
    }else{
        self.info=data;
        NSLog(@"读取卡数据:%@---->%@",data,data.id_num);
        //DDLogInfo(@"读取卡数据:%@",data);
        [self.reportView refreshWithData:data];
        self.idCardLabel.text=data.id_num;
        [self.idCardLabel sizeToFit];
        self.addressLabel.text=data.address;
        [self.addressLabel sizeToFit];
    }
}
-(void)bluetooth:(BaseBlueTooth *)blueTooth connectPeripheralWithError:(NSError *)error{
    [HCYUtil dismissProgress];
    [HCYUtil toastMsg:@"已经连接" inView:self.view];
    if(_needReadData&& error==nil){
        [self readBtnClicked:nil];
    }
    if (error) {
        [HCYUtil showError:error];
        DDLogError(@"error:%@",error);
    }
}
-(void)bluetooth:(BaseBlueTooth *)blueTooth lostConnectWithError:(NSError *)error{
    [HCYUtil dismissProgress];
    [HCYUtil showError:error];
}

#pragma mark - 检查错误
-(BOOL)checkCondition{
    if (self.reportView.groupId<=0) {
        [HCYUtil toastMsg:@"请选择班组" inView:self.view];
        return NO;
    }
    if (self.reportView.subGroupId<=0) {
        [HCYUtil toastMsg:@"请选择小班组" inView:self.view];
        return NO;
    }
    if (self.info==nil) {
        [HCYUtil toastMsg:@"请先读卡" inView:self.view];
        return NO;
    }
    if (self.numParam==nil) {
        [HCYUtil toastMsg:@"卡号获取错误,请退出重进" inView:self.view];
        return NO;
    }
    if ([self.reportView haveImage]==NO) {
        [HCYUtil toastMsg:@"请点击头像拍照" inView:self.view];
        return NO;
    }
    return YES;
}

-(IDCardBlueTooth *)blueTooth{
    if (!_blueTooth) {
        _blueTooth=[IDCardBlueTooth new];
    }
    return _blueTooth;
}
-(UIButton *)btnWithTitle:(NSString *)title bgColor:(UIColor *)bgColor{
    UIButton *btn=[UIButton new];
    
    btn.adjustsImageWhenHighlighted=NO;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:bgColor];
    btn.width=self.view.width*.7;
    btn.centerX=self.view.width*.5;
    
    return btn;
}
-(BanBoLineHeaderView *)lineViewWithTitle:(NSString *)title{
    BanBoLineHeaderView *idCardView=[BanBoLineHeaderView new];
    idCardView.leftLabel.text=title;
    [idCardView.leftLabel sizeToFit];
    idCardView.leftLabel.left=15;
    idCardView.verSeparPercent=0;
    
    return idCardView;
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
