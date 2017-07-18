//
//  BanBoShiminViewController.m
//  kq_banbo_app
//
//  Created by hcy on 2016/12/2.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoShiminViewController.h"
#import "BanBoShiMinItemListViewController.h"
#import "BanBoShiminKQTJViewController.h"

#import "BanBoShiMinManager.h"
#import "YZTitleView+BanBo.h"
#import "BanBoShiminListCell.h"

#import "BanBoShiminListItem.h"
#import "BanBoProject.h"

#import "BanBoShiminCondiView.h"
#import "BanBoShiminGRMCListViewController.h"
@interface BanBoShiminViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(strong,nonatomic)UICollectionView *collectionView;

@property(strong,nonatomic)BanBoProject *project;
@property(strong,nonatomic)NSArray *itemArr;
@end

@implementation BanBoShiminViewController
-(instancetype)initWithProject:(BanBoProject *)project{
    if (self=[super init]) {
        self.project=project;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];    
    YZTitleView *titleView=[YZTitleView banbo_inst];
    [titleView showInNaviItem:self.navigationItem];
    [self setupSubviews];
}
-(void)setupSubviews{
    CGFloat left=45;
    CGFloat itemMarin=0;
    CGFloat columnCount=3;
    CGFloat lineMargin=18;
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing=lineMargin;
    flowLayout.sectionInset=UIEdgeInsetsMake(26.5, left, 0, left);
    flowLayout.minimumInteritemSpacing=itemMarin;
    CGFloat itemWidth=(self.view.width-left*2-(columnCount-1)*itemMarin)/columnCount;
    CGFloat itemHeight=itemWidth*[BanBoLayoutParam shiminImagePercent]+10+[YZLabelFactory normalFont].lineHeight+2;
    
    flowLayout.itemSize=CGSizeMake(itemWidth, itemHeight);
    UICollectionView *collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, itemHeight*2+flowLayout.sectionInset.top+lineMargin*2) collectionViewLayout:flowLayout];
    collectionView.dataSource=self;
    collectionView.delegate=self;
    [self.view addSubview:collectionView];
    [collectionView registerClass:[BanBoShiminListCell class] forCellWithReuseIdentifier:@"11"];
    collectionView.backgroundColor=[UIColor whiteColor];
}
#pragma mark collectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 6;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BanBoShiminListCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"11" forIndexPath:indexPath];
    [cell refreshWithItem:self.itemArr[indexPath.row]];
    return cell;
}
#pragma mark collectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    BanBoShiminListItem *item=self.itemArr[indexPath.row];
    if(item.tag==BanBoShiminTypeKQTJ){
        BanBoShiminKQTJViewController *list=[[BanBoShiminKQTJViewController alloc] initWithProject:self.project];
        list.item=item;
        [self.navigationController pushViewController:list animated:YES];
    }else if(item.tag==BanBoShiminTypeGRMC || item.tag==BanBoShiminTypeJKGL){
        BanBoShiminGRMCListViewController *list=[[BanBoShiminGRMCListViewController alloc] initWithListItem:item project:self.project];
        [self.navigationController pushViewController:list animated:YES];
    }else{
        BanBoShiMinItemListViewController *list=[[BanBoShiMinItemListViewController alloc] initWithListItem:item project:self.project];
        [self.navigationController pushViewController:list animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSArray *)itemArr{
    if (!_itemArr) {
        NSMutableArray *itemArrM=[NSMutableArray array];
        [itemArrM addObject:[self itemWithTitle:@"工资列表" imageName:@"gongzi" type:BanBoShiminTypeGZLB]];
        [itemArrM addObject:[self itemWithTitle:@"工人名册" imageName:@"huaming" type:BanBoShiminTypeGRMC]];
        [itemArrM addObject:[self itemWithTitle:@"信息管理" imageName:@"xinxiguanli" type:BanBoShiminTypeXXGL]];
        [itemArrM addObject:[self itemWithTitle:@"考勤管理" imageName:@"kaoqin" type:BanBoShiminTypeKQGL]];
        [itemArrM addObject:[self itemWithTitle:@"银行卡号" imageName:@"yinhangka" type:BanBoShiminTypeYHKH]];
        [itemArrM addObject:[self itemWithTitle:@"考勤统计" imageName:@"kaoqintongji" type:BanBoShiminTypeKQTJ]];
        _itemArr=[itemArrM copy];
    }
    return _itemArr;
}
-(BanBoShiminListItem *)itemWithTitle:(NSString *)title imageName:(NSString *)imageName type:(BanBoShiminType)type{
    BanBoShiminListItem *item=[BanBoShiminListItem new];
    item.tag=type;
    item.title=title;
    item.imageName=imageName;
    
    return item;
}
-(UIView *)topView{
    return [UIView new];
}
-(CGRect)banbo_dataTableFrame{
    return CGRectZero;
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
