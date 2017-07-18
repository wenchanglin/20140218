//
//  HCYMutableBtnView.h
//  kq_banbo_app
//
//  Created by hcy on 2017/1/4.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HCYMutableBtnView;
@protocol HCYMutableBtnViewDelegate <NSObject>
@optional
-(void)btnView:(HCYMutableBtnView *)btnView clickBtnAtIdx:(NSInteger)idx;
@end

@protocol HCYMUtableBtn <NSObject>
/**
 是否需要修正size。设置成no。在viewlayout的时候就不会去修改他的size.但是x和y还是会变
 */
-(BOOL)needFixSize;
@end
/**
 一个按钮
 */
@interface HCYMutableBtn : NSObject<HCYMUtableBtn>
+(instancetype)mutBtnWithBtn:(UIButton *)btn;
@property(strong,nonatomic,readonly)UIButton *btn;
@property(assign,nonatomic)BOOL needFixSize;
@end
/**
 用来设置多个btn的view
 */
@interface HCYMutableBtnView : UIView
/**
 行间距
 */
@property(assign,nonatomic)CGFloat lineMargin;
/**
 列间距
 */
@property(assign,nonatomic)CGFloat itemMargin;

-(NSInteger)btnCount;
-(void)addBtn:(id<HCYMUtableBtn>)btn;
-(void)removeBtn:(id<HCYMUtableBtn>)btn;
-(id<HCYMUtableBtn>)btnAtIdx:(NSInteger)idx;
@property(weak,nonatomic)id<HCYMutableBtnViewDelegate> delegate;

/**
 子类override。
 主动调用来刷新视图
 */
-(void)reLayoutBtns;
@end


/**
 列表排列的btnView
 */
@interface HCYTableBtnView : HCYMutableBtnView
@property(assign,nonatomic)NSInteger columnCount;
@property(assign,nonatomic)NSInteger rowCount;

@end
