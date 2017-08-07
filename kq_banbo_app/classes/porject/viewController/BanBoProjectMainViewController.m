//
//  BanBoProjectMainViewController.m
//  kq_banbo_app
//
//  Created by hcy on 2016/11/30.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoProjectMainViewController.h"
#import <Masonry.h>
#import "BanBoReportListViewController.h"
#import "BanBoShiminViewController.h"
//#import "BanBoNVRViewController.h"
#import "BanBoHomeManager.h"
#import "BanBoUserInfoManager.h"
#import "YZTitleView+BanBo.h"
#import "BanBoProjectCell.h"
#import "YZColorTextLabel.h"
#import "BanBoCustomTabbarView.h"
#import "BanBoShiMinManager.h"
#import "BanBoProject.h"
#import "EZDeviceTableViewController.h" //萤石
#import "BanBoSuSheGuanLiViewController.h"
#import "HyPopMenuView.h"
#import "BanBoHJJKManager.h"
#import "BanBoHuanJModel.h"
#import "BanBoHJJKongViewController.h"
#import "BanBoTaDiaoViewController.h"
#import "BanBoTaDiaoManager.h"
#import "BanBoTaDiaoModel.h"
#import "BanBoTaDiaoSheBeiModel.h"
#import "BanBoVRPeiXunVC.h"
@interface BanBoProjectMainViewController ()<HyPopMenuViewDelegate,BanboCustomTabbarDelegate>
//头上的4个
@property(strong,nonatomic)YZColorTextLabel *workCountLabel;
@property(strong,nonatomic)YZColorTextLabel *nowCountLabel;
@property(strong,nonatomic)YZColorTextLabel *todayCountLabel;
@property(strong,nonatomic)YZColorTextLabel *yestCountLabel;
//tableHeader
@property(strong,nonatomic)UILabel *projectNameLabel;
@property(strong,nonatomic)UIView *projectHeaderView;
//中间tabbar点击弹出view
@property (nonatomic, strong) HyPopMenuView* menu;

//数据
@property(assign,nonatomic)NSInteger lastWorkNow;
@property(assign,nonatomic)BOOL needRefreshDetail;
@property(strong,nonatomic)BanBoColumnHeader *columnHeader;

@property(strong,nonatomic)NSTimer *timer;
//环境监控data
@property(nonatomic,strong)NSMutableArray * subArray;
@property(nonatomic,strong)NSMutableArray * equipArray;
@property(nonatomic,strong)NSMutableArray * shebeiArray;
@property(nonatomic,strong)NSMutableArray * shebeiwuArray;
@property(nonatomic,strong)NSMutableArray * huanjingRealArray;
//塔吊data
@property(nonatomic,strong)NSMutableArray * taDiaoListArray;
@property(nonatomic,strong)NSMutableArray * TaDiaoSubArray;
@property(nonatomic,strong)NSMutableArray * taDiaoNameArray;
@property(nonatomic,strong)NSMutableArray * taDiaoSheBeiArray;
@property(nonatomic,strong)NSMutableArray * taDiaoSheBeiWuArray;
@property(nonatomic,strong)NSMutableArray * taDiaoRealArray;
@end
#define workCountDefaultText  NSLocalizedString(@"花名册总人数:", nil)
#define nowCountDefaultText   NSLocalizedString(@"场内实时人数:", nil)
#define todayCountDefaultText NSLocalizedString(@"今日累计进场人数:", nil)
#define yestCountDefaultText  NSLocalizedString(@"昨日累计进场人数:", nil)

