//
//  BanBoBloodPressureCollectViewController.m
//  kq_banbo_app
//
//  Created by hcy on 2016/12/9.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoBloodPressureCollectViewController.h"
#import "BanBoBloodPressureView.h"
#import "BanBoHealthFourBtnView.h"
#import "HCYMutableBtnView.h"
#import "BloodPressureBlueTooth.h"
#import "BanBoHealthManager.h"
#import "BanBoHealthResultView.h"
@interface BanBoBloodPressureCollectViewController ()<HCYMutableBtnViewDelegate,HCYBlueToothDelegate>
@property(strong,nonatomic)BloodPressureBlueTooth *bluetooth;
@property(strong,nonatomic)BanBoBloodPressureView *pressureView;
@property(strong,nonatomic)BloodPressureInfo *pressureInfo;
@property(strong,nonatomic)BanBoHealthResultView *resultView;
@end

@implementation BanBoBloodPressureCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super healthSetTitle:@"血压测量"];
    
    [self setupSubviews];
    
}
-(void)setupSubviews{
    BanBoBloodPressureView *pressureView=[[BanBoBloodPressureView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height*.4)];
    pressureView.userName=self.user.UserName;
    if(self.isViewMode){
        //本地就有，就用本地的，不用服务器的
        pressureView.highPressure=[self.user.BloodMax intValue];
        pressureView.lowPressure=[self.user.BloodMin intValue];
        pressureView.pluseFreq=[self.user.PulseRate intValue];
        NSTimeInterval heartDateInterVal=[self.user.BloodDate doubleValue]/1000;
        NSDate *date=[NSDate dateWithTimeIntervalSince1970:heartDateInterVal];
        if (date) {
             NSString* result=[HCYUtil dateStrFromDate:date dateFormat:@"YYYY-MM-dd"];
            pressureView.updateStrLabel.text=result;
        }
    }else{
        pressureView.updateStrLabel.hidden=YES;
    }
    
    [self.healthContentView addSubview:pressureView];
    self.pressureView=pressureView;
    //text
    CGFloat textLeft=0;
    UITextView *textView=[[UITextView alloc] init];
    textView.font=[YZLabelFactory normalFont];
    textView.textColor=[UIColor hcy_colorWithString:@"#999999"];
    textView.text=@"根据世界卫生组织的标准,成年人的正常血压90/60|139/89(单位:mmhg)理想血压小于120/80,达到或超过140/90为高血压,130/85为高正常血压或临界高血压。";
    textView.userInteractionEnabled=NO;
    CGFloat textViewWidth=self.healthContentView.width-textLeft*2;
    CGSize textViewSize= [textView sizeThatFits:CGSizeMake(textViewWidth, self.view.height)];
    textView.top=pressureView.bottom;
    textView.left=textLeft;
    textView.size=textViewSize;
    textView.width=self.healthContentView.width;

    [self.healthContentView addSubview:textView];
    if (self.isViewMode) {
        BanBoHealthResultView *resultView=[BanBoHealthResultView new];
        [resultView setResultImage:[UIImage imageNamed:@"血压测量图标"]];
    
        resultView.height=160;
        resultView.width=self.view.width;
        resultView.top=textView.bottom+10;
        
        [self.healthContentView addSubview:resultView];
        
        self.resultView=resultView;
        [resultView beginAnimation];
        __weak typeof(self) wself=self;
        [[BanBoHealthManager sharedInstance] getBloodPressure4User:self.user inProject:self.project.projectId completion:^(BloodPressureInfo* data, NSError *error) {
            if (!wself) {
                return ;
            }
            dispatch_async_main_safe(^{
                if (!error) {
                    [wself.resultView stopAnimation];
                    [wself.resultView setResultText:data.info];
                }
            });
        }];
    }else{
        
        CGFloat btnViewTop=textView.bottom+15;
        
        CGFloat btnLineMargin=20;
        CGFloat btnMargin=20;
        CGFloat btnHeigt=40;
        CGFloat btnWidth=260;

        CGFloat btnViewWidth=btnWidth;
        CGFloat btnViewHeight=btnHeigt*2+btnLineMargin;
        
        btnViewWidth=260;
        
        HCYTableBtnView *btnView=[HCYTableBtnView new];
        
        btnView.delegate=self;
        btnView.columnCount=1;
        btnView.rowCount=2;
        btnView.itemMargin=btnMargin;
        btnView.lineMargin=btnLineMargin;
        
        btnView.bounds=CGRectMake(0, 0, btnViewWidth, btnViewHeight);
        
        [btnView addBtn:[self btnWithTitle:@"连 接" bgColor:[UIColor grayColor] titleColor:[UIColor whiteColor]]];
        [btnView addBtn:[self btnWithTitle:@"保 存" bgColor:BanBoHealthRedColor titleColor:[UIColor whiteColor]]];
        
        [btnView reLayoutBtns];
        
        
        CGFloat leftHeight=(self.healthContentView.height-textView.bottom);
        btnViewTop=textView.bottom+(leftHeight-btnViewHeight)*.4;
        
        btnView.top=btnViewTop;
        btnView.centerX=self.view.width*.5;
        
        [self.healthContentView addSubview:btnView];
    }
}

