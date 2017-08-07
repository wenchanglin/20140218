//
//  BanBoSuSheRoomVC.m
//  kq_banbo_app
//
//  Created by banbo on 2017/4/21.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "BanBoSuSheRoomVC.h"
#import "BanBoSuSheManager.h"
#import "BanBoSuSheRoomTableViewCell.h"
#import "YZTitleView+BanBo.h"
#import "BanBoSuSheImageHeaderView.h"
#import "BanBoSuSheGlRoomModel.h"
#import "BanBoShiminListItem.h"
#import "BanBoRoomFenPeiVC.h"
#import "BanBoShiMinManager.h"
@interface BanBoSuSheRoomVC ()<UITableViewDataSource,UITableViewDelegate,myTableViewDelegate>
@property(strong,nonatomic)NSMutableArray<BanBoSuSheGlRoomModel *> * dataSource;
@property(strong,nonatomic,readonly)BanBoShiminListItem *listItem;
@property(nonatomic,strong) NSNumber * groupid;
@end

@implementation BanBoSuSheRoomVC
{
    UITableView * _myTableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getData) name:@"保存分配成功" object:nil];
    YZTitleView *titleView=[YZTitleView banbo_inst];
    [titleView showInNaviItem:self.navigationItem];
    _dataSource = [NSMutableArray array];
    self.view.backgroundColor = BanBoViewBgGrayColor;
    [self setupSubviews];
    [self getData];
    [self createTableView];
    
    
}


-(void)getData
{
    [[BanBoSuSheManager sharedInstance]postAllRoomWithProject:self.projects Bid:self.louhao completion:^(id data, NSError *error) {
        _dataSource = [BanBoSuSheGlRoomModel mj_objectArrayWithKeyValuesArray:data];
        if(_dataSource.count==0)
        {
            [HCYUtil toastMsg:@"该宿舍暂无数据" inView:self.view];
        }
        [_myTableView reloadData];
    
    }];
}
-(void)setupSubviews
{
    BanBoSuSheImageHeaderView * header = [[BanBoSuSheImageHeaderView alloc]init];
    header.top = 64;
    header.text = [NSString stringWithFormat:@"%@->%@",self.subTitle,self.louName];
    [self.view addSubview:header];
}


-(void)createTableView
{
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 128, self.view.frame.size.width, self.view.frame.size.height-130)];
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    _myTableView.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:_myTableView];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BanBoSuSheRoomVC";//以indexPath来唯一确定cell
    BanBoSuSheRoomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil)
    {
        cell = [[BanBoSuSheRoomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.model = _dataSource[indexPath.row];
    cell.delegate =self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)myTableClick:(UITableViewCell *)cell
{
    NSIndexPath *index = [_myTableView indexPathForCell:cell];
    BanBoRoomFenPeiVC * fenpeiVC = [[BanBoRoomFenPeiVC alloc]init];
    fenpeiVC.louStr = self.louName;
    fenpeiVC.models = _dataSource[index.row];
    [self.navigationController pushViewController:fenpeiVC animated:YES];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}





@end