@implementation BanBoProjectMainViewController
-(instancetype)initWithProject:(BanBoProject *)project{
    if (self=[super init]) {
        _project=project;
          DDLogInfo(@"工程id:%@-mingzi:%@",_project.projectId,_project.name);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _shebeiArray = [NSMutableArray array];
    _shebeiwuArray= [NSMutableArray array];
    _subArray = [NSMutableArray array];
    _equipArray = [NSMutableArray array];
    _taDiaoSheBeiWuArray = [NSMutableArray array];
    _TaDiaoSubArray = [NSMutableArray array];
    _taDiaoNameArray = [NSMutableArray array];
    _taDiaoListArray = [NSMutableArray array];
    _taDiaoSheBeiArray = [NSMutableArray array];
    _huanjingRealArray = [NSMutableArray array];
    _taDiaoRealArray = [NSMutableArray array];
    [self getTaDiaoData];
    [self getHuanJingData];
    [self setupSubviews];
    [self cleanCache];
    self.needRefreshDetail=YES;
    [self readyDetail];
    [self getTotalData];
    [self getDetailData];
    //坑爹.少些了然后。需要改到这里了不然报到那里的班组获得不到了
    [[BanBoShiMinManager sharedInstance] setProjectId:self.project.projectId];
    [self insertPopView];
    
}
#pragma mark - 环境数据
-(void)getHuanJingData
{
   __weak typeof(self) weakself= self;
    [_subArray removeAllObjects];
    [_shebeiArray removeAllObjects];
    [_shebeiwuArray removeAllObjects];
    [_equipArray removeAllObjects];
    [_huanjingRealArray removeAllObjects];
    [[BanBoHJJKManager sharedInstance]postSheBeiListWithProject:self.project.projectId completion:^(id data, NSError *error) {
        for (NSDictionary * dicse in data)
        {
            [_equipArray addObject:dicse[@"equipmentId"]];
            [_shebeiwuArray addObject:dicse[@"equipmentName"]];
            [[BanBoHJJKManager sharedInstance]posthuanJSShiDataWithSheBeiId:dicse[@"equipmentId"] completion:^(id data, NSError *error) {
                if ([data isKindOfClass:[NSString class]]) {
                    NSDictionary * dci = @{@"equipmentName":dicse[@"equipmentName"],@"pm2p5Msg":@"优秀",@"pm10Msg":@"优秀",@"pm2p5":@"0",@"pm10":@"0",@"rtdId":@0,@"humi":@"0",@"tsp":@"0",@"temp":@"0",@"ws":@"0",@"wdir":@"0",@"atm":@"0",@"nvh":@"0",@"createTime":@"0",@"dataTime":@"0",@"equipmentId":dicse[@"equipmentId"],@"windScale":@"0",@"waring":@[]};
                    BanBoHuanJModel * models = [BanBoHuanJModel mj_objectWithKeyValues:dci];
                    [_huanjingRealArray addObject:models.equipmentId];
                    [_shebeiArray addObject:models.equipmentName];
                    [_subArray addObject:models];
                    
                }
                else
                {
                    BanBoHuanJModel * model = [BanBoHuanJModel mj_objectWithKeyValues:data];
                    [_shebeiArray addObject:model.equipmentName];
                    [_huanjingRealArray addObject:model.equipmentId];
                    [_subArray addObject:model];
                }
                
            }];
           
        }
         [weakself.dataTableView reloadData];
    }];
}
#pragma mark - 获取塔吊数据
-(void)getTaDiaoData
{
    __weak typeof(self) wself= self;
    [_TaDiaoSubArray removeAllObjects];
    [_taDiaoNameArray removeAllObjects];
    [_taDiaoRealArray removeAllObjects];
    [_taDiaoListArray removeAllObjects];
    [_taDiaoSheBeiWuArray removeAllObjects];
    [[BanBoTaDiaoManager sharedInstance]postTaDiaoListWithProject:self.project.projectId completion:^(id data, NSError *error) {
        for (NSDictionary * dicse in data) {
            BanBoTaDiaoSheBeiModel * models = [BanBoTaDiaoSheBeiModel mj_objectWithKeyValues:dicse];
                [_taDiaoListArray addObject:models.deviceId];
                [_taDiaoSheBeiWuArray addObject:models.deviceName];
                [_taDiaoSheBeiArray addObject:models];
            [[BanBoTaDiaoManager sharedInstance]postTaDiaoDataWithSheBeiId:models.deviceId completion:^(id data, NSError *error) {
                if ([data isKindOfClass:[NSString class]]) {
                    NSDictionary * dcis = @{@"recordName":models.deviceName,@"dateTime":@"无最新时间",@"deviceId":models.deviceId,@"dwRotate":@"0",@"latitude":@"0",@"longitude":@"0",@"wDip":@0,@"wHeight":@"0",@"wLoad":@"0",@"wMargin":@0,@"wRate":@0,@"wTorque":@0,@"recordNumber":@"0",@"wWindvel":@"0",@"wFCodeVRate":@0,@"wFRateVCode":@0};
                    BanBoTaDiaoModel * models = [BanBoTaDiaoModel mj_objectWithKeyValues:dcis];
                    [_taDiaoNameArray addObject:models.recordName];
                    [_taDiaoRealArray addObject:models.deviceId];
                    [_TaDiaoSubArray addObject:models];
                }
                else
                {
                    
                    BanBoTaDiaoModel * model = [BanBoTaDiaoModel mj_objectWithKeyValues:data];
                    [_taDiaoNameArray addObject:model.recordName];
                    [_taDiaoRealArray addObject:model.deviceId];
                    [_TaDiaoSubArray addObject:model];
                    
                }
              
            }];
        }
        
         [wself.dataTableView reloadData];
    }];
    
}
-(void)insertPopView
{
    _menu = [HyPopMenuView sharedPopMenuManager];
    PopMenuModel* model = [self createPopMenuModelWithImageNameStr:@"shiminzhi" withTitle:@"实名制" withTextColor:[UIColor hcy_colorWithString:@"#666666"] withTransitionType:PopMenuTransitionTypeSystemApi withTransitionRenderingColor:nil];
    PopMenuModel* model1 = [self createPopMenuModelWithImageNameStr:@"sushe" withTitle:@"宿舍" withTextColor:[UIColor hcy_colorWithString:@"#666666"] withTransitionType:PopMenuTransitionTypeSystemApi withTransitionRenderingColor:nil];
    PopMenuModel* model2 = [self createPopMenuModelWithImageNameStr:@"peixun" withTitle:@"培训" withTextColor:[UIColor hcy_colorWithString:@"#666666"] withTransitionType:PopMenuTransitionTypeSystemApi withTransitionRenderingColor:nil];
    PopMenuModel* model3 = [self createPopMenuModelWithImageNameStr:@"huanjingjiankong" withTitle:@"环境监控" withTextColor:[UIColor hcy_colorWithString:@"#666666"] withTransitionType:PopMenuTransitionTypeSystemApi withTransitionRenderingColor:nil];
    PopMenuModel* model4 = [self createPopMenuModelWithImageNameStr:@"tadiaotubiao" withTitle:@"塔吊监控" withTextColor:[UIColor hcy_colorWithString:@"#666666"] withTransitionType:PopMenuTransitionTypeSystemApi withTransitionRenderingColor:nil];
    
    _menu.dataSource = @[ model, model1, model2,model3,model4];//model3
    _menu.delegate = self;
    _menu.popMenuSpeed = 10.0f;
    _menu.automaticIdentificationColor = false;
    _menu.animationType = HyPopMenuViewAnimationTypeCenter;
    
}
-(PopMenuModel *)createPopMenuModelWithImageNameStr:(NSString *)imagename withTitle:(NSString *)title withTextColor:(UIColor *)color withTransitionType:(PopMenuTransitionType)type withTransitionRenderingColor:(UIColor *)renderingcolor
{
    PopMenuModel * model = [PopMenuModel allocPopMenuModelWithImageNameString:imagename  AtTitleString:title  AtTextColor:color  AtTransitionType:type  AtTransitionRenderingColor:renderingcolor];
    return model;
}
#pragma mark subViews
-(void)setupSubviews{
    
    [self.view addSubview:self.customTabbar];
    self.dataTableView.backgroundColor=[UIColor clearColor];
    //    self.dataTableView.layer.cornerRadius=8;
    //要固定
    [self.view addSubview:self.projectHeaderView];
    
    UIButton *logoutBtn=[UIButton new];
    logoutBtn.titleLabel.font=[UIFont systemFontOfSize:[UIFont systemFontSize]];
    [logoutBtn setTitle:@"注销" forState:UIControlStateNormal];
    [logoutBtn sizeToFit];
    _logoutBtn=logoutBtn;
    [logoutBtn addTarget:self action:@selector(logoutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc] initWithCustomView:logoutBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
    //title
    YZTitleView *view=[YZTitleView new];
    view.width=self.view.width;
    view.text=[[BanBoUserInfoManager sharedInstance] userPageTitle];
    [view showInNaviItem:self.navigationItem];
}
#pragma mark timer
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self restartTimer];
    self.navigationController.interactivePopGestureRecognizer.enabled=YES;
//    [self getTaDiaoData];
//    [self getHuanJingData];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self stopTimer];
}
-(void)restartTimer{
    
    if(self.timer){
        //  DDLogInfo(@"startTimer but already have");
        return;
    }
    //    DDLogInfo(@"startTimer");
    NSTimer *timer=[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(refreshDataWithTimer:) userInfo:nil repeats:YES];
    self.timer=timer;
}
-(void)refreshDataWithTimer:(NSTimer *)timer{
    [self getTotalData];
    [self getDetailData];
    [self getTaDiaoData];
    [self getHuanJingData];
}
-(void)stopTimer{
    if (self.timer) {
        //  DDLogInfo(@"stopTimer");
        [self.timer invalidate];
        self.timer=nil;
    }else{
        // DDLogInfo(@"stopTimer but timer is nil");
    }
}

