
//
//  BanBoPersonInfoCollectViewController.m
//  kq_banbo_app
//
//  Created by hcy on 2016/12/8.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoPersonInfoCollectViewController.h"
#import "BanBoShiminDetail.h"
#import "BanBoPersonInfoCollectHeaderView.h"
#import "BanBoImageHeaderView.h"
#import "BanBoHealthInfo.h"
#import "YZTitleView+BanBo.h"
#import "BanBoHealthInfoCollectViewController+SubClassFactory.h"

extern NSString*const BanBoHealthInfoCollectBtnClicked; //班博-实名-采集按钮点击
extern NSString*const BanBoHealthInfoViewBtnClicked;    //班博-实名-查看按钮点击

@interface BanBoPersonInfoCollectViewController ()
@property(strong,nonatomic)BanBoShiminUser *user;
@property(strong,nonatomic)BanBoProject *project;
@property(strong,nonatomic)BanBoColumnHeader *columnHeader;
@property(strong,nonatomic)NSArray *healthData;
@property(assign,nonatomic)BOOL needOutRefresh;
@property(strong,nonatomic)BanBoPersonInfoCollectHeaderView *healthHeader;


@end
#define PersonInfoCellHeight 40
@implementation BanBoPersonInfoCollectViewController
-(instancetype)initWithUser:(BanBoShiminUser *)user project:(BanBoProject *)project{
    if (self=[super init]) {
        self.user=user;
        self.project=project;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //4月12日修改
    [self.healthHeader refreshWithUser:self.user];
    YZTitleView *titleView=[YZTitleView banbo_inst];
    [titleView showInNaviItem:self.navigationItem];
    
    HCYColumnLayoutManager *columnManager=[[HCYColumnLayoutManager alloc] initWithColumnCount:self.columnHeader.titles.count tableView:[self dataTableView]];
    columnManager.tableViewEdge=UIEdgeInsetsMake(0, 10, 0, 10);
    self.columnLayoutManager=columnManager;
    [self refreshData];

}
-(void)viewDidDisappear:(BOOL)animated{
    [super  viewDidDisappear:animated];
    if (self.completion) {
        self.completion(self.needOutRefresh);
    }
}

-(void)refreshData{
    self.healthData=nil;
    self.tableViewDataArrM=[@[self.columnHeader] mutableCopy];
    [self.tableViewDataArrM addObjectsFromArray:self.healthData];
    
    [self.columnLayoutManager cleanData];
    [self.columnLayoutManager refreshHeader:self.columnHeader];
    [self.columnLayoutManager addModels:self.healthData];
    [super setDataCollectionAndReloadTableView];
}


#pragma mark cell
-(void)onCellCreated:(YZListCell *)cell indexPath:(NSIndexPath *)indexPath{
    if ([cell isKindOfClass:[BanboColumnCell class]]) {
        [((BanboColumnCell *)cell) setColumnLayoutManager:self.columnLayoutManager];
    }
    if ([cell isKindOfClass:[BanboMutLabelColumnCell class]]) {
        BanboMutLabelColumnCell *mutcell=(BanboMutLabelColumnCell *)cell;
        [mutcell createLabelWithCount:self.columnHeader.titles.count font:[YZLabelFactory normalFont] colorDict:nil];
    }
}
-(UIColor *)bgColorForCellAtIndexPath:(NSIndexPath *)path{
    if (path.row==0) {
        return BanBoShiminGrayColor;
    }else{
        return [UIColor whiteColor];
    }
}
#pragma mark cellEvent
-(void)list_onCatchEvent:(YZListCellEvent *)event{
    UITableViewCell *cell=  event.cell;
    NSIndexPath *path=[[self dataTableView] indexPathForCell:cell];
    if (path.row==NSNotFound) {
        return;
    }
    
    if([event.eventName isEqualToString:BanBoHealthInfoCollectBtnClicked] || [event.eventName isEqualToString:BanBoHealthInfoViewBtnClicked]){
        BOOL isViewMode=[event.eventName isEqualToString:BanBoHealthInfoViewBtnClicked];
        
        BanBoHealthInfoCollectViewController *collectVC=nil;
        __weak typeof(self) wself=self;
        NSInteger row=path.row;
        NSString *keyworad=@"";
        //因为数据里照片2个存的是日期字符串。后面2个存的是毫秒
        NSString *updateStr=[HCYUtil dateStrFromDate:[NSDate new] dateFormat:@"YYYY-MM-dd"];
        NSString *updateTime=[NSString stringWithFormat:@"%f",[[NSDate new] timeIntervalSince1970]*1000];
        switch (row) {
            case 0:
            {
                collectVC=[BanBoHealthInfoCollectViewController dailyPhoto];
                keyworad=@"LifePicUpload";
                
                
            }
                break;
            case 1:
            {
                collectVC=[BanBoHealthInfoCollectViewController CardInfo];
                keyworad=@"CardIdUpload";
            }
                break;
            case 2:
            {
                collectVC=[BanBoHealthInfoCollectViewController BloodPressure];
                keyworad=@"BloodDate";
            }
                break;
            case 3:
            {
                collectVC=[BanBoHealthInfoCollectViewController Cardiogram];
                keyworad=@"HeartRateDate";
            }
                break;
            default:
                break;
        }
        if(collectVC){
            collectVC.user=self.user;
            collectVC.project=self.project;
            collectVC.isViewMode=isViewMode;
            __weak typeof(collectVC) wCollectVC=collectVC;
            if (!isViewMode && keyworad.length) {
                collectVC.completion=^(id data,NSError *error,BOOL isCancel){
                    if (!isCancel && error==nil) {
                        [wself.user setValue:updateTime forKey:keyworad];
                        [wself updateDateStr:updateStr atIdx:row reloadTableView:YES];
                    }
                    [wCollectVC.navigationController popViewControllerAnimated:YES];
                };
            }
            [self.navigationController pushViewController:collectVC animated:YES];
        }
        
    }

}

#pragma mark view
@synthesize topView=_topView;
-(UIView *)topView{
    if (!_topView) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0)];;
        BanBoImageHeaderView *header=[BanBoImageHeaderView new];
        header.text=@"个人信息采集";
        
        [view addSubview:header];
        
        BanBoPersonInfoCollectHeaderView *headerSec=[BanBoPersonInfoCollectHeaderView new];
        _healthHeader=headerSec;
        headerSec.width=view.width;
        headerSec.top=header.bottom;
        //传工地id
        headerSec.project = self.project;
        [view addSubview:headerSec];
        view.height=headerSec.bottom;
        
        _topView=view;
    }
    return _topView;
}
#pragma mark - param
-(void)updateDateStr:(NSString *)updateStr atIdx:(NSInteger)idx reloadTableView:(BOOL)reload{
    BanBoHealthInfo *info=nil;
    if (idx>=0 && idx<self.healthData.count) {
        info=self.healthData[idx];
    }
    if (!info) {
        return;
    }
    info.updateDateStr = updateStr;
   
    info.statusStr=updateStr.length?@"有":@"无";
    
    if (reload) {
        dispatch_async_main_safe(^{
            [self refreshData];
            [self.dataTableView reloadData];
        });
    }
    self.needOutRefresh=YES;
    
}

