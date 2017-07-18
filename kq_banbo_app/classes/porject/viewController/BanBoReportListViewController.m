//
//  BanBoReportListViewController.m
//  kq_banbo_app
//
//  Created by hcy on 2016/12/1.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoReportListViewController.h"

#import "BanBoNewReportViewController.h"

#import "BanBoProjectManager.h"
#import "YZTitleView+BanBo.h"
#import "BanBoImageHeaderView.h"
#import "BanBoLineHeaderView.h"
#import "BanBoProject.h"
#import "BanBoShiminDetail.h"
#import "HCYMutableBtnView.h"
#import "BanBoPersonInfoCollectViewController.h"
@interface BanBoReportListViewController ()<HCYMutableBtnViewDelegate>
@property(strong,nonatomic)BanBoProject *project;
@property(strong,nonatomic)UILabel *todayCountLabel;
@property(strong,nonatomic)BanBoImageHeaderView *imageHeaderView;
@property(strong,nonatomic)UIView *sectionSelectView;
@property(strong,nonatomic)UIButton *selectedBtn;

@property(strong,nonatomic)BanBoColumnHeader *columnHeader;

@end
#define ProjectNameSuffix @"项目部报到"
@implementation BanBoReportListViewController
-(instancetype)initWithProject:(BanBoProject *)project{
    if (self=[super init]) {
        self.project=project;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    YZTitleView *view=[YZTitleView banbo_inst];
    [view showInNaviItem:self.navigationItem];
    [self setupSubviews];
    [self readyColumn];
    [self getData];
}
#pragma mark subview
-(void)setupSubviews{
    UIButton *personBtn=[BanBoBtnMaker sectionSelectBtnWithNormalTitle:@"个人信息"];
    UIButton *healthBtn=[BanBoBtnMaker sectionSelectBtnWithNormalTitle:@"健康信息"];
    
    self.selectedBtn=personBtn;
    HCYMutableBtn *mPersonBtn=[HCYMutableBtn mutBtnWithBtn:personBtn];
    mPersonBtn.needFixSize=NO;
    HCYMutableBtn *mHealthBtn=[HCYMutableBtn mutBtnWithBtn:healthBtn];
    mHealthBtn.needFixSize=NO;
    
    CGFloat sectionSelectHeight=30;
    
    UIView *sectionBgView=[[UIView alloc] initWithFrame:CGRectMake(0, self.topView.bottom+10, self.view.width, sectionSelectHeight)];
    sectionBgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:sectionBgView];
    
    HCYTableBtnView *sectionSelectView=[HCYTableBtnView new];
    sectionSelectView.delegate=self;
    sectionSelectView.frame=CGRectMake(10, 0, self.view.width-10, sectionSelectHeight);
    [sectionBgView addSubview:sectionSelectView];
    self.sectionSelectView=sectionSelectView;
    
    sectionSelectView.lineMargin=0;
    sectionSelectView.itemMargin=5;
    sectionSelectView.rowCount=1;
    sectionSelectView.columnCount=2;

    [sectionSelectView addBtn:mPersonBtn];
    [sectionSelectView addBtn:mHealthBtn];
    
    self.sectionSelectView=sectionBgView;

}

-(void)readyColumn{
    NSMutableArray *dataArrM=[NSMutableArray array];
    BanBoColumnHeader *header=[BanBoColumnHeaderMaker personalHeader];
    UIImage *image=[UIImage imageNamed:@"dengdaizhong"];
    [header addExtWidth:image.size.width forIdx:4];
    
    self.columnLayoutManager=[[HCYColumnLayoutManager alloc] initWithColumnCount:header.titles.count tableView:self.dataTableView];
    self.columnLayoutManager.tableViewEdge=UIEdgeInsetsMake(0, 10, 0, 10);
    [self.columnLayoutManager refreshHeader:header];
    [dataArrM addObject:header];
    self.tableViewDataArrM=dataArrM;
    [super setDataCollectionAndReloadTableView];
    self.columnHeader=header;
}
#pragma mark 获取数据
-(void)getData{
    __weak typeof(self) wself=self;
    [[BanBoProjectManager sharedInstance] getRecordsTotalWithProjectId:self.project.projectId completion:^(id data, NSError *error) {
        if (!wself) {
            return ;
        }
        dispatch_async_main_safe((^{
            if ([data isKindOfClass:[NSNumber class]]) {
                NSNumber *num=(NSNumber *)data;
                wself.imageHeaderView.text=[NSString stringWithFormat:@"%@(%ld)",[wself pageTitle],(long)[num integerValue]];
            }
        }));
    }];
    [self getPersonInfoData];
}

/**
 报到数据获取
 */
