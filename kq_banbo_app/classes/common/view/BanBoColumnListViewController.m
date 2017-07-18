//
//  BanBoColumnListViewController.m
//  kq_banbo_app
//
//  Created by hcy on 2016/12/1.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoColumnListViewController.h"
#import <MJRefresh.h>
//为了头固定加的
@interface BanboMutLabelView : UIView
@property(strong,nonatomic)NSMutableArray *labels;
-(void)createLabelWithCount:(NSInteger)count font:(UIFont *)font colorDict:(NSDictionary *)textColorDict;
-(void)refreshWithData:(id<HCYColumnModel>)data manager:(HCYColumnLayoutManager *)manager path:(NSIndexPath *)path;
@end

NSString *const BanBoColumnIndexPathKey=@"path";

@interface BanBoColumnListViewController ()
@property(assign,nonatomic)CGFloat f_columnHeaderHeight;
@property(strong,nonatomic)BanBoColumnHeader *f_columnHeader;
@property(strong,nonatomic)BanboMutLabelView *f_setionHeaderView;
@end


@implementation BanBoColumnListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableViewDataArrM=[NSMutableArray array];
    self.dataTableView.backgroundColor=[UIColor clearColor];
    // Do any additional setup after loading the view.
}
//-(void)setDataWithGroupedCollection:(YZDataCollection *)dataCollection{
//    
//    NSString *reuseId=[NSString stringWithFormat:@"%p",self.columnLayoutManager];
//    for (NSObject *obj in dataCollection.members) {
//        if ([obj isKindOfClass:[BanBoColumnCellObj class]]) {
//            [(BanBoColumnCellObj *)obj setCustomReuseId:reuseId];
//        }
//    }
//    [super setDataWithGroupedCollection:dataCollection];
//}
-(void)getMoreData:(MJRefreshFooter *)refreshFooter{
    [refreshFooter endRefreshing];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([HCYUtil isShowProgress]) {
        [HCYUtil dismissProgress];
    }
}
-(void)setBottomRefreshType:(BanboRefreshBottomType)type{
    switch (type) {
        case BanboRefreshBottomTypeNone:
        {
            if(self.dataTableView.mj_footer){
                self.dataTableView.mj_footer=nil;
            }
        }
            break;
        case BanboRefreshBottomTypeNeed:
        {
            if (self.dataTableView.mj_footer==nil) {
                MJRefreshAutoStateFooter *footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData:)];
                [footer setTitle:@"点击加载更多" forState:MJRefreshStateIdle];
                self.dataTableView.mj_footer=footer;
            }else{
                [self.dataTableView.mj_footer resetNoMoreData];
            }
        }
            break;
    }
}
-(void)endFooterRefreshWithType:(BanboEndRefreshType)type{
    if (type==BanboEndRefreshTypeNoMoreData) {
        [self.dataTableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.dataTableView.mj_footer endRefreshing];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(BOOL)autoSetTableViewHeight{
    return YES;
}
@synthesize dataCollection=_dataCollection;
-(YZDataCollection *)dataCollection{
    if (!_dataCollection) {
        YZDataCollection *dataCollection=[YZDataCollection new];
        dataCollection.groupTitleComparator=[dataCollection sameGroupTitleCompartor];
        dataCollection.groupMemberComparator=^NSComparisonResult(id obj1,id obj2){
            //头第一列
            if ([obj1 isKindOfClass:[NSString class]]) {
                return NSOrderedAscending;
            }
            if ([obj2 isKindOfClass:[NSString class]]) {
                return NSOrderedDescending;
            }
            if ([obj1 isKindOfClass:[NSNumber class]] && [obj2 isKindOfClass:[NSNumber class]]) {
                NSInteger val1=[(NSNumber *)obj1 integerValue];
                NSInteger val2=[(NSNumber *)obj2 integerValue];
                //总计第二列
                if (val1<0) {
                    return NSOrderedAscending;
                }
                if (val2<0) {
                    return NSOrderedDescending;
                }
                
                return val1<val2;
            }else{
                return [obj1 compare:obj2];
            }
        };
        _dataCollection=dataCollection;
    }
    return _dataCollection;
}
-(void)onCellCreated:(YZListCell *)cell indexPath:(NSIndexPath *)indexPath{
    if ([cell isKindOfClass:[BanboColumnCell class]]) {
        BanboColumnCell *columnCell= (BanboColumnCell *)cell;
        columnCell.columnLayoutManager=self.columnLayoutManager;
    }
}
-(void)customRefreshCell:(BanboColumnCell *)cell indexPath:(NSIndexPath *)indexPath{
//    [super customRefreshCell:cell indexPath:indexPath];
    [cell refrehWithItem:[super memberOfIndex:indexPath] isLast:NO userInfo:@{BanBoColumnIndexPathKey:indexPath}];
    if ([self respondsToSelector:@selector(bgColorForCellAtIndexPath:)]) {
        NSIndexPath *path=[NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
        cell.backgroundColor=[self bgColorForCellAtIndexPath:path];
    }
}
-(void)setDataCollectionAndReloadTableView{
    dispatch_async_main_safe(^{
        //改版-固定头
        [self checkHeader];
        NSIndexPath *path=[NSIndexPath indexPathForRow:0 inSection:0];
        [self.f_setionHeaderView refreshWithData:self.f_columnHeader manager:self.columnLayoutManager path:path];

        [self.dataCollection setMembers:[self.tableViewDataArrM copy]];
        [self setDataWithGroupedCollection:self.dataCollection];
        [self resetTableViewFrame];
    });
}
-(void)checkHeader{
    if([self.f_columnHeader isEqual:self.columnLayoutManager.columnHeader]==NO){
        self.f_columnHeader=self.columnLayoutManager.columnHeader;
        [self.f_setionHeaderView removeFromSuperview];
        self.f_setionHeaderView=nil;
    }
    if (self.tableViewDataArrM.count) {
        id obj=[self.tableViewDataArrM firstObject];
        if ([obj isKindOfClass:[BanBoColumnHeader class]]) {
            self.f_columnHeader=obj;
            [self.tableViewDataArrM removeObjectAtIndex:0];
            //设置头高度
            self.f_columnHeaderHeight=[[self f_columnHeader] cellHeight];
            
            CGRect rect=[self banbo_dataTableFrame];
            //获得页面设置的tableview和topview的距离
            //把headerView添加到当前视图中
            UIView *headerView= self.f_setionHeaderView;
            headerView.top=rect.origin.y;
            headerView.left=rect.origin.x;
            headerView.width=rect.size.width;
            
            [self.view addSubview:[self f_setionHeaderView]];
            //修改tableViewFrame
            rect.origin.y+=self.f_columnHeaderHeight;
            rect.size.height-=self.f_columnHeaderHeight;
            self.dataTableView.frame=rect;
        }else{
            DDLogError(@"first Data is not header:%@",obj);
        }
    }
    
}

-(BanboMutLabelView *)f_setionHeaderView{
    if (!_f_setionHeaderView) {
        if (self.f_columnHeader) {
            BanboMutLabelView *view=[[BanboMutLabelView alloc] initWithFrame:CGRectMake(0, 0, self.dataTableView.width, self.f_columnHeader.cellHeight)];
            [view createLabelWithCount:self.f_columnHeader.titles.count font:[YZLabelFactory normalFont] colorDict:nil];
            NSIndexPath *path=[NSIndexPath indexPathForRow:0 inSection:0];
            view.backgroundColor=[self bgColorForCellAtIndexPath:path];
            _f_setionHeaderView=view;
        }
    }
    
    return _f_setionHeaderView;
    
}

-(void)resetTableViewFrame{
    if([self autoSetTableViewHeight]){
        UITableView *tableView=[self dataTableView];
        CGFloat tableViewMaxHeight=[self banbo_dataTableFrame].size.height-self.f_columnHeaderHeight;
        if (tableView.contentSize.height<tableViewMaxHeight) {
            CGFloat height=tableView.contentSize.height;
            if (tableView.mj_footer) {
                height+=tableView.mj_footer.height;
            }
            tableView.height=height;
        }else{
            tableView.height=tableViewMaxHeight;
        }
    }
}
-(UIColor *)bgColorForCellAtIndexPath:(NSIndexPath *)path{
    return [UIColor whiteColor];
}


@end
#pragma mark columnHeader
@interface BanBoColumnHeader()
@property(strong,nonatomic)NSMutableDictionary *extWidthDictM;
@end
@implementation BanBoColumnHeader
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellClass=@"BanboMutLabelColumnCell";
        self.extWidthDictM=[NSMutableDictionary dictionary];
    }
    return self;
}
-(NSString *)groupTitle{
    return @"";
}
-(id)sortKey{
    return @"";
}
-(NSInteger)titleCount{
    return self.titles.count;
}

-(NSString *)titleAtIndex:(NSInteger)idx {
    if (idx>=0 & idx<self.titles.count) {
        return self.titles[idx];
    }else{
        return @"";
    }
}
-(UIColor *)titleColorAtIndex:(NSInteger)idx isHeader:(BOOL)isHeader{
    if (isHeader) {
        return nil;
    }
    if(idx>=0 && idx<self.textColorArr.count){
        return self.textColorArr[idx];
    }
    return nil;
    
}
-(UIFont *)fontAtIndex:(NSInteger)idx{
    return self.font?:[YZLabelFactory normalFont];
    
}
-(void)addExtWidth:(CGFloat)width forIdx:(NSInteger)idx{
    [self.extWidthDictM setValue:@(width) forKey:[NSString stringWithFormat:@"%ld",(long)idx]];
}

-(CGFloat)extWidthAtIdx:(NSInteger)idx{
    NSString *key=[NSString stringWithFormat:@"%ld",(long)idx];
    if ([self.extWidthDictM objectForKey:key]) {
        NSNumber *val=[self.extWidthDictM objectForKey:key];
        return [val floatValue];
    }
    return 0;
}
@end

@implementation BanboColumnCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *separView=[[UIView alloc] init];
        separView.height=1;
        separView.backgroundColor=BanBoHomeSeparColor;
        [self.contentView addSubview:separView];
        self.separView=separView;
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.separView.left=0;
    self.separView.width=self.width;
    self.separView.top=self.height-1;
}
@end

