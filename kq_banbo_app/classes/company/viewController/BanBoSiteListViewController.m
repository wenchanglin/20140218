//
//  BanBoCompanyListViewController.m
//  kq_banbo_app
//
//  Created by hcy on 2016/11/28.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoSiteListViewController.h"
#import "BanBoCompanyInfoView.h"
#import "YZTitleView+BanBo.h"
#import "BanBoHomeManager.h"
#import "BanBoUserInfoManager.h"
#import "BanBoProject.h"
#import "BanBoProjectMainViewController.h"
@interface BanBoSiteListViewController ()
@property(strong,nonatomic)YZColorTextLabel *todayCountLabel;
@property(strong,nonatomic)YZColorTextLabel *yesterDayCountLabel;

@property(strong,nonatomic)BanBoCompanyInfoView *companyInfoView;

@property(strong,nonatomic)NSMutableArray *tableViewDataArrM;
@property(strong,nonatomic)YZDataCollection *dataCollection;
@end
#define todayDefaultText NSLocalizedString(@"当日刷卡总人数:", nil)
#define yestDefaultText NSLocalizedString(@"昨日刷卡总人数:", nil)
@implementation BanBoSiteListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableViewDataArrM=[NSMutableArray array];
    [self setSubviews];
    [self setData];
    
}
-(void)setSubviews{
    [self.view addSubview:self.companyInfoView];
    self.dataTableView.backgroundColor=[UIColor clearColor];
}
-(void)setData{
    YZTitleView *titleView=[YZTitleView banbo_inst];
    [titleView showInNaviItem:self.navigationItem];
    
    BanBoLoginInfoModel *info=[[BanBoUserInfoManager sharedInstance] currentLoginInfo];
    self.companyInfoView.companyName=info.subtitle;
    BanBoUser *user=info.user;
    NSNumber *conId=@(user.contractorid);
    __weak typeof(self) wself=self;
    [[BanBoHomeManager sharedInstance] getCompanyTotalInfoWithGroupId:conId completion:^(id data, NSError *error) {
        if (!wself) {
            return ;
        }
        dispatch_async_main_safe(^{
            if (error) {
                [HCYUtil showError:error];
            }else{
                [wself refreshInfoViewWithData:data];
            }
        });
    }];
    [self getDetailWithConId:conId completion:^(id data, NSError *error) {
        [wself refreshTableViewWithData:data];
    }];
}
#pragma mark UI
-(void)refreshInfoViewWithData:(BanBoCompanyTotal *)data{
    
    [self.yesterDayCountLabel refreshWithText:yestDefaultText Val:[NSString stringWithFormat:@"%ld",(long)data.TotalCheckYestoday]  valColor:BanBoBlueColor];
    [self.todayCountLabel refreshWithText:todayDefaultText Val:[NSString stringWithFormat:@"%ld",(long)data.TotalCheckToday] valColor:BanBoRedColor];
    
}
-(void)refreshTableViewWithData:(BanBoHomeDetail *)detailData{
    BanBoHomeDetailInfoTotal *total=detailData.totalInfo;
    if (total) {
        BanBoCompanyInfoView *infoView= self.companyInfoView;
        infoView.projectCount=total.TotalClient;
        infoView.deviceCount=total.DeviceProperly;
        infoView.kaoqinCount=total.CheckProperly;
    }
    
    NSArray *subInfo=[detailData subInfo];
    if (subInfo.count) {
        if (self.tableViewDataArrM.count) {
            
        }else{
            [self appendObjects:[self viewModelWithData:subInfo] fromIdx:1];
            [self reloadTableView];
        }
    }
}


-(NSArray *)viewModelWithData:(NSArray *)data{
    NSMutableArray *viewDataArrM=[NSMutableArray array];
    for (BanBoHomeDetailInfoBase *detailSub in data) {
        BanBoHomeDetailInfoCellObj *viewModel=[[BanBoHomeDetailInfoCellObj alloc] initWithModel:detailSub];
        [viewDataArrM addObject:viewModel];
    }
    return [viewDataArrM copy];
}
-(void)reloadTableView{
    self.dataCollection.members=[self.tableViewDataArrM copy];
    [super setDataWithGroupedCollection:self.dataCollection];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark tableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BanBoHomeDetailInfoCellObj *viewData=self.tableViewDataArrM[indexPath.row];
    id data=viewData.data;
    if ([data isKindOfClass:[BanBoHomeDetailInfoSubCompany class]]) {
        if ([viewData isOpen]) {
            [self removeProjectsForData:data];
            viewData.open=NO;
        }else{
            viewData.open=YES;
            [self getProjectForSubCompany:data model:viewData];
        }
       
    }else{
        [self gotoProjectPage:data];
    }
}
-(void)removeProjectsForData:(BanBoHomeDetailInfoSubCompany *)company{
    NSMutableArray *needRemoveArr=[NSMutableArray array];
    for (BanBoHomeDetailInfoCellObj *cellObj in self.tableViewDataArrM) {
        if ([cellObj.data isKindOfClass:[BanBoHomeDetailInfoProject class]]) {
            BanBoHomeDetailInfoProject *project=(BanBoHomeDetailInfoProject *)cellObj.data;
            if (project.ContractorId==company.ContractorId) {
                [needRemoveArr addObject:cellObj];
            }
        }
    }
    if (needRemoveArr.count) {
        [self.tableViewDataArrM removeObjectsInArray:needRemoveArr];
        [self resetSortNum];
        [self reloadTableView];
    }
}

