//
//  BanBoCardiogramCollectViewController.m
//  kq_banbo_app
//
//  Created by hcy on 2016/12/9.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoCardiogramCollectViewController.h"
#import "BanBoCardiogramInfoView.h"
#import "BanBoHealthFourBtnView.h"
#import "BanBoCommonInterManager.h"
#import "BloodPressureLayer.h"
#import "BaseBlueTooth.h"
#import "CRCreativeSDK.h"
#import "CRPc80b.h"
#import "BanBoHealthResultView.h"
@interface BanBoCardiogramCollectViewController ()<BanBoHealthFourBtnsViewDelegate,CreativeDelegate,CRPc80bDelegate>


@property(strong,nonatomic)BanBoCardiogramInfoView *infoView;
@property(strong,nonatomic)CreativePeripheral *peripheral;
@property(strong,nonatomic)NSArray *stringArr;

@property(strong,nonatomic)BloodPressureLayer *bpLayer;

@property(strong,nonatomic)UILabel *resultLabel;

@property(copy,nonatomic)NSString *resultStr;
@property(assign,nonatomic)NSInteger hr;
@end

@implementation BanBoCardiogramCollectViewController
#define deviceName @"PC80B"
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isViewMode) {
        [super healthSetTitle:[NSString stringWithFormat:@"%@-心电测量数据",self.user.UserName]];
    }else{
        [super healthSetTitle:@"心电图测量"];
    }
    
    [self setupSubviews];
    [CRCreativeSDK sharedInstance].delegate = self;
    [CRPc80b sharedInstance].delegate = self;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[CRCreativeSDK sharedInstance] closePort:self.peripheral];
}
-(void)setupSubviews{
    BanBoCardiogramInfoView *infoView=[[BanBoCardiogramInfoView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height*.2)];
    [self.healthContentView addSubview:infoView];
    self.infoView=infoView;
    
    
    if (self.isViewMode) {
        infoView.viewMode=self.isViewMode;
        infoView.cardiogram=self.user.HeartRate;
    }
    
    UIImageView *imageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"心电图测量"]];
    imageView.width=self.view.width;
    imageView.height=self.view.height*.35;
    imageView.top=infoView.bottom;
    [self.healthContentView addSubview:imageView];

    if(self.isViewMode){
        BanBoHealthResultView *resultView=[BanBoHealthResultView new];
        
        resultView.top=imageView.bottom+10;
        resultView.left=0;
        resultView.width=self.healthContentView.width;
        resultView.height=80;
        [resultView setResultImage:[UIImage imageNamed:@"心电图标"]];
        
        [resultView setResultText:self.user.HeartRateCon];
        
        [self.healthContentView addSubview:resultView];
    }else{
        //layer-画线用
        BloodPressureLayer *bpLayer=[BloodPressureLayer new];
        
        CGFloat layerHeight=imageView.bounds.size.height;
        CGFloat layerTop=imageView.top;
        
        bpLayer.frame=CGRectMake(0,layerTop, self.view.width, layerHeight);
        
        [self.healthContentView.layer addSublayer:bpLayer];
        self.bpLayer=bpLayer;
        //resultLabel
        UILabel *resultLabel=[YZLabelFactory blackLabel];
        resultLabel.textColor=[UIColor whiteColor];
        [self.healthContentView addSubview:resultLabel];
        self.resultLabel=resultLabel;
        resultLabel.center=imageView.center;
        //btns
        BanBoHealthFourBtnView *btnView=[BanBoHealthFourBtnView new];
        
        CGFloat btnLineMargin=10;
        CGFloat btnMargin=20;
        CGFloat btnHeigt=40;
        CGFloat btnWidth=130;
        
        CGFloat btnViewWidth=btnWidth*2+btnMargin;
        CGFloat btnViewHeight=btnHeigt*2+btnLineMargin;
        
        btnView.delegate=self;
        [btnView setBackgroundColor:[UIColor clearColor]];
        btnView.itemMargin=btnMargin;
        btnView.lineMargin=btnLineMargin;
        [btnView setBtnViewSize:CGSizeMake(btnViewWidth, btnViewHeight)];
        [btnView setTitles:@[@"重测",@"连接",@"取消",@"保存"]];
        [btnView setBgColorArr:@[BanBoBlueColor,[UIColor hcy_colorWithString:@"#fbca03"],BanBoHealthBtnGrayColor,BanBoHealthRedColor]];
        [btnView setTitleColors:@[[UIColor whiteColor],[UIColor whiteColor],BanBoHealthCancelBtnTitleColor,[UIColor whiteColor]] forState:UIControlStateNormal];
        
        btnView.centerY=(imageView.bottom+(self.healthContentView.height-imageView.bottom)*.5);
        btnView.centerX=self.view.width*.5;
        
        [self.healthContentView addSubview:btnView];
    }
   
}