#pragma mark mutableColumnCell&&View

@implementation BanboMutLabelView
-(void)createLabelWithCount:(NSInteger)count font:(UIFont *)font colorDict:(nullable NSDictionary *)textColorDict{
    [self.labels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSMutableArray *tmpArrM=[NSMutableArray array];
    for (NSInteger i=0; i<count; i++) {
        UILabel *label=[UILabel new];
        label.textAlignment=NSTextAlignmentCenter;
        label.font=font?:[YZLabelFactory normalFont];
        label.numberOfLines=999;
        UIColor *textColor=textColorDict[@(i)];
        label.textColor=textColor?:[UIColor blackColor];
        [tmpArrM addObject:label];
        [self addSubview:label];
        if (IS_IPHONE_5) {
            label.adjustsFontSizeToFitWidth=YES;
        }
    }
    self.labels=tmpArrM;
}
-(void)refreshWithData:(id<HCYColumnModel>)item manager:(HCYColumnLayoutManager *)manager path:(NSIndexPath *)path{
    for (NSInteger i=0; i<self.labels.count; i++) {
        UILabel *label=self.labels[i];
        label.text=[item titleAtIndex:i];
        label.font=[item fontAtIndex:i];
        label.frame=[manager rectForColumnAtIndex:i row:path];
        BOOL haveColorImp=[item respondsToSelector:@selector(titleColorAtIndex: isHeader:)];

        if (haveColorImp) {
            UIColor *textColor=[item titleColorAtIndex:i isHeader:path.row==0];
            if (textColor) {
                label.textColor=textColor;
            }
        }
    }
}
-(void)layoutSubviews{
    for (UILabel *label in self.labels) {
        label.height=self.height;
    }
}
@end


@interface BanboMutLabelColumnCell()
@property(strong,nonatomic)BanboMutLabelView *mutLabelView;
@end
@implementation BanboMutLabelColumnCell
-(UILabel *)labelAtIdx:(NSInteger)idx{
    if (idx<0 || idx>=self.mutLabelView.labels.count) {
        return nil;
    }
    return [self.mutLabelView labels][idx];
}
-(void)createLabelWithCount:(NSInteger)count font:(UIFont *)font colorDict:(nullable NSDictionary *)textColorDict{
    [self.mutLabelView createLabelWithCount:count font:font colorDict:textColorDict];
}
-(BanboMutLabelView *)mutLabelView{
    if(!_mutLabelView){
        
        BanboMutLabelView *mutLabelView=[BanboMutLabelView new];
        [self.contentView addSubview:mutLabelView];
        _mutLabelView=mutLabelView;
    }
    return _mutLabelView;
}
-(void)refrehWithItem:(id<HCYColumnModel>)item isLast:(BOOL)last userInfo:(NSDictionary *)userInfo{
    //不支持的不鸟
    if ([item conformsToProtocol:@protocol(HCYColumnModel)]==NO) {
        DDLogError(@"self:%@",item);
        return;
    }
    NSIndexPath *path=userInfo[BanBoColumnIndexPathKey];
    if (!path) {
        return;
    }
    [self.mutLabelView refreshWithData:item manager:self.columnLayoutManager path:path];
}
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
}
-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.mutLabelView.frame=self.bounds;
    self.mutLabelView.height-=1;
}
@end

