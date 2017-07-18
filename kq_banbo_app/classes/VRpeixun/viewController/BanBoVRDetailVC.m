//
//  BanBoVRDetailVC.m
//  kq_banbo_app
//
//  Created by banbo on 2017/6/23.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "BanBoVRDetailVC.h"
#import "BanBoVRCondiView.h"
#import "BanBoPeiXunHeaderView.h"
#import "BanBoVRDetailHeaderView.h"
#import "BanBoShiminDetail.h"
#import "BanBoVRXQYSubTVCell.h"
#import "BanBoVRManager.h"
#import "BanBoVRXiangQingModel.h"
#import "BanBoVRListPeiXunCell.h"
#import "UIScrollView+KS.h"
#import "BanBoVRXQYTwoJiVC.h"
@interface BanBoVRDetailVC ()<BanBoPeiXunHeaderViewDelegate,UITableViewDelegate,UITableViewDataSource,KSRefreshViewDelegate,VRTableViewDelegate>
@property(nonatomic,strong)BanBoPeiXunHeaderView * headerView;
@property(nonatomic,strong)BanBoVRDetailHeaderView * header;
@property(nonatomic,strong)UITableView * VRDetailTableView;
@property(nonatomic,strong)NSMutableArray * DataSource;
@property(nonatomic,strong)NSNumber * rowSource;

@end

@implementation BanBoVRDetailVC
{
    NSInteger  _page;
    NSInteger _searchPage;
    BOOL isSearchdata;
    BOOL isCondition;
    BOOL isSearch;
}
-(instancetype)initWithListItem:(BanBoShiminListItem *)item project:(BanBoProject *)project{
    if (self=[super init]) {
        _project=project;
        _listItem = item;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"VR虚拟与现实安全教育";
    self.view.backgroundColor = [UIColor hcy_colorWithString:@"#f0f0f0"];
    _DataSource = [NSMutableArray array];
    _page = 1;
    _searchPage = 1;
    [self setupSubviews];
    [self requestData];
    [self createUI];
}
-(void)createUI
{
    UIView *topView=[self topView];
    CGFloat y=topView.bottom+10;
    _VRDetailTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,y, self.view.width, self.view.height-y) style:UITableViewStylePlain];
    _VRDetailTableView.delegate =self;
    _VRDetailTableView.dataSource =self;
    _VRDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _VRDetailTableView.tableFooterView = [[UIView alloc]init];
    _VRDetailTableView.footer = [[KSAutoFootRefreshView alloc]initWithDelegate:self];
    [self.view addSubview:_VRDetailTableView];
}
-(void)requestData
{    isSearchdata = NO;
    NSDictionary * param = @{@"clientid":self.project.projectId,@"page":[NSString stringWithFormat:@"%zd",_page]};
    [[BanBoVRManager sharedInstance]postVRXiangQingWithParameter:param completion:^(id data,NSNumber * allrow, NSError *error) {
        if ([data isEqual:@{}]) {
            [_VRDetailTableView reloadData];
            return ;
        }
        else
        {
        BanBoVRXiangQingModel * model = [BanBoVRXiangQingModel mj_objectWithKeyValues:data];
        _rowSource = allrow;
        [_DataSource addObject:model];
        [_VRDetailTableView reloadData];
        }
    }];
}
-(void)setupSubviews
{
    
    BanBoPeiXunHeaderView *header=[[BanBoPeiXunHeaderView alloc] initWithItem:self.listItem projectName:self.listItem.title];
    _headerView=header;
    header.delegate=self;
    header.top=64;
    header.width=self.view.width;
    [self.view addSubview:_headerView];
}