#pragma mark 
-(void)fourBtnView:(BanBoHealthFourBtnView *)btnView clickBtnAtIdx:(NSInteger)btnIdx{

    switch (btnIdx) {
        case 0:
        {
            if(self.peripheral==nil){
                [HCYUtil toastMsg:@"请先连接设备" inView:self.view];
            }else{
                [HCYUtil toastMsg:@"请在设备上开始测量" inView:self.view];
            }
        }
            break;
        case 1:
        {
            [self scan];
        }
            break;
        case 2:
        {
            [self cancel];
        }
            break;
        case 3:
        {
            [self save];
        }
            break;
        default:
            break;
    }

}

#pragma mark scan

-(void)scan{
    if (self.peripheral) {
        return;
    }
    [HCYUtil showProgressWithStr:@"连接中"];
    [[CRCreativeSDK sharedInstance] startScan:10.f];
    
}
-(void)OnSearchCompleted:(CRCreativeSDK *)bleSerialComManager{
    [HCYUtil dismissProgress];
    if (self.peripheral) {
        [[CRCreativeSDK sharedInstance] connectDevice:self.peripheral];
    }else{
        [HCYUtil showError:[BaseBlueTooth noAuthError]];
    }
}
-(void)crManager:(CRCreativeSDK *)crManager OnFindDevice:(CreativePeripheral *)port
{
    DDLogDebug(@"port.advName = %@",port.advName);
    if ([port.advName isEqualToString:deviceName]) {
        self.peripheral=port;
        BanboBlueToothInfo *info=[BanboBlueToothInfo new];
        info.name=port.advName;
        info.identifier=self.peripheral.peripheral.identifier.UUIDString;
       // NSLog(@"lanya:%@",self.peripheral.peripheral.identifier);
//      NSLog(@"lanyaudid:%@",self.peripheral.peripheral.identifier.UUIDString);//861867C3-06FC-4A23-9B6B-9AA66A50B716 897A83F4-022B-46E2-B416-8EFFF925EA7B
//        __weak typeof(self) wself=self;
//        
//        [[BanBoCommonInterManager sharedInstance] checkBlueToothWithInfo:info completion:^(id data, NSError *error) {
//            if (error) {
//                wself.peripheral=nil;
//            }
//            [[CRCreativeSDK sharedInstance] searchPortsTimeout];
//        }];
    }
    else
    {
        [[CRCreativeSDK sharedInstance] searchPortsTimeout];
    }
}
#pragma mark 测量
-(void)crManager:(CRCreativeSDK *)crManager OnConnected:(CreativePeripheral *)peripheral withResult:(resultCodeType)result CurrentCharacteristic:(CBCharacteristic *)theCurrentCharacteristic{
    
    NSString *connectString =nil;
    if (result == RESULT_SUCCESS)
    {
        connectString = @"已经连接";
        
        [CRPc80b sharedInstance].peri = peripheral;
        [[CRPc80b sharedInstance] restartTimer];
    }
    else
    {
        connectString = @"连接失败";
        
    }
    [self showAlert:connectString];
}
-(void)addStringData:(NSString *)dataStr{
    if([dataStr integerValue]){
#ifndef HCYCGV2
        CGFloat height=self.bpLayer.bounds.size.height;
        CGFloat zoomY=height/6/416;
        NSInteger valF=[dataStr integerValue];
        NSLog(@"startVal:%@,valI:%ld",dataStr,valF);
        valF-=2048;
        valF*=2;
        CGFloat y=height*.5- zoomY*(valF*2);
        NSLog(@"y:%f",y);
        [self.bpLayer insertY:y];
#else
        [self.bpLayer insertY:[dataStr integerValue]];
#endif
        [self.bpLayer setNeedsDisplay];
    }
}
-(void)pc80B:(CRPc80b *)pc80B OnGetECGRealTimePrepare:(struct ecgWave)wave andGain:(int)nGain lead:(BOOL)bLeadOff
{
    DDLogDebug(@"frameNum:%d",wave.frameNum);
    NSString *myString = [NSString string];
    for (int i = 0; i<5; i++) {
        myString = [myString stringByAppendingString:[NSString stringWithFormat:@"%d,",wave.wave[i].nWave]];
    }
    DDLogDebug(@"myString1:%@",myString);
    [self addStringData:myString];
    
    myString = [NSString string];
    for (int i = 5; i<10; i++) {
        myString = [myString stringByAppendingString:[NSString stringWithFormat:@"%d,",wave.wave[i].nWave]];
    }
    DDLogDebug(@"myString2:%@",myString);
    [self addStringData:myString];
    
    myString = [NSString string];
    for (int i = 10; i<15; i++) {
        myString = [myString stringByAppendingString:[NSString stringWithFormat:@"%d,",wave.wave[i].nWave]];
    }
    DDLogDebug(@"myString3:%@",myString);
    [self addStringData:myString];
    
    myString = [NSString string];
    for (int i = 15; i<20; i++) {
        myString = [myString stringByAppendingString:[NSString stringWithFormat:@"%d,",wave.wave[i].nWave]];
    }
    DDLogDebug(@"myString4:%@",myString);
    [self addStringData:myString];
    
    myString = [NSString string];
    for (int i = 20; i<25; i++) {
        myString = [myString stringByAppendingString:[NSString stringWithFormat:@"%d,",wave.wave[i].nWave]];
    }
    DDLogDebug(@"myString5:%@",myString);
    [self addStringData:myString];
}
-(void)pc80B:(CRPc80b *)pc80B OnGetECGRealTimeMeasure:(struct ecgWave)wave andGain:(int)nGain lead:(BOOL)bLeadOff andMode:(int)nTransMode
{
    DDLogDebug(@"f2:%d",wave.frameNum);
    self.bpLayer.gain=nGain;
    
    NSString *myString = [NSString string];
    for (int i = 0; i<5; i++) {
        myString = [myString stringByAppendingString:[NSString stringWithFormat:@"%d,",wave.wave[i].nWave]];
    }
    DDLogDebug(@"2-myString1:%@",myString);
    [self addStringData:myString];
    
    myString = [NSString string];
    for (int i = 10; i<15; i++) {
        myString = [myString stringByAppendingString:[NSString stringWithFormat:@"%d,",wave.wave[i].nWave]];
    }
    DDLogDebug(@"2-myString2:%@",myString);
    [self addStringData:myString];
    
    myString = [NSString string];
    for (int i = 15; i<20; i++) {
        myString = [myString stringByAppendingString:[NSString stringWithFormat:@"%d,",wave.wave[i].nWave]];
    }
    DDLogDebug(@"2-myString3:%@",myString);
    [self addStringData:myString];
    
    myString = [NSString string];
    for (int i = 20; i<25; i++) {
        myString = [myString stringByAppendingString:[NSString stringWithFormat:@"%d,",wave.wave[i].nWave]];
    }
    DDLogDebug(@"2-myString4:%@",myString);
    [self addStringData:myString];
    
    myString = [NSString string];
    for (int i = 5; i<10; i++) {
        myString = [myString stringByAppendingString:[NSString stringWithFormat:@"%d,",wave.wave[i].nWave]];
    }
    DDLogDebug(@"2-myString5:%@",myString);
    [self addStringData:myString];
}
-(void)crManager:(CRCreativeSDK *)crManager OnConnectFail:(CBPeripheral *)port
{
    self.peripheral=nil;
    [self showAlert:@"连接已断开"];
}
-(void)pc80B:(CRPc80b *)pc80B OnGetRealTimeResult:(int)nHR andResult:(int)nResult
{
    NSString *resultStr=self.stringArr[nResult];
    CGPoint p=self.resultLabel.center;
    
    [self.infoView setCardiogram:[NSString stringWithFormat:@"%d",nHR]];
    self.resultLabel.text=resultStr;
    [self.resultLabel sizeToFit];
    self.resultLabel.center=p;
    [self.bpLayer clean];
    self.hr=nHR;
    self.resultStr=resultStr;
    DDLogInfo(@"hr:%zd",self.hr);
    DDLogInfo(@"heart结果:%@",self.resultStr);
}
-(void)stopMeasure:(CRPc80b *)pc80B
{
    [self showAlert:@"测量停止"];
}


