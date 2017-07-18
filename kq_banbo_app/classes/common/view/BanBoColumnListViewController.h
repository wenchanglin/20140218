//
//  BanBoColumnListViewController.h
//  kq_banbo_app
//
//  Created by hcy on 2016/12/1.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoListViewController.h"
#import "HCYColumnLayoutManager.h"
#import "BanBoHomeDetail.h"
typedef NS_ENUM(NSInteger,BanboRefreshBottomType){
    BanboRefreshBottomTypeNone=1,
    BanboRefreshBottomTypeNeed,
};
typedef NS_ENUM(NSInteger,BanboEndRefreshType){
    BanboEndRefreshTypeNormal,
    BanboEndRefreshTypeNoMoreData
};
extern NSString* const BanBoColumnIndexPathKey;
@interface BanBoColumnListViewController : BanBoListViewController
@property(strong,nonatomic)NSMutableArray *tableViewDataArrM;
@property(strong,nonatomic)HCYColumnLayoutManager *columnLayoutManager;

/**
 会有一个默认通用compare的。配合下面列头使用的collection
 */
@property(strong,nonatomic,readonly)YZDataCollection *dataCollection;

/**
 用来设置cell背景色
 
 @param path 路径
 @return 颜色
 */
-(UIColor *)bgColorForCellAtIndexPath:(NSIndexPath *)path;

/**
 设置底部刷新类型

 @param type 类型
 */
-(void)setBottomRefreshType:(BanboRefreshBottomType)type;
/**
 停止刷新

 @param type 停止刷新类型
 */
-(void)endFooterRefreshWithType:(BanboEndRefreshType)type;

/**
 点击加载更多

 @param refreshFooter 刷新控件
 */
-(void)getMoreData:(id)refreshFooter;


-(BOOL)autoSetTableViewHeight;

-(void)setDataCollectionAndReloadTableView;
@end


/**
 比较方便的一个头
 */
@interface BanBoColumnHeader :BanBoColumnCellObj
@property(strong,nonatomic)NSArray *titles;
@property(strong,nonatomic)UIFont *font;
@property(copy,nonatomic)NSString *cellClass;

@property(strong,nonatomic)NSArray *textColorArr;
-(void)addExtWidth:(CGFloat)width forIdx:(NSInteger)idx;
@end
/**
 列cell
 */
@interface BanboColumnCell : YZListCell
@property(strong,nonatomic)HCYColumnLayoutManager *columnLayoutManager;
@property(strong,nonatomic)UIView *separView;
@end

/**
 复数label的cell
 
 */
@interface BanboMutLabelColumnCell : BanboColumnCell
-(UILabel *)labelAtIdx:(NSInteger)idx;
/**
 创建label用
 
 @param count 个数
 @param font  label字体
 @param textColorDict  @{idx:color}
 */
-(void)createLabelWithCount:(NSInteger)count font:(nullable UIFont *)font colorDict:(nullable NSDictionary *)textColorDict;
@end
