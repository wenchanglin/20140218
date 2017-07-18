//
//  HCYMutableBtnView.m
//  kq_banbo_app
//
//  Created by hcy on 2017/1/4.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "HCYMutableBtnView.h"
#import <objc/runtime.h>
@interface HCYMutableBtnView()
@property(strong,nonatomic)NSMutableArray *btnArrM;
@end
@implementation HCYMutableBtnView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.btnArrM=[NSMutableArray array];
    }
    return self;
}
#pragma mark btn添加删除
-(void)addBtn:(HCYMutableBtn *)btn{
    if ([self.btnArrM containsObject:btn]==NO) {
        [self.btnArrM addObject:btn];
        UIButton *aBtn=btn.btn;
        [aBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:aBtn];
    }
}
-(void)removeBtn:(HCYMutableBtn *)btn{
    if ([self.btnArrM containsObject:btn]==YES) {
        [self.btnArrM removeObject:btn];
        [btn.btn removeFromSuperview];
    }
}

-(id<HCYMUtableBtn> )btnAtIdx:(NSInteger)idx{
    if (idx>=0 && idx<self.btnArrM.count) {
        return self.btnArrM[idx];
    }else{
        return nil;
    }
}
#pragma mark btnEvent
-(void)btnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(btnView:clickBtnAtIdx:)]) {
        NSInteger idx=[self idxForBtn:btn];
        if(idx>=0) [self.delegate btnView:self clickBtnAtIdx:idx];
            
    }
}
#pragma mark -
-(NSInteger)btnCount{
    return self.btnArrM.count;
}
-(NSInteger)idxForBtn:(UIButton *)btn{
    NSInteger i=-1;
    for (id<HCYMUtableBtn> mutBtn in [self btnArrM]) {
        UIView *aBtn=[self trueBtnInMutBtn:mutBtn];
        i++;
        if(aBtn==btn){
            break;
        }
    }
    return i;
}
-(UIView *)trueBtnInMutBtn:(id<HCYMUtableBtn>)mutBtn{
    
    if ([mutBtn isKindOfClass:[UIView class]]) {
        return (UIView *)mutBtn;
    }else if ([mutBtn isKindOfClass:[HCYMutableBtn class]]){
       return  [((HCYMutableBtn *)mutBtn) btn];
    }else{
        return nil;
    }
}
#pragma mark -
-(void)reLayoutBtns{
    
}
@end

@implementation HCYMutableBtn
+(instancetype)mutBtnWithBtn:(UIButton *)btn{
    return [[self alloc] initWithBtn:btn];
}
- (instancetype)initWithBtn:(UIButton *)btn
{
    self = [super init];
    if (self) {
        _btn=btn;
        self.needFixSize=YES;
    }
    return self;
}

@end

@interface HCYTableBtnView()
@property(assign,nonatomic)CGSize cellSize;
@end

@implementation HCYTableBtnView
-(void)reLayoutBtns{
    [self setNeedsLayout];
}
-(void)calcParam{
    CGFloat width=(self.width-self.itemMargin*(self.columnCount-1))/self.columnCount;
    CGFloat height=(self.height-self.lineMargin*(self.rowCount-1))/self.rowCount;
    self.cellSize=CGSizeMake(width, height);
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self calcParam];
    
    CGFloat x=0;
    for (NSInteger i=0; i<[self btnCount]; i++) {
        id<HCYMUtableBtn> btn=[self btnAtIdx:i];
        
        UIView *aBtn=[self trueBtnInMutBtn:btn];

        if(aBtn==nil){
            continue;
        }
        NSInteger rowIdx=i/self.columnCount;
        NSInteger columnIdx=i%self.columnCount;
        
        //换行的话清空x。
        NSInteger lastRowIdx=(i-1)/self.columnCount;
        if (rowIdx!=lastRowIdx) {
            x=0;
        }
        
        CGFloat y=rowIdx*_cellSize.height;
        if (columnIdx) x+=columnIdx*self.itemMargin;
        if(rowIdx) y+=rowIdx*self.lineMargin;
        
        CGFloat btnWidth=_cellSize.width;
        CGFloat btnHeight=_cellSize.height;

        if ([btn needFixSize]==NO) {
            btnWidth=aBtn.size.width;
            btnHeight=aBtn.size.height;
        }
        
        CGRect btnRect=CGRectMake(x, y,btnWidth,btnHeight);
        x+=btnWidth;
        aBtn.frame=btnRect;
    }
}

@end