#pragma mark 缓存
-(void)cleanCache{
    [[YZCacheManager sharedInstance] removeCacheForKey:YZCacheKeyBanzhuItem type:YZCacheTypeMemory];
    [[YZCacheManager sharedInstance] removeCacheForKey:YZCacheKeyXiaoBanzhuItem type:YZCacheTypeMemory];
}
#pragma mark 数据获取
-(void)getTotalData{
    __weak typeof(self) wself=self;
    [[BanBoHomeManager sharedInstance]getProjectTotalInfoWithProjectId:self.project.projectId completion:^(id data, NSError *error) {
        if (!wself) {
            return ;
        }
        dispatch_async_main_safe(^{
            if(error){
                [HCYUtil showError:error];
            }else{
                [wself refreshColorLabel:data];
            }
            
        });
    }];
}
-(void)getDetailData{
    if(self.needRefreshDetail==NO){
        // DDLogInfo(@"场内人数未变化.不刷新");
        return;
    }
    self.needRefreshDetail=NO;
    __weak typeof(self) wself=self;
    [[BanBoHomeManager sharedInstance] getProjectDetailInfoWithGroupId:self.project.projectId start:0 limit:10000 completion:^(BanBoProjectDetail* data, NSError *error) {
        if (!wself) {
            return ;
        }
        dispatch_async_main_safe(^{
            if (error) {
                [HCYUtil showError:error];
            }else{
                [wself refreshDetailData:data.result];
            }
        });
    }];
    
}
-(void)readyDetail{
    self.columnLayoutManager=[[HCYColumnLayoutManager alloc] initWithColumnCount:5 tableView:self.dataTableView];
    self.columnLayoutManager.tableViewEdge=UIEdgeInsetsMake(0, 10, 0, 10);
    
    self.tableViewDataArrM =[NSMutableArray array];
    [self.tableViewDataArrM addObject:self.columnHeader];
    [self.columnLayoutManager cleanData];
    [self.columnLayoutManager refreshHeader:self.columnHeader];
    self.dataCollection.groupMemberComparator=^NSComparisonResult(id obj1,id obj2){
        return NSOrderedSame;
    };
    [self setDataCollectionAndReloadTableView];
}
-(void)refreshDetailData:(NSArray *)data{
    
    //        DDLogInfo(@"refreshDetailData:%@",data);
    NSMutableArray *cellObjArrM=[NSMutableArray array];
    for (BanBoProjectDetailInfo *info in data) {
        //班组，明天，昨天，7天，30天每行的属性
        BanBoProjectDetailCellObj *cellObj=[BanBoProjectDetailCellObj new];
        cellObj.data=info;
        cellObj.cellHeight=[BanBoLayoutParam projectCellHeight];
        [cellObjArrM addObject:cellObj];
    }
    //    if (self.tableViewDataArrM.count>1) {
    //        [self.tableViewDataArrM removeObjectsInRange:NSMakeRange(1, self.tableViewDataArrM.count-1)];
    //    }
    //    [self.tableViewDataArrM addObjectsFromArray:cellObjArrM];
    self.tableViewDataArrM=cellObjArrM;
    [self.columnLayoutManager cleanData];
    [self.columnLayoutManager refreshHeader:self.columnHeader];
    [self.columnLayoutManager addModels:cellObjArrM];
    [self setDataCollectionAndReloadTableView];
}


