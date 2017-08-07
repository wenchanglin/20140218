//
//  BanBoSuSheGuanLiViewController.m
//  kq_banbo_app
//
//  Created by banbo on 2017/4/18.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "BanBoSuSheGuanLiViewController.h"
#import "YZTitleView+BanBo.h"
#import "BanBoSuSheListCollectionViewCell.h"
#import "BanBoSuSheManager.h"
#import "BanBoSuSGLListViewController.h"
#import "BanBoYongDianGLViewController.h"
@interface BanBoSuSheGuanLiViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)BanBoProject * project;
@property(nonatomic,strong)NSArray * itemArr;
@end

@implementation BanBoSuSheGuanLiViewController
-(instancetype)initWithProject:(BanBoProject *)project
{
    if (self = [super init]) {
        self.project = project;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //标题
    YZTitleView * titleView = [YZTitleView banbo_inst];
    [titleView showInNaviItem:self.navigationItem];
    [self setupSubViews];
}
-(void)setupSubViews
{
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
    UICollectionView *collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, itemHeight*1+flowLayout.sectionInset.top+lineMargin*2) collectionViewLayout:flowLayout];
    collectionView.dataSource=self;
    collectionView.delegate=self;
    [self.view addSubview:collectionView];
    [collectionView registerClass:[BanBoSuSheListCollectionViewCell class] forCellWithReuseIdentifier:@"22"];
    collectionView.backgroundColor=[UIColor whiteColor];
}
#pragma mark - collectiview的代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BanBoSuSheListCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"22" forIndexPath:indexPath];
    [cell refreshWithItem:self.itemArr[indexPath.row]];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    BanBoShiminListItem * susheItem = self.itemArr[indexPath.row];
    if (susheItem.tag == BanBoShuSheTypeSSGL) {
        BanBoSuSGLListViewController * susheguanli = [[BanBoSuSGLListViewController alloc]initWithListItem:susheItem project:self.project];
        [self.navigationController pushViewController:susheguanli animated:YES];
    }
    else if (susheItem.tag==BanBoShuSheTypeYDGL)
    {
        BanBoYongDianGLViewController * yongdian  =[[BanBoYongDianGLViewController alloc]initWithListItem:susheItem project:self.project];
        [self.navigationController pushViewController:yongdian animated:YES];
    }
}
#pragma mark - 初始化数据
-(NSArray *)itemArr
{
    if (!_itemArr)
    {
        NSMutableArray * itemArray = [NSMutableArray array];
        [itemArray addObject:[self itemWithTitle:@"宿舍管理" imageName:@"susheguanli" type:BanBoShuSheTypeSSGL]];
        [itemArray addObject:[self itemWithTitle:@"用电管理" imageName:@"yongdianguanli" type:BanBoShuSheTypeYDGL]];
        _itemArr = [itemArray copy];
    }
    return _itemArr;
    
}
-(BanBoShiminListItem *)itemWithTitle:(NSString *)title imageName:(NSString *)imagename type:(BanBoShuSheType)type
{
    BanBoShiminListItem * item = [BanBoShiminListItem new];
    item.tag = type;
    item.title = title;
    item.imageName = imagename;
    return item;
}
@end