-(NSArray *)healthData{
    if (!_healthData) {
        BanBoHealthInfo *info1=[self healthInfoWithName:@"生活照" status:self.user.LifePicUpload updateStr:self.user.LifePicUpload];
        BanBoHealthInfo *info2=[self healthInfoWithName:@"身份证" status:self.user.CardIdUpload updateStr:self.user.CardIdUpload];
        
        NSString *bloodDateStr=[self timeStrWithTimeVal:self.user.BloodDate format:@"YYYY-MM-dd"];
        BanBoHealthInfo *info3=[self healthInfoWithName:@"血 压" status:self.user.BloodDate updateStr:bloodDateStr];

        NSString *heartDateStr=[self timeStrWithTimeVal:self.user.HeartRateDate format:@"YYYY-MM-dd"];
        BanBoHealthInfo *info4=[self healthInfoWithName:@"心电图" status:self.user.HeartRate updateStr:heartDateStr];
        _healthData=@[info1,info2,info3,info4];
    }
    return _healthData;
}
-(NSString *)timeStrWithTimeVal:(NSString *)val format:(NSString *)formatStr{
    NSString *result=val;
    if (val.length && [val isEqualToString:@"无"]==NO) {
        @try {
            NSTimeInterval heartDateInterVal=[val doubleValue]/1000;
            NSDate *date=[NSDate dateWithTimeIntervalSince1970:heartDateInterVal];
            if (date) {
                result=[HCYUtil dateStrFromDate:date dateFormat:formatStr];
            }
        } @catch (NSException *exception) {
        } @finally {
        }
    }
         return result;
}

-(CGRect)banbo_dataTableFrame{
    UIView *view=[self topView];
    CGFloat y=view.bottom+1;//默认+10
    return CGRectMake(0, y, self.view.width, self.view.height-y);
    
}

#pragma mark lazyLoad
-(BanBoColumnHeader *)columnHeader{
    if (!_columnHeader) {
        BanBoColumnHeader *header=[BanBoColumnHeader new];
        header.cellHeight=PersonInfoCellHeight;
        header.titles=@[@"项目",@"状态",@"更新时间",@"是否查看",@"是否采集"];
        _columnHeader=header;
    }
    return _columnHeader;
}

-(BanBoHealthInfo *)healthInfoWithName:(NSString *)name status:(NSString *)status updateStr:(NSString *)dateStr{
    BanBoHealthInfo *info=[BanBoHealthInfo new];
    
    info.projectName=name;
    if (status.length && [status isEqualToString:@"无"]==NO) {
        info.statusStr=@"有";
    }else{
        info.statusStr=@"无";
    }
    info.updateDateStr=dateStr.length?dateStr:@"无";
    info.cellHeight=PersonInfoCellHeight;
    
    return info;
}



@end