#pragma mark tabDelegate
-(void)customBar:(BanBoCustomTabbarView *)tabbar toAddBtn:(UIButton *)btn{
    _menu.backgroundType = HyPopMenuViewBackgroundTypeLightTranslucent;
    [_menu openMenu];
    
}
-(void)customBar:(BanBoCustomTabbarView *)tabbar toNVR:(UIButton *)btn{
    
    EZDeviceTableViewController *deviceListVC=[EZDeviceTableViewController new];
    deviceListVC.project=self.project;
    [self.navigationController pushViewController:deviceListVC animated:YES];
}
-(void)customBar:(BanBoCustomTabbarView *)tabbar toReport:(UIButton *)btn{
    BanBoReportListViewController *list=[[BanBoReportListViewController alloc] initWithProject:self.project];
    [self.navigationController pushViewController:list animated:YES];
    
}
-(void)logoutBtnClick:(UIButton *)btn{
    [[BanBoUserInfoManager sharedInstance] logoutWithCompletion:nil];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"username"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"password"];
}
#pragma mark - 中间按钮delegate
-(void)popMenuView:(HyPopMenuView *)popMenuView didSelectItemAtIndex:(NSUInteger)index
{
    switch (index) {
        case 0:
        {
            BanBoShiminViewController *vc=[[BanBoShiminViewController alloc] initWithProject:self.project];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            BanBoSuSheGuanLiViewController * vcs = [[BanBoSuSheGuanLiViewController alloc]initWithProject:self.project];
            [self.navigationController pushViewController:vcs animated:YES];
        }
            break;
        case 2:
        {
            
            BanBoVRPeiXunVC * vrvc = [[BanBoVRPeiXunVC alloc]initWithProject:self.project];
            [self.navigationController pushViewController:vrvc animated:YES];
        }
            break;
        case 3:
        {
            
            if (_equipArray.count==0) {
                UIAlertView * alet = [[UIAlertView alloc]initWithTitle:@"" message:@"当前工地无环境监控设备" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alet show];
                
                [self getHuanJingData];
                return;
            }
            else
            {
                BanBoHJJKongViewController * fpv = [[BanBoHJJKongViewController alloc]init];
                fpv.VCarray = _huanjingRealArray;
                fpv.array = _shebeiArray;
                fpv.subArray = _subArray;
                [self.navigationController pushViewController:fpv animated:YES];
            }
            
        }
            break;
        case 4:
        {
            if(_taDiaoListArray.count==0)
            {
                UIAlertView * alet = [[UIAlertView alloc]initWithTitle:@"" message:@"当前工地无塔吊监控设备" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alet show];
                [self getTaDiaoData];
                return;
            }
            else
            {
                
                BanBoTaDiaoViewController * tadiao = [[BanBoTaDiaoViewController alloc]init];
                tadiao.tadiaoNameArray = _taDiaoNameArray;
                tadiao.tadiaoSubArray = _TaDiaoSubArray;
                tadiao.shebeiArray = _taDiaoSheBeiArray;
                tadiao.listArray = _taDiaoRealArray;
                [self.navigationController pushViewController:tadiao animated:YES];
                
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark UIRefresh
-(void)refreshColorLabel:(BanBoProjectTotal *)data{
    self.projectNameLabel.text=data.name;
    [self.projectNameLabel sizeToFit];
    [self refreshColorLabelRed:self.workCountLabel val:data.TotalWorker text:workCountDefaultText];
    [self refreshColorLabelRed:self.nowCountLabel val:data.WorkerNow text:nowCountDefaultText];
    if(data.WorkerNow!=self.lastWorkNow){
        self.needRefreshDetail=YES;
        self.lastWorkNow=data.WorkerNow;
    }
    
    [self refreshColorLabelBlue:self.todayCountLabel val:data.TotalCheckToday text:todayCountDefaultText];
    [self refreshColorLabelBlue:self.yestCountLabel val:data.TotalCheckYestoday text:yestCountDefaultText];
}
-(void)refreshColorLabelRed:(YZColorTextLabel *)label val:(NSInteger)val text:(NSString *)text{
    [label refreshWithText:text Val:[NSString stringWithFormat:@"%ld",(long)val]  valColor:BanBoRedColor];
}
-(void)refreshColorLabelBlue:(YZColorTextLabel *)label val:(NSInteger)val text:(NSString *)text{
    [label refreshWithText:text Val:[NSString stringWithFormat:@"%ld",(long)val]  valColor:BanBoBlueColor];
}
#pragma mark superClassMethod
-(UIColor *)bgColorForCellAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
        return [UIColor hcy_colorWithString:@"#e1f7fd"];
    }else{
        BOOL isDoubleRow=indexPath.row%2;
        if (isDoubleRow) {
            return [UIColor whiteColor];
        }else{
            return [UIColor hcy_colorWithString:@"#f8f8f8"];
        }
    }
}
-(void)onCellCreated:(YZListCell *)cell indexPath:(NSIndexPath *)indexPath{
    cell.userInteractionEnabled=NO;
    [super onCellCreated:cell indexPath:indexPath];
}
-(CGRect)banbo_dataTableFrame{
    CGFloat leftMargin=10;
    CGFloat top=self.projectHeaderView.bottom;
    return CGRectMake(leftMargin,top, self.view.width-leftMargin*2, self.view.height-top-self.customTabbar.height-10);
}

#pragma mark modelLazy
-(BanBoColumnHeader *)columnHeader{
    if (!_columnHeader) {
        BanBoColumnHeader *header=[BanBoColumnHeader new];
        header.cellClass=@"BanBoProjectListCell";
        header.cellHeight=[BanBoLayoutParam projectHeaderCellHeight];
        header.titles=[self getHeaderTitles];
        header.font=[YZLabelFactory normalFont];
        _columnHeader=header;
    }
    return _columnHeader;
}
-(NSArray *)getHeaderTitles{
    NSDateFormatter *formatter=[NSDateFormatter new];
    formatter.dateFormat=@"MM-dd";
    NSDate *today=[NSDate new];
    
    NSString *todayStr=[formatter stringFromDate:today];
    
    NSDate *yesterDay=[today dateByAddingTimeInterval:-60*60*24];
    
    NSString *yesterDayStr=[formatter stringFromDate:yesterDay];
    
    return @[@"班组",todayStr,yesterDayStr,@"7天累计",@"30天累计"];
    
}

#pragma mark viewLazyLoad
@synthesize topView=_topView;
-(UIView *)topView{
    if (!_topView) {
        UIView *topView=[[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, 65)];
        topView.backgroundColor=[UIColor whiteColor];
        CGFloat labelMargin=[BanBoLayoutParam homeColorLabelMarginCenter];
        
        CGFloat labelWidth=topView.width*.5-labelMargin;
        CGFloat labelHeight=topView.height*.5;
        CGSize labelSize=CGSizeMake(labelWidth, labelHeight);
        
        YZColorTextLabel *workCountLabel=[self leftLabelWithSize:labelSize];
        workCountLabel.text=workCountDefaultText;
        [topView addSubview:workCountLabel];
        self.workCountLabel=workCountLabel;
        
        YZColorTextLabel *nowCountLabel=[self leftLabelWithSize:labelSize];
        nowCountLabel.text=nowCountDefaultText;
        nowCountLabel.top=workCountLabel.bottom;
        [topView addSubview:nowCountLabel];
        self.nowCountLabel=nowCountLabel;
        
        YZColorTextLabel *todayCountLabel=[self rightLabelWithSize:labelSize];
        todayCountLabel.text=todayCountDefaultText;
        todayCountLabel.left=workCountLabel.right+labelMargin;
        [topView addSubview:todayCountLabel];
        self.todayCountLabel=todayCountLabel;
        
        YZColorTextLabel *yestCountLabel=[self rightLabelWithSize:labelSize];
        yestCountLabel.text=yestCountDefaultText;
        yestCountLabel.left=todayCountLabel.left;
        yestCountLabel.top=nowCountLabel.top;
        [topView addSubview:yestCountLabel];
        self.yestCountLabel=yestCountLabel;
        _topView=topView;
    }
    return _topView;
}

@synthesize projectHeaderView=_projectHeaderView;
-(UIView *)projectHeaderView{
    if (!_projectHeaderView) {
        
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(10,self.topView.bottom+10 , self.view.width-20, 54)];
        
        view.backgroundColor=[UIColor whiteColor];
        
        UILabel *projectNameLabel=[YZLabelFactory blueLabel];
        projectNameLabel.textColor=[UIColor hcy_colorWithString:@"#13b6f6"];
        projectNameLabel.translatesAutoresizingMaskIntoConstraints=NO;
        
        self.projectNameLabel=projectNameLabel;
        [view addSubview:projectNameLabel];
        
        [projectNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@20);
            make.centerY.equalTo(view.mas_centerY);
        }];
        
        UILabel *subLabel=[YZLabelFactory grayLabel];
        [subLabel sizeToFit];
        subLabel.translatesAutoresizingMaskIntoConstraints=NO;
        subLabel.text=@"(考勤近况)";
        [view addSubview:subLabel];
        [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(projectNameLabel.mas_right).offset(10);
            make.centerY.equalTo(view.mas_centerY);
        }];
        
        _projectHeaderView=view;
    }
    return _projectHeaderView;
    
}
@synthesize customTabbar=_customTabbar;
-(BanBoCustomTabbarView *)customTabbar{
    if (!_customTabbar) {
        _customTabbar=[BanBoCustomTabbarView inst];
        _customTabbar.top=self.view.height-_customTabbar.height;
        _customTabbar.delegate=self;
    }
    return _customTabbar;
}
#pragma mark func



-(YZColorTextLabel *)leftLabelWithSize:(CGSize)labelSize{
    YZColorTextLabel *colorLabel=[YZLabelFactory grayColorLabel];
    
    colorLabel.textAlignment=NSTextAlignmentCenter;
    colorLabel.width=labelSize.width;
    colorLabel.height=labelSize.height;
    colorLabel.autoresizingMask=(UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin);
    
    return colorLabel;
}

-(YZColorTextLabel *)rightLabelWithSize:(CGSize)labelSize{
    YZColorTextLabel *colorLabel=[YZLabelFactory grayColorLabel];
    
    colorLabel.textAlignment=NSTextAlignmentLeft;
    colorLabel.width=labelSize.width;
    colorLabel.height=labelSize.height;
    
    colorLabel.autoresizingMask=(UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleHeight);
    
    return colorLabel;
}

@end
