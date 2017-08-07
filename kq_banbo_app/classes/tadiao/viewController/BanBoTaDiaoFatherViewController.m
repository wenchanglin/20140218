//
//  BanBoTaDiaoFatherViewController.m
//  kq_banbo_app
//
//  Created by banbo on 2017/5/27.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "BanBoTaDiaoFatherViewController.h"
#import "MJRefresh.h"
#import "BanBoTaDiaoTableViewCell.h"
#import "BanBoTaDiaoManager.h"
#import "BanBoTaDiaoModel.h"
@interface BanBoTaDiaoFatherViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableview;

@end

@implementation BanBoTaDiaoFatherViewController
{
    NSMutableArray * _TaDiaoArrays;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(kankan:) name:@"tadiaoIndex" object:nil];
    [self createTableview];
    [self header];
}
-(void)kankan:(NSNotification *)notification
{
    //NSLog(@"塔吊当前页:%@",notification.userInfo);
    _taDiaoid = [notification.userInfo objectForKey:@"user"];
}
-(void)header
{
    __weak BanBoTaDiaoFatherViewController *weakSelf = self;
    _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[BanBoTaDiaoManager sharedInstance]postTaDiaoDataWithSheBeiId:_taDiaoid completion:^(id data, NSError *error) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                _models = [BanBoTaDiaoModel mj_objectWithKeyValues:data];
            }
    
            else
            {
                NSDictionary * dcis = @{@"recordName":@"",@"dateTime":@"",@"deviceId":_taDiaoid,@"dwRotate":@0,@"latitude":@"0",@"longitude":@"0",@"wDip":@0,@"wHeight":@0,@"wLoad":@0,@"wMargin":@0,@"wRate":@0,@"wTorque":@0,@"recordNumber":@"0",@"wWindvel":@0,@"wFCodeVRate":@0,@"wFRateVCode":@0};
                _models = [BanBoTaDiaoModel mj_objectWithKeyValues:dcis];
                
            }
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_tableview.mj_header endRefreshing];
        });
        
        [_tableview reloadData];
    }];
    weakSelf.tableview.mj_header.automaticallyChangeAlpha = YES;
    
}
-(void)createTableview
{
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-100) style:UITableViewStylePlain];
    self.view.backgroundColor =  [UIColor groupTableViewBackgroundColor];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:_tableview];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%@%ld%ld",_models.recordName,(long)[indexPath section],(long)[indexPath row]];//以indexPath来唯一确定cell
    static NSString *CellIdentifier = @"TaDiaoCell";
    BanBoTaDiaoTableViewCell  * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell = [[BanBoTaDiaoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withIndexPath:indexPath];
    }
    [cell setDataWithIndexPath:indexPath withModel:_models withSheBeiModel:_shebeimodel];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *HeadView;
    if (section==0) {
        HeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,30)];
        HeadView.backgroundColor = [UIColor hcy_colorWithString:@"#f7f7f7"];
        UIView * firstline = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        firstline.backgroundColor = [UIColor hcy_colorWithString:@"#e0e0e0"];
        [HeadView addSubview:firstline];
        UILabel *BacgLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, 30)];
        BacgLabel.text = @"回转角度";
        BacgLabel.font = [YZLabelFactory taDiaoSectionFont];
        BacgLabel.textColor = [UIColor hcy_colorWithString:@"#333333"];
        [HeadView addSubview:BacgLabel];
        UIView * secondLine = [[UIView alloc]initWithFrame:CGRectMake(0, 29, SCREEN_WIDTH, 1)];
        secondLine.backgroundColor = [UIColor hcy_colorWithString:@"#e0e0e0"];
        [HeadView addSubview:secondLine];
    }
    else if (section==1)
    {
        HeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,30)];
        HeadView.backgroundColor = [UIColor hcy_colorWithString:@"#f7f7f7"];
        UIView * firstline = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        firstline.backgroundColor = [UIColor hcy_colorWithString:@"#e0e0e0"];
        [HeadView addSubview:firstline];
        UILabel *BacgLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, 30)];
        BacgLabel.text = @"塔吊现状";
        BacgLabel.font = [YZLabelFactory taDiaoSectionFont];
        BacgLabel.textColor = [UIColor hcy_colorWithString:@"#333333"];
        [HeadView addSubview:BacgLabel];
        UIView * secondLine = [[UIView alloc]initWithFrame:CGRectMake(0, 29, SCREEN_WIDTH, 1)];
        secondLine.backgroundColor = [UIColor hcy_colorWithString:@"#e0e0e0"];
        [HeadView addSubview:secondLine];
    }
    
    return HeadView;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        if (IS_IPHONE_5)
        {
            return 240;
        }
        else
        {
            return 260;
        }
    }
    else if(indexPath.section ==1)
    {
        if (IS_IPHONE_5) {
            return 500;
        }
        else
            return 520;
    }
    else
        return 150;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear: animated];
    [_tableview removeFromSuperview];
}

@end
