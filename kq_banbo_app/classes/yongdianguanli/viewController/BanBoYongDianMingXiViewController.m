//
//  BanBoYongDianMingXiViewController.m
//  kq_banbo_app
//
//  Created by banbo on 2017/4/24.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "BanBoYongDianMingXiViewController.h"
#import "YZTitleView+BanBo.h"
#import "BanBoYongDianHeaderView.h"
#import "BanBoSuSheManager.h"
#import "BanBoSuSheGlRoomModel.h"
#import "BanBoYongDianTableViewCell.h"
@interface BanBoYongDianMingXiViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)NSMutableArray <BanBoSuSheGlRoomModel *>* dataSource;

@end

@implementation BanBoYongDianMingXiViewController
{
    UITableView * _myTableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    YZTitleView *titleView=[YZTitleView banbo_inst];
    [titleView showInNaviItem:self.navigationItem];
    [self setupSubviews];
    [self getData];
    [self createTableView];
    _dataSource = [NSMutableArray array];
    NSLog(@"楼号:%@->工程ID:%@",_louhao,_projects);
    self.view.backgroundColor = BanBoViewBgGrayColor;
}
-(void)setupSubviews
{
    BanBoYongDianHeaderView * header = [[BanBoYongDianHeaderView alloc]init];
    header.top = 64;
    header.text = [NSString stringWithFormat:@"%@->%@",self.subTitle,self.louName];
    [self.view addSubview:header];
}
-(void)createTableView
{
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 130, self.view.frame.size.width, self.view.frame.size.height-130) style:UITableViewStylePlain];
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    _myTableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_myTableView];
    
}
-(void)getData
{
    [[BanBoSuSheManager sharedInstance]postAllRoomWithProject:self.projects Bid:self.louhao completion:^(id data, NSError *error) {
        
        _dataSource = [BanBoSuSheGlRoomModel mj_objectArrayWithKeyValuesArray:data];
        
        if(_dataSource.count==0)
        {
            [HCYUtil toastMsg:@"该楼暂无用电明细" inView:self.view];
        }
        [_myTableView reloadData];
        
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BanBoYongDianMingXiVC";//以indexPath来唯一确定cell
    BanBoYongDianTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell = [[BanBoYongDianTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.model = _dataSource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    view.backgroundColor=[UIColor hcy_colorWithString:@"#f0f0f0"];
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, 2, 100, 40)];
    label1.text = @"当前功率(W)";//剩余电量(度)";
    label1.textColor = [UIColor hcy_colorWithString:@"#666666"];
    label1.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label1];
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-110), 2, 120, 40)];
    label2.text = @"剩余电量(度)";//";
    label2.textColor = [UIColor hcy_colorWithString:@"#666666"];
    label2.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label2];
    return view;
}
@end
