//
//  BanBoVRXQYTwoJiVC.m
//  kq_banbo_app
//
//  Created by banbo on 2017/6/28.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "BanBoVRXQYTwoJiVC.h"
#import "BanBoVRXQYSubTVCell.h"
#import "BanBoVRManager.h"
#import "BanBoVRChaKanModel.h"
@interface BanBoVRXQYTwoJiVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)BanBoProject * project;
@property(nonatomic,strong)NSNumber * gonghao;
@end

@implementation BanBoVRXQYTwoJiVC
{
    UITableView * _subTabelView;
    NSMutableArray * _dataSource;
}
-(instancetype)initwithProject:(BanBoProject *)project withgonghao:(NSNumber *)gonghao
{
    if (self == [super init]) {
        self.project = project;
        self.gonghao = gonghao;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [NSMutableArray array];
    self.title = @"VR虚拟与现实安全教育";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createUI];
     [self requestData];
}
-(void)requestData
{
    NSDictionary * parameter = @{@"clientid":self.project.projectId,@"currworkno":self.gonghao};
    [[BanBoVRManager sharedInstance]postVRXiangqingSubWithParameter:parameter completion:^(id data, NSNumber *allrow, NSError *error) {
        BanBoVRChaKanModel * model = [BanBoVRChaKanModel mj_objectWithKeyValues:data];
        [_dataSource addObject:model];
        [_subTabelView reloadData];
    }];
    
}
-(void)createUI
{
    _subTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _subTabelView.delegate = self;
    _subTabelView.dataSource = self;
    _subTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _subTabelView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_subTabelView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    return _dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 174;
    }
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }
    else
        return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return nil;
    }
    else
    {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 41)];
        UIView * oneview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        oneview.backgroundColor = [UIColor hcy_colorWithString:@"#e0e0e0"];
        [view addSubview:oneview];
        float x = 0;
        float w = SCREEN_WIDTH/4;
        NSArray * array  = @[@"关卡序号",@"关卡信息",@"是否通过",@"培训时间"];
        for (int i=0; i<3; i++) {
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(w*i+x, 0, w, 40)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [YZLabelFactory normal14Font];
            label.text = array[i];
            [view addSubview:label];
        }
        UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(w*3-5, 0, w, 40)];
        label1.textAlignment = NSTextAlignmentCenter;
        label1.font = [YZLabelFactory normal14Font];
        label1.text = array[3];
        [view addSubview:label1];
        view.backgroundColor = [UIColor hcy_colorWithString:@"#ededed"];
        UIView * twoview = [[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 1)];
        twoview.backgroundColor = [UIColor hcy_colorWithString:@"#e0e0e0"];
        [view addSubview:twoview];
        return view;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
         static NSString * cells = @"vrXQYSubCell";
        BanBoVRXQYSubTVCell * cell = [tableView dequeueReusableCellWithIdentifier:cells];
        if (cell==nil) {
            cell = [[BanBoVRXQYSubTVCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cells];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setDatawithModel:_xiaomodel];
        return cell;
    }
    else
    {
       static NSString * cellsub = @"vrXQYerjiCell";
        BanBoVRXQYErJiCell * cell = [tableView dequeueReusableCellWithIdentifier:cellsub];
        if (cell==nil) {
            cell = [[BanBoVRXQYErJiCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellsub];
        }
        BanBoVRChaKanModel * model = _dataSource[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setDataWithVRChaKanModel:model];
        return cell;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