-(void)getPersonInfoData{
    __weak typeof(self)wself=self;
    [HCYUtil showProgressWithStr:@"获取数据中"];
    [[BanBoProjectManager sharedInstance] getRecordsDetailWithProjectId:self.project.projectId completion:^(BanBoRecordsObj* data, NSError *error) {
        if (!wself) {
            return ;
        }
        dispatch_async_main_safe((^{
            [HCYUtil dismissProgress];
            if (error) {
                [HCYUtil showError:error];
                return ;
            }
            NSInteger total= data.totoal;
            NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc] init];
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"今日累计报到" attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}]];
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld",(long)total] attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}]];
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"人" attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}]];
            
            wself.todayCountLabel.attributedText=attStr;
            [wself.todayCountLabel sizeToFit];
            [wself refreshTableView:data.result];
            
        }));
    }];
}

/**
 健康数据获取
 */
-(void)getHealthData{
    __weak typeof(self)wself=self;
    [HCYUtil showProgressWithStr:@"获取数据中"];
    [[BanBoProjectManager sharedInstance] getHealthDataWithProjectId:self.project.projectId completion:^(id data, NSError *error) {
        if (!wself) {
            return ;
        }
        dispatch_async_main_safe(^{
            [HCYUtil dismissProgress];
            if (error) {
                [HCYUtil showError: error];
                return ;
            }
            
        });
        NSInteger idx=1;
        NSMutableArray *dataM=[NSMutableArray array];
        for (BanBoShiminUser *user in data) {
            BanboShiminUserCellObj *cellObj=[BanboShiminUserCellObj new];
            cellObj.customReuseId=@"hcy";
            cellObj.xuhao=idx++;
            cellObj.cellClass=@"BanboMutLabelColumnCell";
            cellObj.cellHeight=[self cellHeight];
            cellObj.user=user;
            cellObj.type=BanBoShiminTypeJKGL;
            [dataM addObject:cellObj];
        }
        [wself reloadTableViewWithData:dataM];
    }];
}

#pragma mark tableView
-(void)refreshTableView:(NSArray *)dataArr{
    NSMutableArray *array=[NSMutableArray array];
    NSInteger i=1;
    for(BanBoRecordData *data in dataArr){
        data.xuhao=i++;
        BanBoRecordCellObj *cellObj=[BanBoRecordCellObj new];
        cellObj.cellHeight=[self cellHeight];
        cellObj.data=data;
        [array addObject:cellObj];
    }
    [self reloadTableViewWithData:array];
}
-(void)reloadTableViewWithData:(NSArray *)dataArr{
    NSMutableArray *arrM=[NSMutableArray array];
    [arrM addObject:self.columnHeader];
    if(dataArr.count){
        [arrM addObjectsFromArray:dataArr];
        [self.columnLayoutManager addModels:arrM];
    }
    
    self.tableViewDataArrM=arrM;
    [self setDataCollectionAndReloadTableView];
}
-(void)onCellCreated:(BanboColumnCell *)cell indexPath:(NSIndexPath *)indexPath{
    if ([cell isKindOfClass:[BanboMutLabelColumnCell class]]) {
        BanboMutLabelColumnCell *mutCell=(BanboMutLabelColumnCell *)cell;
        [mutCell createLabelWithCount:self.columnHeader.titles.count font:[UIFont systemFontOfSize:12.f] colorDict:nil];
//        cell.userInteractionEnabled=NO;
    }
    [super onCellCreated:cell indexPath:indexPath];
    
}
-(UIColor *)bgColorForCellAtIndexPath:(NSIndexPath *)path{
    if (path.row==0) {
        return [UIColor hcy_colorWithString:@"#fefdf4"];
    }
    return [UIColor whiteColor];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.columnHeader ==[BanBoColumnHeaderMaker healthHeader]) {
       BanboShiminUserCellObj *cellObj=(BanboShiminUserCellObj *)[self memberOfIndex:indexPath];
        if ([cellObj isKindOfClass:[BanboShiminUserCellObj class]]==NO) {
            return;
        }
        BanBoShiminUser *user= cellObj.user;
        BanBoPersonInfoCollectViewController *collectVC=[[BanBoPersonInfoCollectViewController alloc] initWithUser:user project:self.project];
//        __weak typeof(self) wself=self;
        collectVC.completion=^(BOOL needUpdate){
            if (needUpdate) {
                [self getHealthData];
            }
        };
        [self.navigationController pushViewController:collectVC animated:YES];
    }
    
}
#pragma mark btnEvents
-(void)setSelectedBtn:(UIButton *)selectedBtn{
    if (_selectedBtn==selectedBtn) {
        return;
    }
    if (_selectedBtn) {
        [_selectedBtn setSelected:NO];
    }
    [selectedBtn setSelected:YES];
    _selectedBtn=selectedBtn;
}
-(void)addRecordBtnClick:(UIButton *)btn{
    __weak typeof(self) wself=self;
    [[BanBoProjectManager sharedInstance] addRecordPreForProject:self.project.projectId completion:^(id data, NSError *error) {
        if (!wself) {
            return ;
        }
        dispatch_async_main_safe(^{
            if (error) {
                [HCYUtil showError:error];
            }else{
                BOOL b=[data boolValue];
                if (b) {
                    [wself toAddRecord];
                }else{
                    [HCYUtil toastMsg:@"暂时不能签到" inView:wself.view];
                }
            }
        });
    }];
}

