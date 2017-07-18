//
//  BBColumnLayoutManager.h
//  kq_banbo_app
//
//  Created by hcy on 2016/11/24.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol HCYColumnModel<NSObject>
@required
-(NSString *)titleAtIndex:(NSInteger)idx;
-(UIFont *)fontAtIndex:(NSInteger)idx;
@optional
//每一行都会调用
-(UIColor *)titleColorAtIndex:(NSInteger)idx isHeader:(BOOL)isHeader;

/**
 header专用
 给某一列提供额外的宽度使用
 
 @param idx 位置
 @return 宽度
 */
-(CGFloat)extWidthAtIdx:(NSInteger)idx;

/**
 header专用（一定会调用）

 @return 列数
 */
-(NSInteger)titleCount;
/**
 get，set都需要
 */
@property(assign,nonatomic)CGFloat cellHeight;
 
@end


@interface HCYColumnLayoutManager :NSObject

-(instancetype)initWithColumnCount:(NSInteger)columnCount tableView:(UITableView *)tableView;

@property(assign,nonatomic)CGFloat minColumnMargin;
@property(assign,nonatomic)UIEdgeInsets tableViewEdge;

/**
 默认no。设置成yes的话。就不会去增加行
 */
@property(assign,nonatomic)BOOL adjustsFontSizeToFitWidth;

-(void)cleanData;

/**
 能否缩小列头-默认no
 */
@property(assign,nonatomic)BOOL canMinuseColumnHeader;
/**
 每当有新数据来的时候调用这个方法

 @param models 数据
 */
-(void)addModels:(NSArray *)models;
@property(strong,nonatomic)id<HCYColumnModel> columnHeader;
-(void)refreshHeader:(id<HCYColumnModel>)header;
/**
 获得具体的布局

 @param columnIdx 列索引
 @param path 行索引
 @return 布局(只有x和width能用）
 */
-(CGRect)rectForColumnAtIndex:(NSInteger)columnIdx row:(NSIndexPath *)path;
@end
