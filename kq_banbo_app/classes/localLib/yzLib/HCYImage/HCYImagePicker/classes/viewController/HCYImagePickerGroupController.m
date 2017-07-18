//
//  DtImagePickerGroupController.m
//  CustomImagePicker
//
//  Created by hcy on 15/8/18.
//  Copyright (c) 2015年 hcy. All rights reserved.
//

#import "HCYImagePickerGroupController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "HCYImagePickerGroupCell.h"
#import "HCYImagePickerContentItem.h"
#import "HCYImagePickerCollector.h"
#import "UIView+DanteImagePicker.h"
#import "HCYImagePickerHeader.h"
#import "HCYImagePickerGroupBottomView.h"
#import "HCYImagePickerBrowserTopView.h"
#import "HCYImagePickerBrowserBottomView.h"
//browser
#import "HCYPhotoBrowser.h"
#import "HCYPickerPhoto.h"
static NSString *collectionViewReuseId=@"DtImagePickerGroupCell";
@interface HCYImagePickerGroupController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,HCYImagePickerGroupCellDelegate,HCYPhotoBrowserDataSource,
    HCYPhotoBrowserDelegate,HCYImagePickerCollectorDelegate>

@property(strong,nonatomic)UICollectionView *collectionView;
@property(strong,nonatomic)id<HCYImagePickerListItem> groupItem;
@property(strong,nonatomic)HCYImagePickerCollector *dataCollector;
@property(strong,nonatomic)NSArray *dataArr;


@property(strong,nonatomic)HCYImagePickerGroupBottomView *bottomView;
//和预览相关的View
@property(strong,nonatomic)HCYPhotoBrowser *browser;
@property(strong,nonatomic)HCYImagePickerBrowserTopView    *browserTopView;
@property(strong,nonatomic)HCYImagePickerBrowserBottomView *browserBottomView;


@property(assign,nonatomic)NSInteger currentIndex;
@end

CGFloat    HCYImagePickerGroupItemEdgeLeft=3;
NSInteger  HCYImagePickerGroupColumnCount=4;

@implementation HCYImagePickerGroupController
-(instancetype)initWithListItem:(id<HCYImagePickerListItem>)item  {
    if (self=[super init]) {
        _groupItem=item;
        _dataCollector=[HCYImagePickerCollector sharedCollector];
        _bottomView=[[HCYImagePickerGroupBottomView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self setupSubviews];
    self.title=[_groupItem albumTitle];
    [self readPic];
    [self.dataCollector addDelegate:self];
    UIBarButtonItem *leftBtn=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(backBtnClicked:)];
    self.navigationItem.leftBarButtonItems=@[leftBtn];
}
-(void)backBtnClicked:(UIBarButtonItem *)leftBtn{
    [self.dataCollector removeDelegate:self];
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)dealloc{
    [self.dataCollector removeDelegate:self];
    NSLog(@"HCYImagePickerGroupVC-dealloc");
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=NO;
    if ([UIApplication sharedApplication].statusBarStyle==UIStatusBarStyleLightContent) {
        [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.browserTopView.hidden=NO;
    self.browserBottomView.hidden=NO;
}
-(void)setupSubviews{
    CGFloat bottomHeight=44;
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing=HCYImagePickerGroupItemEdgeLeft;
    layout.minimumInteritemSpacing=0;
    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-bottomHeight) collectionViewLayout:layout];
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    [self.collectionView registerClass:[HCYImagePickerGroupCell class] forCellWithReuseIdentifier:collectionViewReuseId];
    self.collectionView.backgroundColor=[UIColor clearColor];
    self.view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
    CGFloat itemWidth=[[HCYImagePickerUtil sharedUtil] defaultContentImageSize].width;
    
    CGFloat rowCount=self.dataArr.count/HCYImagePickerGroupColumnCount;
    CGFloat y=rowCount*itemWidth+(rowCount-1)*HCYImagePickerGroupItemEdgeLeft;
    _bottomView.top=_collectionView.bottom;
    _bottomView.left=0;
    _bottomView.width=self.view.width;
    _bottomView.height=self.view.height-_bottomView.top;
    [self.collectionView setContentOffset:CGPointMake(0, y) animated:NO];
    [self.view addSubview:_bottomView];

}

-(void)readPic{
    __weak typeof(self) wself=self;
    [_groupItem allAlbumImagesWithCompletion:^(NSArray *contentArr, NSError *error) {
        if (!wself) {
            return;
        }
        if (!error) {
            wself.dataArr=[[HCYImagePickerUtil sharedUtil] fillContentDataWithSource:contentArr];
            [wself refreshGroup];
        }
    }];
}
-(void)refreshGroup{
    [_collectionView reloadData];
    [_bottomView setselectItemCount:[self.dataCollector itemCount]];
}

#pragma mark collectionViewDatasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
        return self.dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HCYImagePickerGroupCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:collectionViewReuseId forIndexPath:indexPath];
    [cell refreshWithItem:self.dataArr[indexPath.row]];
    if (!cell.deleate) {
        cell.deleate=self;
    }
    return cell;
}
#pragma mark collectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HCYPhotoBrowser *browser=[HCYPhotoBrowser new];
    browser.browserDataSource=self;
    browser.browserDelegate=self;
    browser.currentIndex=indexPath.row;
    _currentIndex=indexPath.row;
    self.browser=browser;
    [self.navigationController pushViewController:browser animated:YES];
}
#pragma mark cellDelegate
-(void)cell:(HCYImagePickerGroupCell *)cell selected:(BOOL)select{
    NSIndexPath *indexPath=[self.collectionView indexPathForCell:cell];
    HCYImagePickerContentItem *item=self.dataArr[indexPath.row];
    if (select) {
        [self.dataCollector addItem:item];
    }else{
        [self.dataCollector removeItem:item];
    }
    [self refreshCustomView];
}
#pragma mark collectorDelegate
-(void)collectorItemBeyond:(HCYImagePickerCollector *)collector{
    
}
-(void)collector:(HCYImagePickerCollector *)collector addItem:(id)item{
    [self refreshCustomView];
}
-(void)collector:(HCYImagePickerCollector *)collector removeItem:(id)item{
    [self refreshCustomView];
}
#pragma mark collectionViewLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [[HCYImagePickerUtil sharedUtil] defaultContentImageSize];
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(HCYImagePickerGroupItemEdgeLeft, HCYImagePickerGroupItemEdgeLeft, 0, HCYImagePickerGroupItemEdgeLeft);
}