#pragma mark btnViewDelegate
-(void)btnView:(HCYMutableBtnView *)btnView clickBtnAtIdx:(NSInteger)idx{
    HCYMutableBtn *btn=(HCYMutableBtn *)[btnView btnAtIdx:idx];
    if (!btn) {
        return;
    }
    UIButton *aBtn=btn.btn;
    self.selectedBtn=aBtn;
    
    BanBoColumnHeader *targetHeader=nil;
    switch (idx) {
        case 0:
        {
            //个人信息
            targetHeader=[BanBoColumnHeaderMaker personalHeader];
            [self getPersonInfoData];
        }
            break;
        case 1:
        {
            //健康
            targetHeader=[BanBoColumnHeaderMaker healthHeader];
            [self getHealthData];
        }
            break;
        default:
            break;
    }
    if (targetHeader) {
        self.columnHeader=targetHeader;
        [self.columnLayoutManager refreshHeader:targetHeader];
        [self reloadTableViewWithData:nil];
    }
    
    
}

#pragma mark pageJump
-(void)toAddRecord{
    BanBoNewReportViewController *addRecordVC=[[BanBoNewReportViewController alloc] initWithProject:self.project];
    [self.navigationController pushViewController:addRecordVC animated:YES];
}
#pragma mark other
-(NSString *)pageTitle{
    return [NSString stringWithFormat:@"%@%@",self.project.name,ProjectNameSuffix];
}

@synthesize topView=_topView;
-(CGRect)banbo_dataTableFrame{
    CGFloat top=self.sectionSelectView.bottom;
    CGFloat height=self.view.height-top;
    return CGRectMake(0, top, self.view.width, height);
}
-(UIView *)topView{
    if (!_topView) {
        UIView *topView=[UIView new];
        topView.top=64;
        topView.width=self.view.width;
        
        BanBoImageHeaderView *imageHeaderView=[BanBoImageHeaderView new];
        [topView addSubview:imageHeaderView];
        self.imageHeaderView=imageHeaderView;
        imageHeaderView.text=[self pageTitle];
        BanBoLineHeaderView *timeHeader=[self makeLineHeaderView];
        
        timeHeader.leftLabel.text=@"时  间  ";
        timeHeader.rightLabel.text=[HCYUtil dateStrFromDate:[NSDate new] dateFormat:@"yyyy年MM月dd日"];
        [timeHeader.leftLabel sizeToFit];
        
        timeHeader.top=imageHeaderView.bottom;
        timeHeader.width=topView.width;
        
        [topView addSubview:timeHeader];
        
        BanBoLineHeaderView *gongdi=[self makeLineHeaderView];
        gongdi.leftLabel.text=@"工  地  ";
        gongdi.rightLabel.text=[[self project] name];
        [gongdi.leftLabel sizeToFit];
    
        gongdi.top=timeHeader.bottom;
        gongdi.width=topView.width;
        [topView addSubview:gongdi];
        
        UIView *todayCountView=[[UIView alloc] initWithFrame:CGRectMake(0, gongdi.bottom, topView.width, gongdi.height)];
        todayCountView.backgroundColor=[UIColor whiteColor];
        [topView addSubview:todayCountView];
        
        UILabel *todayCountLabel=[YZLabelFactory blackLabel];
        todayCountLabel.text=@"今日累计签到人";
        [todayCountLabel sizeToFit];
        todayCountLabel.left=20;
        todayCountLabel.centerY=todayCountView.height*.5;
        [todayCountView addSubview:todayCountLabel];
        self.todayCountLabel=todayCountLabel;
        
        UIButton *addRecordBtn=[UIButton new];
        addRecordBtn.adjustsImageWhenHighlighted=NO;
        [addRecordBtn setTitleColor:BanBoBlueColor forState:UIControlStateNormal];
        addRecordBtn.titleLabel.font=[YZLabelFactory normalFont];
        [addRecordBtn setTitle:@"新增签到" forState:UIControlStateNormal];
        [addRecordBtn setImage:[UIImage imageNamed:@"xinzeng"] forState:UIControlStateNormal];
        [addRecordBtn addTarget:self action:@selector(addRecordBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [addRecordBtn sizeToFit];
        addRecordBtn.right=topView.width-20;
        addRecordBtn.centerY=todayCountView.height*.5;
        [todayCountView addSubview:addRecordBtn];
        
        
        topView.height=todayCountView.bottom;
        
        _topView=topView;
    }
    return _topView;
}
-(BanBoLineHeaderView *)makeLineHeaderView{
    BanBoLineHeaderView *lineHeader=[BanBoLineHeaderView new];

    CGFloat lineViewHeight=[BanBoLayoutParam shiminLineViewHeight];
    CGFloat lineViewLeft=20;
    
    lineHeader.bottomSeparView.left=lineViewLeft;
    lineHeader.leftLabel.left=lineViewLeft;
    lineHeader.height=lineViewHeight;
    lineHeader.left=0;
    
    return lineHeader;
}
-(CGFloat)cellHeight{
    return 34.f;
}
@end
