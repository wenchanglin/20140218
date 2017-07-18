//
//  BanBoSuSGLListViewController.m
//  kq_banbo_app
//
//  Created by banbo on 2017/4/18.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "BanBoSuSGLListViewController.h"
#import "BanBoProject.h"
#import "YZTitleView+BanBo.h"
#import "BanBoSuSheImageHeaderView.h"
#import "BanBoSuSheManager.h"
#import "BanBoSuSheGuanLiModel.h"
#import "BanBoSuSheGLTableViewCell.h"
#import "BanBoSuSheGlRoomModel.h"
#import "BanBoSuSheRoomVC.h"
@interface BanBoSuSGLListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic,readonly)BanBoProject *project;
@property(strong,nonatomic,readonly)BanBoShiminListItem *listItem;
@property(strong, nonatomic)UITableView *myTableView;
@property(strong,nonatomic)NSMutableArray <BanBoSuSheGuanLiModel *>* dataSource;
@property(strong, nonatomic) NSMutableArray* bidArray; //楼号
@property(strong, nonatomic) NSMutableArray* subBidArray; //分支楼号
@property(strong, nonatomic) NSMutableArray *subFoolNameArray;//分支楼名\


@end

@implementation BanBoSuSGLListViewController
{
    NSNumber *  _bigBid;
    NSMutableArray * _sectionState;//组的状态
    
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
    _sectionState = [NSMutableArray array];
    _dataSource = [NSMutableArray array];
    _bidArray = [NSMutableArray array];
    _subBidArray = [NSMutableArray array];
    _subFoolNameArray = [NSMutableArray array];
    self.view.backgroundColor=BanBoViewBgGrayColor;
    YZTitleView *titleView=[YZTitleView banbo_inst];
    [titleView showInNaviItem:self.navigationItem];
    [self getData];
    [self createTableView];
    [self setupSubviews];
    
}
-(void)setupSubviews
{
    BanBoSuSheImageHeaderView * header = [[BanBoSuSheImageHeaderView alloc]init];
    header.top = 64;
    header.text = [NSString stringWithFormat:@"%@",self.listItem.title];
    [self.view addSubview:header];
}


-(void)createTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 128, self.view.frame.size.width, self.view.frame.size.height-130)];
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    [self.view addSubview:_myTableView];
     _myTableView.tableFooterView=[[UIView alloc]init];
}
-(void)getData
{
    [[BanBoSuSheManager sharedInstance]postAllDormCountWithProject:self.project.projectId completion:^(id data, NSError *error) {
        _dataSource = [BanBoSuSheGuanLiModel mj_objectArrayWithKeyValuesArray:data];
        if(_dataSource.count==0)
        {
            [HCYUtil toastMsg:@"该工地暂无宿舍楼" inView:self.view];
        }

        [_myTableView reloadData];
    }];
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
    if (cell==nil)
    {
        cell = [[BanBoSuSheGLTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    [cell.arrowButton setTitle:[NSString stringWithFormat:@"%zd",indexPath.row+1] forState:UIControlStateNormal];
    cell.model = _dataSource[indexPath.row];//model;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BanBoSuSheRoomVC * room = [[BanBoSuSheRoomVC alloc]init];
    room.louhao  =_dataSource[indexPath.row].bid;
    room.subTitle = self.listItem.title;
    room.louName = _dataSource[indexPath.row].buildname;
    room.projects = self.project.projectId;
    [self.navigationController pushViewController:room animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
@end
