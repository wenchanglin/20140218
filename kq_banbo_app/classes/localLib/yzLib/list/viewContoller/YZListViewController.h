//
//  YZListViewController.h
//  YZWaimaiCustomer
//
//  Created by hcy on 16/8/17.
//  Copyright © 2016年 hcy@yz. All rights reserved.
//

#import "YZBaseViewController.h"
#import "YZListCell.h"
@class YZDataCollection;
/**
 *  listViewController
 *  automaticallyAdjustsScrollViewInsets=no
 *  cell is subClassof YZListCell
 */
@interface YZListViewController : YZBaseViewController<UITableViewDataSource,UITableViewDelegate,YZListCellDelegate>
@property(strong,nonatomic,readonly)UITableView *dataTableView;
/**
 *  set data && reload the tableView
 *
 *  @param dataCollection data
 */
-(void)setDataWithGroupedCollection:(YZDataCollection *)dataCollection;
-(id)memberOfIndex:(NSIndexPath *)path;
-(NSString *)titleForSection:(NSInteger)section;
-(YZDataCollection *)fatherDataCollection;

/**
 在cell创建的时候子类如果重写了。会调用
 @param cell cell
 @param indexPath 位置
 */
-(void)onCellCreated:(YZListCell *)cell indexPath:(NSIndexPath *)indexPath;
/**
 子类如果重写了这个就可以不调用默认的refrehWIthItem:islast:userInfo那个。自己写刷新方法

 @param cell cell
 @param indexPath path
 */
-(void)customRefreshCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;
@end