-(void)refreshViewDidLoading:(id)view
{
    if ([view isEqual:_VRDetailTableView.footer]) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (_DataSource.count >= 1500) {
                //如果没有可加载的数据,需要将footer的isLastPage属性设置为YES,这样就不会出发底部刷新了
                [_VRDetailTableView.footer setIsLastPage:YES];
                [_VRDetailTableView reloadData];
            } else {
                if (isSearchdata==YES) {
                    _searchPage++;
                    BanBoBanzhuItem *banzhu=self.headerView.banzhuItem;
                    BanBoBanzhuItem *xiaobanzhu=self.headerView.xiaobanzhuItem;
                    NSDictionary * param = @{@"clientid":self.project.projectId,@"fatherid":@(banzhu.groupid),@"username":[self.headerView userText],@"groupid":@(xiaobanzhu.groupid),@"page":[NSString stringWithFormat:@"%zd",_searchPage]};
                    [self requestxialaData:param];
                    [_VRDetailTableView footerFinishedLoading];
                    [_VRDetailTableView reloadData];
                    return;
                }
                else if(isSearchdata==NO)
                {
                    
                    _page++;
                    [self requestData];
                    [_VRDetailTableView footerFinishedLoading];
                    [_VRDetailTableView reloadData];
                }
                
            }
        });
    }
}
-(void)requestxialaData:(NSDictionary *)param
{
    [[BanBoVRManager sharedInstance]postVRXiangQingWithParameter:param completion:^(id data,NSNumber * allrow, NSError *error) {
        if ([data isEqual:@{}]) {
            [_VRDetailTableView reloadData];
            return ;
        }
        else
        {
        BanBoVRXiangQingModel * model = [BanBoVRXiangQingModel mj_objectWithKeyValues:data];
        _rowSource = allrow;
        [_DataSource addObject:model];
        [_VRDetailTableView reloadData];
        }
    }];
}
#pragma mark - headerview delegate
-(void)headerViewConditionChanged:(BanBoPeiXunHeaderView *)headerView
{
    isCondition = YES;
    _searchPage = 1;
    if (_DataSource.count>0) {
        [_DataSource removeAllObjects];
    }
    
    BanBoBanzhuItem *banzhu=headerView.banzhuItem;
    BanBoBanzhuItem *xiaobanzhu=headerView.xiaobanzhuItem;
    NSDictionary * param = @{@"clientid":self.project.projectId,@"fatherid":@(banzhu.groupid),@"username":[self.headerView userText],@"groupid":@(xiaobanzhu.groupid),@"page":[NSString stringWithFormat:@"%zd",_searchPage]};
    [self refreshData:param];
}
-(void)headerViewSearchBtnClicked:(BanBoPeiXunHeaderView *)headerView
{
    isSearch = YES;
    _searchPage = 1;
    BanBoBanzhuItem *banzhu=headerView.banzhuItem;
    BanBoBanzhuItem *xiaobanzhu=headerView.xiaobanzhuItem;
    if(_DataSource.count>0)
    {
        [_DataSource removeAllObjects];
    }
    NSDictionary * param = @{@"clientid":self.project.projectId,@"fatherid":@(banzhu.groupid),@"username":[self.headerView userText],@"groupid":@(xiaobanzhu.groupid),@"page":[NSString stringWithFormat:@"%zd",_searchPage]};
    [self refreshData:param];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BanBoVRXiangQingModel * model = _DataSource[indexPath.row];
    static NSString * scell  = @"vrDetailCell";
    BanBoVRListPeiXunCell * cell = [tableView dequeueReusableCellWithIdentifier:scell];
    if (cell ==nil) {
        cell = [[BanBoVRListPeiXunCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:scell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.xuhaoLabel.text = [NSString stringWithFormat:@"%zd",indexPath.row+1];
    [cell setDataWithModel:model];
    return cell;
}
-(void)VRTableClick:(UITableViewCell *)cell
{
    NSIndexPath * index = [_VRDetailTableView indexPathForCell:cell];
    BanBoVRXiangQingModel * models = _DataSource[index.row];
    BanBoVRXQYTwoJiVC * vc = [[BanBoVRXQYTwoJiVC alloc]initwithProject:self.project withgonghao:models.currWorkNo];
    vc.xiaomodel = models;
    [self.navigationController pushViewController:vc animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _DataSource.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 41;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 41)];
    UIView * oneview = [[UIView alloc]initWithFrame:CGRectMake(0, 1, SCREEN_WIDTH, 1)];
    oneview.backgroundColor = [UIColor hcy_colorWithString:@"#e0e0e0"];
    [view addSubview:oneview];
    float x = 0;
    float w = SCREEN_WIDTH/6;
    NSArray * array  = @[@"序号",@"工号",@"姓名",@"通关",@"未通关",@"查看"];
    for (int i=0; i<6; i++) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(w*i+x, 0, w, 40)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor hcy_colorWithString:@"#333333"];
        label.font = [YZLabelFactory normal14Font];
        label.text = array[i];
        [view addSubview:label];
    }
    view.backgroundColor = [UIColor hcy_colorWithString:@"#ededed"];
    UIView * twoview = [[UIView alloc]initWithFrame:CGRectMake(0, 41, SCREEN_WIDTH, 1)];
    twoview.backgroundColor = [UIColor hcy_colorWithString:@"#e0e0e0"];
    [view addSubview:twoview];
    return view;
}
#pragma mark refresh
-(void)refreshData:(NSDictionary *)parames{
    isSearchdata = YES;
    [[BanBoVRManager sharedInstance]postVRXiangQingWithParameter:parames completion:^(id data,NSNumber * allrow,NSError *error) {
        _VRDetailTableView.hidden = NO;
        if ([data isEqual:@{}]) {
            [_VRDetailTableView reloadData];
            return ;
        }
        else
        {
            BanBoVRXiangQingModel * model = [BanBoVRXiangQingModel mj_objectWithKeyValues:data];
            _rowSource = allrow;
            [_DataSource addObject:model];
            [_VRDetailTableView reloadData];
        }
    }];
}

-(UIView *)topView{
    return self.headerView;
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
