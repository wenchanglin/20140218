//
//  BanBoYongDianGLViewController.m
//  kq_banbo_app
//
//  Created by banbo on 2017/4/24.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "BanBoYongDianGLViewController.h"
#import "YZTitleView+BanBo.h"
#import "BanBoYongDianHeaderView.h"
#import "BanBoSuSheManager.h"
#import "BanBoSuSheGuanLiModel.h"
#import "BanBoSuSheGLTableViewCell.h"
#import "BanBoYongDianMingXiViewController.h"
@interface BanBoYongDianGLViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)BanBoProject * project;
@property(strong,nonatomic,readonly)BanBoShiminListItem *listItem;
@property(strong, nonatomic)UITableView *myTableView;
@property(strong,nonatomic)NSMutableArray <BanBoSuSheGuanLiModel *>* dataSource;
@end

@implementation BanBoYongDianGLViewController
-(instancetype)initWithListItem:(BanBoShiminListItem *)item project:(BanBoProject *)project{
    if (self=[super init]) {
        _project=project;
        _listItem = item;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=BanBoViewBgGrayColor;
    _dataSource = [NSMutableArray array];
    //标题
    YZTitleView * titleView = [YZTitleView banbo_inst];
    [titleView showInNaviItem:self.navigationItem];
    [self getData];
    [self createTableView];
    [self setupsubviews];
}

-(void)getData
{
    [[BanBoSuSheManager sharedInstance]postAllDormCountWithProject:self.project.projectId completion:^(id data, NSError *error) {
        _dataSource = [BanBoSuSheGuanLiModel mj_objectArrayWithKeyValuesArray:data];
        if(_dataSource.count==0)
        {
            [HCYUtil toastMsg:@"该工地暂无宿舍楼用电明细" inView:self.view];
        }
        [_myTableView reloadData];
    }];

}
-(void)createTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 128, self.view.frame.size.width, self.view.frame.size.height-130)];
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    _myTableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_myTableView];
}
-(void)setupsubviews
{
    BanBoYongDianHeaderView * header = [[BanBoYongDianHeaderView alloc]init];
    header.top = 64;
    header.text = [NSString stringWithFormat:@"%@",self.listItem.title];
    [self.view addSubview:header];
}
#pragma mark - datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BanBoSuSGLListVC";
    BanBoSuSheGLTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[BanBoSuSheGLTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    [cell.arrowButton setTitle:[NSString stringWithFormat:@"%zd",indexPath.row+1] forState:UIControlStateNormal];
    cell.model = _dataSource[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BanBoYongDianMingXiViewController * minxi = [[BanBoYongDianMingXiViewController alloc]init];
    minxi.louhao = _dataSource[indexPath.row].bid;
    minxi.subTitle = self.listItem.title;
    minxi.louName = _dataSource[indexPath.row].buildname;
    minxi.projects = self.project.projectId;
    [self.navigationController pushViewController:minxi animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
@end
