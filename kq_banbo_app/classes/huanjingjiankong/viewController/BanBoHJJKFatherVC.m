//
//  BanBoHJJKFatherVC.m
//  kq_banbo_app
//
//  Created by banbo on 2017/4/28.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "BanBoHJJKFatherVC.h"
#import "BanBoHJingJKTableViewCell.h"
#import "BanBoHuanJModel.h"
#import "MJRefresh.h"
#import "BanBoHJJKManager.h"
@interface BanBoHJJKFatherVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableview;
@end

@implementation BanBoHJJKFatherVC
{
    
   
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(kankan:) name:@"huanjingIndex" object:nil];
    [self createTableview];
    [self header];
}
-(void)kankan:(NSNotification *)notification
{
    //NSLog(@"环境当前页:%@",notification.userInfo);
    _HuanJid = [notification.userInfo objectForKey:@"user"];
}
-(void)header
{
    __weak BanBoHJJKFatherVC *weakSelf = self;
    _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[BanBoHJJKManager sharedInstance]posthuanJSShiDataWithSheBeiId:_HuanJid completion:^(id data, NSError *error) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                _modelsef =  [BanBoHuanJModel mj_objectWithKeyValues:data];
            }
            else
            {
                NSDictionary * dci = @{@"equipmentName":@"",@"pm2p5Msg":@"优秀",@"pm10Msg":@"优秀",@"pm2p5":@0,@"pm10":@"0",@"rtdId":@0,@"humi":@"0",@"tsp":@0,@"temp":@"0",@"ws":@"0",@"wdir":@"0",@"atm":@0,@"nvh":@0,@"createTime":@"0",@"dataTime":@"0",@"equipmentId":_HuanJid};
                _modelsef = [BanBoHuanJModel mj_objectWithKeyValues:dci];

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
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0,1, SCREEN_WIDTH, SCREEN_HEIGHT-104) style:UITableViewStylePlain];
    self.view.backgroundColor =  [UIColor groupTableViewBackgroundColor];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:_tableview];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"HuanJingJianKongCell";
    BanBoHJingJKTableViewCell  * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell = [[BanBoHJingJKTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withIndexPath:indexPath];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setDataWithIndexPath:indexPath withModel:_modelsef];
       return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0||indexPath.row==1)
    {
        return 110;
    }
    else
    {
    return 50;
    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear: animated];
    [_tableview removeFromSuperview];
}

@end
