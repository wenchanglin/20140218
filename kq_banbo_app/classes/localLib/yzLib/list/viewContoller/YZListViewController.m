//
//  YZListViewController.m
//  YZWaimaiCustomer
//
//  Created by hcy on 16/8/17.
//  Copyright © 2016年 hcy@yz. All rights reserved.
//

#import "YZListViewController.h"
#import "UIView+HCY.h"
#import "YZDataCollection.h"
#import "YZListHeader.h"
//f_代表father的意思
@interface YZListViewController ()
@property(strong,nonatomic)YZDataCollection *f_dataCollection;
@property(strong,nonatomic)UITableView *f_tableView;
@end

@implementation YZListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self f_setupTableView];
   
}
-(YZDataCollection *)fatherDataCollection{
    return self.f_dataCollection;
}
-(void)f_setupTableView{
    UITableView *tableView=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.tableFooterView=[UIView new];
    [self.view addSubview:tableView];
    if (self.navigationController) {
        tableView.top=64;
        tableView.height-=64;
    }
    _f_tableView=tableView;
    tableView.autoresizingMask=(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
}
-(UITableView *)dataTableView{
    return _f_tableView;
}
-(void)setDataWithGroupedCollection:(YZDataCollection *)dataCollection{
    if ([dataCollection isKindOfClass:[YZDataCollection class]]) {
        _f_dataCollection=dataCollection;
        [_f_tableView reloadData];
    }    
}
#pragma mark tableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.f_dataCollection groupCount];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.f_dataCollection memberCountOfGroup:section];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id<YZListItem> member=[self memberOfIndex:indexPath];
    
    NSString *reuseId=[member reuseId];
    YZListCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        NSString *cellClsStr=[member cellClass];
        if (cellClsStr.length==0) {
            cellClsStr=@"YZListCell";
        }
        cell=[[NSClassFromString(cellClsStr) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
        cell.delegate=self;
        if ([self respondsToSelector:@selector(onCellCreated:indexPath:)]) {
            [self onCellCreated:cell indexPath:indexPath];
        }
    }
    //自己刷新
    if([self respondsToSelector:@selector(customRefreshCell:indexPath:)]){
        [self customRefreshCell:cell indexPath:indexPath];
    }else{
        NSInteger sectionMemberCount=[tableView numberOfRowsInSection:indexPath.section];
        BOOL isLast=(indexPath.row==(sectionMemberCount-1));
        NSDictionary *userInfo=nil;
        if ([member respondsToSelector:@selector(userInfo)]) {
            userInfo=[member userInfo];
        }
        [cell refrehWithItem:member isLast:isLast userInfo:userInfo];
    }
    
    return cell;
}
#pragma mark tableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id<YZListItem> item=[self memberOfIndex:indexPath];
    if ([item respondsToSelector:@selector(cellHeight)]) {
        CGFloat cellHeight= [item cellHeight];
        
        return cellHeight;
    }else{
        return [self defaultCellHeightInScene:0];
    }

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark cellDelegate
-(void)list_onCatchEvent:(YZListCellEvent *)event{
    
}
#pragma mark customRefresh


#pragma mark data
-(id<YZListItem>)memberOfIndex:(NSIndexPath *)path{
    return (id<YZListItem>)[self.f_dataCollection memberOfIndex:path];
}
-(NSString *)titleForSection:(NSInteger)section{
    return [self.f_dataCollection titleOfGroup:section];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark config
-(CGFloat)defaultCellHeightInScene:(NSInteger)scene{
    if (IS_IPHONE_6P) {
        return 60;
    }else if (IS_IPHONE_6){
        return 55;
    }else{
        return 50;
    }
}
@end