-(void)getProjectForSubCompany:(BanBoHomeDetailInfoSubCompany *)company model:(BanBoCompanyInfoView *)cellObj{
    __weak typeof(self) wself=self;
    [self getDetailWithConId:@(company.ContractorId) completion:^(BanBoHomeDetail* data, NSError *error) {
        NSInteger idx=[self.tableViewDataArrM indexOfObject:cellObj];
        [wself appendObjects:[self viewModelWithData:data.subInfo] fromIdx:idx+1];
        [wself reloadTableView];
    }];
}
-(void)gotoProjectPage:(BanBoHomeDetailInfoProject *)project{
    BanBoProject *projectObj=[BanBoProject new];
    projectObj.projectId=@(project.ClientId);
    projectObj.name=[[BanBoHomeManager sharedInstance] projectNameById:projectObj.projectId];
    BanBoProjectMainViewController *projectVC=[[BanBoProjectMainViewController alloc] initWithProject:projectObj];
    [self.navigationController pushViewController:projectVC animated:YES];
}
#pragma mark func
-(void)resetSortNum{
    NSInteger i=0;
    for (BanBoHomeDetailInfoCellObj *view in self.tableViewDataArrM) {
        view.sortNum=++i;
    }
}
-(void)getDetailWithConId:(NSNumber *)contraId completion:(BanBoHomeManagerCompletionBlock)completion{
    
    __weak typeof(self) wself=self;
    
    [[BanBoHomeManager sharedInstance] getCompanyDetailInfoWithGroupId:contraId start:0 limit:10000 completion:^(id data, NSError *error) {
        if (!wself) {
            return ;
        }
        dispatch_async_main_safe(^{
            if (error) {
                [HCYUtil showError:error];
            }else{
                if (completion) {
                    completion(data,nil);
                }
            }
        });
    }];
    
}
-(void)appendObjects:(NSArray *)objects fromIdx:(NSInteger)idx{
    for (BanBoHomeDetailInfoCellObj *viewM in objects) {
        if ([self.tableViewDataArrM containsObject:viewM]) {
            continue;
        }
        
        if (self.tableViewDataArrM.count) {
            [self.tableViewDataArrM insertObject:viewM atIndex:idx++];
        }else{
            [self.tableViewDataArrM addObject:viewM];
        }
    }
    [self resetSortNum];
}
#pragma mark viewLazyLoad
-(BanBoCompanyInfoView *)companyInfoView{
    if (!_companyInfoView) {
        BanBoCompanyInfoView *infoView=[[BanBoCompanyInfoView alloc] initWithFrame:CGRectMake(10, self.topView.bottom+10, self.view.width-20, 111)];
        _companyInfoView=infoView;
    }
    return _companyInfoView;
}

#pragma mark overwrite super
@synthesize topView=_topView;
-(UIView *)topView{
    if (!_topView) {
        CGFloat labelMargin=[BanBoLayoutParam homeColorLabelMarginCenter];
        
        UIView *topView=[[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, 27)];
        topView.backgroundColor=[UIColor whiteColor];
        
        YZColorTextLabel *todayCountLabel=[YZLabelFactory grayColorLabel];
        
        todayCountLabel.textAlignment=NSTextAlignmentRight;
        todayCountLabel.text=todayDefaultText;
        todayCountLabel.width=topView.width*.5-labelMargin;;
        todayCountLabel.height=topView.height;
        todayCountLabel.autoresizingMask=(UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin);
        [topView addSubview:todayCountLabel];
        _topView=topView;
        self.todayCountLabel=todayCountLabel;
        
        YZColorTextLabel *yest=[YZLabelFactory grayColorLabel];
        
        yest.textAlignment=NSTextAlignmentLeft;
        yest.text=yestDefaultText;
        yest.left=topView.width*.5+labelMargin;
        yest.width=todayCountLabel.width;
        yest.height=topView.height;
        
        [topView addSubview:yest];
        yest.autoresizingMask=(UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleHeight);
        
        self.yesterDayCountLabel=yest;
        
        _topView=topView;
    }
    return _topView;
}
-(CGRect)banbo_dataTableFrame{
    CGFloat leftMargin=10;
    CGFloat top=self.companyInfoView.bottom;
    return CGRectMake(leftMargin, top, self.view.width-leftMargin*2, self.view.height-top);
}
-(YZDataCollection *)dataCollection{
    if (!_dataCollection) {
        YZDataCollection *collection=[YZDataCollection new];
        collection.groupTitleComparator=[collection sameGroupTitleCompartor];
        collection.groupMemberComparator=^NSComparisonResult(NSNumber *n1,NSNumber *n2){
//            return [n1 integerValue]>[n2 integerValue];
            return NSOrderedSame;
        };
        _dataCollection=collection;
        
    }
    return _dataCollection;
}


@end