#pragma mark photoBrowserDataSource
-(NSUInteger)numberOfPhotosInBrowser:(HCYPhotoBrowser *)browser{
    return _dataArr.count;
}
-(HCYPhoto *)photoWithIndex:(NSUInteger)index{
    HCYPickerPhoto *photo=[HCYPickerPhoto new];
    photo.autoResize=YES;
    photo.photoIdentifier=[NSString stringWithFormat:@"%ld",(long)index];
    id<HCYImagePickerContentItem> item=_dataArr[index];
    photo.contentItem=item;
    return photo;
}

#pragma mark photoBrowserDelegate
-(void)browserDidLoad:(HCYPhotoBrowser *)browser{
    browser.automaticallyAdjustsScrollViewInsets=NO;
    UIView *topView=[self browserTopView];
    [browser.view addSubview:topView];
    
    UIView *bottomView=[self browserBottomView];
    [browser.view addSubview:bottomView];
    
}
-(void)browserWillAppear:(HCYPhotoBrowser *)browser{
    browser.navigationController.navigationBar.hidden=YES;
    if ([UIApplication sharedApplication].statusBarStyle!=UIStatusBarStyleLightContent) {
        [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;;
    }
}

-(void)browser:(HCYPhotoBrowser *)browser showPhotoAtIndex:(NSInteger)index{
    _currentIndex=index;
    [self refreshCustomView];
}
-(NSString *)titleForPhotoAtIndex:(NSInteger)index{
    NSString *title= [NSString stringWithFormat:@"%d/%ld",index+1,(unsigned long)self.dataArr.count];
    self.browserTopView.titleLabel.text=title;
    [self.browserTopView.titleLabel sizeToFit];
    return  title;
}
-(void)browser:(HCYPhotoBrowser *)browser TapPhoto:(HCYPhoto *)photo{
    BOOL target=!_browserTopView.hidden;
    _browserTopView.hidden=target;
    _browserBottomView.hidden=target;
}
-(void)browser:(HCYPhotoBrowser *)browser LongPressedPhoto:(HCYPhoto *)photo{

}
#pragma mark photoBrowser自定义view
-(UIView *)browserTopView{
    if (!_browserTopView) {
        _browserTopView=[[HCYImagePickerBrowserTopView alloc] initWithFrame:CGRectZero];
        [_browserTopView.backControl addTarget:self action:@selector(preBackBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_browserTopView.selectBtn addTarget:self action:@selector(preSelectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _browserTopView;
    
  
}
-(UIView *)browserBottomView{
    if (!_browserBottomView) {
        _browserBottomView=[[HCYImagePickerBrowserBottomView alloc] initWithFrame:CGRectZero];
        [_browserBottomView.sendBtn addTarget:self action:@selector(preSendBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_browserBottomView.sourceBtn addTarget:self action:@selector(preSourceBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _browserBottomView;
}

-(void)back{
    UIViewController *vc=[[self.navigationController viewControllers] lastObject];
    [vc.navigationController popViewControllerAnimated:YES];
}

-(void)refreshCustomView{
  
    id<HCYImagePickerContentItem> item=_dataArr[_currentIndex];
    
    [_browserTopView refreshWithItem:item];
    [_browserBottomView refreshWithItem:item];
    
}
#pragma mark previewCustomViewEvent
-(void)preBackBtnClicked:(UIButton *)btn{
    [self.browser.navigationController popViewControllerAnimated:YES];
}
-(void)preSelectBtnClicked:(UIButton *)btn{
    id<HCYImagePickerContentItem> item=[self currentPreviewItem];
    
    if (!btn.isSelected) {
        BOOL result= [self.dataCollector addItem:item];
        btn.selected=result;
    }else{
        [self.dataCollector removeItem:item];
        btn.selected=NO;
    }

}
-(void)preSendBtnClicked:(UIButton *)btn{
    if (self.dataCollector.itemCount==0) {
        [self.dataCollector addItem:[self currentPreviewItem]];
    }
    [self.dataCollector send];
}
-(void)preSourceBtnClicked:(UIButton *)btn{
    btn.selected=!btn.selected;
    if (btn.isSelected) {
        id<HCYImagePickerContentItem> item=[self currentPreviewItem];
        if (![item isSelected]) {
            [self.dataCollector addItem:item];
        }
        [self.dataCollector setSourceImage:YES];
    }else{
        [self.dataCollector setSourceImage:NO];
    }
    [self refreshCustomView];
}
-(id<HCYImagePickerContentItem>)currentPreviewItem{
    id<HCYImagePickerContentItem> item=self.dataArr[[self currentIndex]];
    return item;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
