//
//  BanBoShiMinItemListViewController.m
//  kq_banbo_app
//
//  Created by hcy on 2016/12/5.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoShiMinItemListViewController.h"
#import "BanBoShiMinHeaderView.h"
#import "BanBoShiminListItem.h"
#import "BanBoProject.h"
#import "BanBoShiminDetail.h"
#import "YZTitleView+BanBo.h"

@interface BanBoShiMinItemListViewController ()<BanBoShiminHeaderViewDelegate>

@property(strong,nonatomic)BanBoShiMinHeaderView *headerView;
@end

@implementation BanBoShiMinItemListViewController

-(instancetype)initWithListItem:(BanBoShiminListItem *)item project:(BanBoProject *)project{
    if (self=[super init]) {
        _listItem=item;
        _project=project;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupColumnHeader];
    YZTitleView *titleView=[YZTitleView banbo_inst];
    [titleView showInNaviItem:self.navigationItem];
    [self.headerView setHeaderText:[self pageTitle]];
    [self refreshPersonCount];
    self.dataCollection.groupMemberComparator=^NSComparisonResult(id obj1,id obj2){
        return NSOrderedSame;
    };
    [self refreshData:NO];
}
-(void)setupColumnHeader{
    
    if(self.listItem.tag==BanBoShiminTypeJKGL){
        self.listItem.tag=BanBoShiminTypeGRMC;
    }
    BanBoColumnHeader *header=[[self columnHeaderDict] objectForKey:@(self.listItem.tag)];
    if (header) {
        HCYColumnLayoutManager *columnManager=[[HCYColumnLayoutManager alloc] initWithColumnCount:header.titles.count tableView:[self dataTableView]];
        columnManager.tableViewEdge=UIEdgeInsetsMake(0, 10, 0, 10);
        _columnHeader=header;
        [columnManager refreshHeader:header];
        self.columnLayoutManager=columnManager;
        
        self.tableViewDataArrM=[NSMutableArray array];
        [self.tableViewDataArrM addObject:header];
        [super setDataCollectionAndReloadTableView];
    }
}
-(NSString *)pageTitle{
    return [NSString stringWithFormat:@"%@%@",self.project.name,self.listItem.title];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if([self.view isFirstResponder]==NO){
        [self.view endEditing:YES];
    }
}
-(void)onCellCreated:(BanboColumnCell *)cell indexPath:(NSIndexPath *)indexPath{
    if ([cell isKindOfClass:[BanboMutLabelColumnCell class]]) {
        BanboMutLabelColumnCell *mutCell=(BanboMutLabelColumnCell *)cell;
        [mutCell createLabelWithCount:self.columnHeader.titles.count font:[UIFont systemFontOfSize:12.f] colorDict:[self currentColorDict]];
    }
    [super onCellCreated:cell indexPath:indexPath];
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}
-(UIColor *)bgColorForCellAtIndexPath:(NSIndexPath *)path{
    if (path.row==0) {
        return BanBoShiminYellowColor;
    }
    return [UIColor whiteColor];
}
-(BanBoShiMinHeaderView *)headerView{
    if (!_headerView) {
        BanBoShiMinHeaderView *header=[[BanBoShiMinHeaderView alloc] initWithItem:self.listItem projectName:@""];
        _headerView=header;
        header.delegate=self;
        header.top=64;
        header.width=self.view.width;
    }
    return _headerView;
}