#pragma mark 取消&保存
-(void)cancel{
    if (self.completion) {
        self.completion(nil,nil,YES);
    }
}
-(void)save{
    if (self.resultStr.length && self.hr) {
        __weak typeof(self) wself=self;
        [HCYUtil showProgressWithStr:@"保存中"];
        [[BanBoHealthManager sharedInstance] addCardiorgramWithHR:@(self.hr) result:self.resultStr forUser:self.user.UserId inProject:self.project.projectId completion:^(id data, NSError *error) {
            if (!wself) {
                return ;
            }
            dispatch_async_main_safe(^{
                [HCYUtil dismissProgress];
                if (error) {
                    [HCYUtil showError:error];
                    return ;
                }
                [HCYUtil toastMsg:@"保存成功" inView:wself.view];
                if(wself.completion){
                    wself.completion(data,error,NO);
                }
            
                [wself.navigationController popViewControllerAnimated:YES];
            });
        }];
    }else{
        [HCYUtil toastMsg:@"请先测量" inView:self.view];
    }
}
#pragma mark other
-(void)showAlert:(NSString *)message
{
    [HCYUtil toastMsg:message inView:self.view];
}

-(NSArray *)stringArr{
    if (!_stringArr) {
      _stringArr=@[@"波形未见异常",
        @"波形疑似心跳稍快,请注意休息",
        @"波形疑似心跳过快,请注意休息",
        @"波形疑似阵发性心跳过快,请咨询医生",
        @"波形疑似心跳稍缓,请注意休息",
        @"波形疑似心跳过缓,请注意休息",
        @"波形疑似偶发心跳间期缩短,请咨询医生",
        @"波形疑似心跳间期不规则,请咨询医生",
        @"波形疑似心跳稍快伴有偶发心跳间期缩短,请咨询医生",
        @"波形疑似心跳稍缓伴有偶发心跳间期缩短,请咨询医生",
        @"波形疑似心跳稍缓伴有心跳间期不规则,请咨询医生",
        @"波形有漂移,请重新测量",
        @"波形疑似心跳过快伴有波形漂移,请咨询医生",
        @"波形疑似心跳过缓伴有波形漂移,请咨询医生",
        @"波形疑似偶发心跳间期缩短伴有波形漂移,请咨询医生",
        @"波形疑似心跳间期不规则伴有波形漂移,请咨询医生",
        @"信号较差请重新测量",
                   @"分析结果出现错误"];
    }
    return _stringArr;
}



@end