-(HCYMutableBtn *)btnWithTitle:(NSString *)title bgColor:(UIColor *)bgColor titleColor:(UIColor *)titleColor{
    
    UIButton *btn=[UIButton new];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundColor:bgColor];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    
    return [HCYMutableBtn mutBtnWithBtn:btn];
}

#pragma mark btnViewDelegate
-(void)btnView:(HCYMutableBtnView *)btnView clickBtnAtIdx:(NSInteger)idx{
    if (idx==0) {
        //连接
        if (!_bluetooth) {
            BloodPressureBlueTooth *blueTooth=[BloodPressureBlueTooth new];
            blueTooth.delegate=self;
            _bluetooth=blueTooth;
        }else{
            if ([self.bluetooth canScan]) {
                [self connect];
            }
            
        }
    }else{
        //保存
        [self save];
    }
}
#pragma mark events
-(void)connect{
   [HCYUtil showProgressWithStr:@"连接中"];
    [self.bluetooth connectPeripheral];
}
-(void)back{
    if (self.completion) {
        self.completion(nil,nil,YES);
    }
}
-(void)save{
    if (self.pressureInfo==nil) {
        [HCYUtil toastMsg:@"请先测量" inView:self.view];
        return;
    }
    [HCYUtil showProgressWithStr:@"保存中"];
    __weak typeof(self) wself=self;
    NSLog(@"高压:%zd-低压:%zd-脉搏:%zd",self.pressureInfo.highPressure,self.pressureInfo.lowPressure,self.pressureInfo.pluseRate);
    [[BanBoHealthManager sharedInstance] addBloodPressure:self.pressureInfo forProject:self.project.projectId user:@(self.user.UserId) completion:^(id data, NSError *error) {
        if (!wself) {
            return ;
        }
        dispatch_async_main_safe(^{
            [HCYUtil dismissProgress];
            if (error) {
                [HCYUtil showError:error];
                return;
            }
            [HCYUtil toastMsg:@"保存成功" inView:wself.view];
            if (wself.completion) {
                wself.completion(nil,nil,NO);
            }
            [wself.navigationController popViewControllerAnimated:YES];
        });
    }];
}

#pragma mark bluetoothDelegate
-(void)bluetooth:(BaseBlueTooth *)blueTooth changeState:(CBCentralManagerState)state{
    if (state==CBManagerStatePoweredOn) {
        [self connect];
    }else if(state!=CBManagerStateUnknown){
        [HCYUtil dismissProgress];
        DDLogDebug(@"state:%ld",(long)state);
        [HCYUtil toastMsg:@"连接出错请确认蓝牙状态" inView:self.view];
    }
}
-(void)bluetooth:(BaseBlueTooth *)blueTooth connectPeripheralWithError:(NSError *)error{
    [HCYUtil dismissProgress];
    if (error) {
        [HCYUtil showError:error];
    }else{
        self.pressureView.signIcon.hidden=NO;
        [HCYUtil toastMsg:@"已经连接" inView:self.view];
        [blueTooth readData];
    }
}
-(void)bluetooth:(BaseBlueTooth *)blueTooth commondResult:(BloodPressureInfo *)data error:(NSError *)error{
    [HCYUtil dismissProgress];
    self.pressureInfo=nil;
    if (error) {
        [HCYUtil showError:error];
    }else{
        self.pressureView.highPressure=data.highPressure;
        self.pressureView.lowPressure=data.lowPressure;
        self.pressureView.pluseFreq=data.pluseRate;
        self.pressureInfo=data;
    }
}
-(void)bluetooth:(BaseBlueTooth *)blueTooth noticeCustomStateChange:(NSDictionary *)changeDict{
    BloodPressureState state=[changeDict[BloodPressureKeyState] integerValue];
    if (state==BloodPressureStateMeasuring) {
        [HCYUtil showProgressWithStr:@"测量中"];
    }
    if(state==BloodPressureStateMeasured){
        [HCYUtil dismissProgress];
        [HCYUtil toastMsg:@"测量结束" inView:self.view];
    }
}
-(void)bluetooth:(BaseBlueTooth *)blueTooth lostConnectWithError:(NSError *)error{
    self.pressureView.signIcon.hidden=YES;
    [HCYUtil dismissProgress];
    [HCYUtil toastMsg:@"蓝牙连接已断开" inView:self.view];
}
-(void)dealloc{
    [self.bluetooth releasePeripheral];
}
@end