#pragma mark headerDelegate
-(void)headerViewConditionChanged:(BanBoShiMinHeaderView *)headerView{
    [self refreshPersonCount];
    [self refreshData:NO];
}
-(void)headerViewSearchBtnClicked:(BanBoShiMinHeaderView *)headerView{
    [self refreshPersonCount];
    [self refreshData:NO];
}
#pragma mark refresh
-(void)refreshData:(BOOL)isBottom{
    __weak typeof(self) wself=self;
    self.view.userInteractionEnabled=NO;
    [HCYUtil showProgressWithStr:@"正在请求数据"];

    BanboShiminRequestParam *param=[self param:isBottom];
    [[BanBoShiMinManager sharedInstance] getDataForType:self.listItem.tag param:param completion:^(NSArray* data, NSError *error) {
        if (!wself) {
            return ;
        }
        dispatch_async_main_safe((^{
            self.view.userInteractionEnabled=YES;
            [HCYUtil dismissProgress];
            if ([wself isNoCondition] && data.count==param.limit){
                [super setBottomRefreshType:BanboRefreshBottomTypeNeed];
            }else{
                [super setBottomRefreshType:BanboRefreshBottomTypeNone];
            }
            
            if (isBottom) {
                BOOL haveMoreData=data.count>=param.limit;
                [super endFooterRefreshWithType:haveMoreData?BanboEndRefreshTypeNormal:BanboEndRefreshTypeNoMoreData];
            }
            
            if (error) {
                [HCYUtil showError:error];
            }else{
                [self reloadTableView:data isAppend:isBottom];
            }
        }));
    }];
}
-(void)getMoreData:(id)refreshFooter{
    [self refreshData:YES];
}
-(void)refreshPersonCount{
    __weak typeof(self) wself=self;
    [[BanBoShiMinManager sharedInstance] getPersonCountWithParam:[self param:NO] completion:^(id data, NSError *error) {
        if (!wself) {
            return ;
        }
        dispatch_async_main_safe((^{
            if (error) {
                [HCYUtil showError:error];
            }else{
                if ([data isKindOfClass:[NSNumber class]]) {
                    NSNumber *num=(NSNumber *)data;
                    [wself.headerView setHeaderText:[NSString stringWithFormat:@"%@(%ld)",[wself pageTitle],[num longValue]]];
                }
            }
        }));
    }];
}
-(void)reloadTableView:(NSArray *)data isAppend:(BOOL)isAppend{
    
    NSMutableArray *cellObjArrM=[NSMutableArray array];
    NSInteger idx=isAppend?self.tableViewDataArrM.count:1;
    for (BanBoShiminUser *user in data) {
        BanboShiminUserCellObj *cellObj=[BanboShiminUserCellObj new];
        cellObj.xuhao=idx++;
        cellObj.cellClass=@"BanboMutLabelColumnCell";
        cellObj.cellHeight=[self cellHeight];
        cellObj.user=user;
        cellObj.type=self.listItem.tag;
        cellObj.customReuseId=[NSString stringWithFormat:@"%ld",self.listItem.tag];
        [cellObjArrM addObject:cellObj];
        
    }
    [self.columnLayoutManager addModels:cellObjArrM];
    if (isAppend) {
        [self.tableViewDataArrM addObjectsFromArray:cellObjArrM];
    }else{
        NSMutableArray *arrM=[NSMutableArray array];
        [arrM addObject:self.columnHeader];
        if (cellObjArrM.count) {
            [arrM addObjectsFromArray:cellObjArrM];
        }
         self.tableViewDataArrM=arrM;
    }
    self.dataTableView.userInteractionEnabled=NO;
    [super setDataCollectionAndReloadTableView];
    self.dataTableView.userInteractionEnabled=YES;
    
    
}
#pragma mark param
-(BOOL)isNoCondition{
    BOOL result= self.headerView.banzhuItem==nil;
    return result;
}
-(UIView *)topView{
    return self.headerView;
}
-(CGRect)banbo_dataTableFrame{
    UIView *topView=[self topView];
    
    CGFloat y=topView.bottom+10;
    return CGRectMake(0,y, self.view.width, self.view.height-y);
}
static NSDictionary *headerDict;
-(NSDictionary *)columnHeaderDict{
    if (!headerDict) {
        headerDict=@{@(BanBoShiminTypeGZLB):[BanBoColumnHeaderMaker gzlbHeader],
                     @(BanBoShiminTypeGRMC):[BanBoColumnHeaderMaker grmcHeader],
                     @(BanBoShiminTypeXXGL):[BanBoColumnHeaderMaker xxglHeader],
                     @(BanBoShiminTypeKQGL):[BanBoColumnHeaderMaker kqglHeader],
                     @(BanBoShiminTypeYHKH):[BanBoColumnHeaderMaker yhkhHeader],
                     @(BanBoShiminTypeJKGL):[BanBoColumnHeaderMaker healthHeader]};
    }
    
    return headerDict;
}

-(BanboShiminRequestParam *)param:(BOOL)isBottom{
    BanBoBanzhuItem *banzhu=self.headerView.banzhuItem;
    BanBoBanzhuItem *xiaobanzhu=self.headerView.xiaobanzhuItem;
    NSString *user=[self.headerView userText];
    NSLog(@"搜索内容:%@",user);
    BanboShiminRequestParam *param=[BanboShiminRequestParam new];
    if (banzhu) {
        param.banzhu=@(banzhu.groupid);
    }
    if (xiaobanzhu) {
        param.xiaobanzhu=@(xiaobanzhu.groupid);
    }
    //选择的话求全部请求
    if(banzhu || xiaobanzhu){
        param.limit=10000;
    }else{
        param.limit=20;
    }
    if (user.length) {
        param.user=user;
    }
    if(isBottom){
        param.start=MAX(0, self.tableViewDataArrM.count-1);
    }
    return  param;
}
-(NSDictionary *)currentColorDict{
    static NSMutableDictionary *dict;
    dict=[NSMutableDictionary dictionary];
    for (NSInteger i=0; i<10;i++) {
        [dict setObject:BanboHomeLabelColor forKey:@(i)];
    }
    return [dict copy];
}

-(CGFloat)cellHeight{
    return 34;
}

@end
