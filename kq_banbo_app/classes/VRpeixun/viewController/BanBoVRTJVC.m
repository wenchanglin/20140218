//
//  BanBoVRTJVC.m
//  kq_banbo_app
//
//  Created by banbo on 2017/6/23.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "BanBoVRTJVC.h"
#import "BanBoVRImageHeaderView.h"
#import "BanBoVRTJCell.h"
#import "BanBoVRManager.h"
#import "BanBoVRTongJiModel.h"
@interface BanBoVRTJVC()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic,readonly)BanBoProject *project;
@property(strong,nonatomic,readonly)BanBoShiminListItem *listItem;
@property(nonatomic,strong)BanBoVRImageHeaderView * header;
@property(nonatomic,strong) NSMutableArray * dataSource;
@end
@implementation BanBoVRTJVC
{
    UITableView * _tableViews;
    
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
    _dataSource = [NSMutableArray array];
    self.title = @"VR虚拟与现实安全教育";
    self.view.backgroundColor = [UIColor hcy_colorWithString:@"#f7f7f7"];
    [self setupSubviews];
    [self readyDetail];
    [self addData];

}

- (void)addData
{
    [[BanBoVRManager sharedInstance]postVRTongJiWithProjectId:self.project.projectId completion:^(id data, NSNumber *allrow, NSError *error) {
        BanBoVRTongJiModel * model = [BanBoVRTongJiModel mj_objectWithKeyValues:data];
        [_dataSource addObject:model];
        [_tableViews reloadData];
    }];
   
    
}

-(void)setupSubviews
{
    _header = [[BanBoVRImageHeaderView alloc]init];
    _header.top = 64;
    _header.text = [NSString stringWithFormat:@"%@",self.listItem.title];
    [self.view addSubview:_header];
}
-(void)readyDetail
{
    _tableViews = [[UITableView alloc]initWithFrame:CGRectMake(0, _header.bottom, SCREEN_WIDTH, SCREEN_HEIGHT-_header.bottom-10) style:UITableViewStylePlain];
    _tableViews.delegate = self;
    _tableViews.dataSource = self;
    _tableViews.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableViews];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BanBoVRTongJiModel * models = _dataSource[indexPath.row];
    static NSString * cellssssf =  @"VRTJCell";
     BanBoVRTJCell * cell = [tableView dequeueReusableCellWithIdentifier:cellssssf];
    if (cell==nil) {
        cell  =[[BanBoVRTJCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellssssf];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setDataWithModel:models];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 41;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 41)];
    view.backgroundColor = [UIColor hcy_colorWithString:@"#ededed"];
    UIView * oneview = [[UIView alloc]initWithFrame:CGRectMake(0, 1, SCREEN_WIDTH, 1)];
    oneview.backgroundColor = [UIColor hcy_colorWithString:@"#e0e0e0"];
    [view addSubview:oneview];
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 1, 80, 40)];
    label1.text = @"班组名称";
    label1.textColor = [UIColor hcy_colorWithString:@"#333333"];
    label1.font =[YZLabelFactory normal14Font];
    label1.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label1];
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-110)/2, 1, 100, 40)];
    label2.text = @"当前班组人数";//";
    label2.font =[YZLabelFactory normal14Font];
    label2.textColor = [UIColor hcy_colorWithString:@"#333333"];
    label2.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label2];
    UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-110, 1, 100, 40)];
    label3.text = @"通过关卡人数";//";
    label3.font =[YZLabelFactory normal14Font];
    label3.textColor = [UIColor hcy_colorWithString:@"#333333"];
    label3.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label3];
    UIView * twoview = [[UIView alloc]initWithFrame:CGRectMake(0, 41, SCREEN_WIDTH, 1)];
    twoview.backgroundColor = [UIColor hcy_colorWithString:@"#e0e0e0"];
    [view addSubview:twoview];
    return view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
