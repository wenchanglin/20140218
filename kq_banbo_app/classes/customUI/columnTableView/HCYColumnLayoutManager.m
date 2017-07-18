//
//  BBColumnLayoutManager.m
//  kq_banbo_app
//
//  Created by hcy on 2016/11/24.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "HCYColumnLayoutManager.h"

#pragma mark layoutModel
@interface HCYColumnLayoutModel:NSObject
@property(assign,nonatomic)NSInteger columnIdx;
/**
 当前宽度
 */
@property(assign,nonatomic)CGFloat width;

/**
 最小宽度
 */
@property(assign,nonatomic)CGFloat minWidth;

@end
@implementation HCYColumnLayoutModel
-(CGFloat)offsetWidthForMinuse:(CGFloat)minuse{
    CGFloat useAbleWidth=self.width-self.minWidth-1;
    if (useAbleWidth<0 ) {
        return 0;
    }
    if (useAbleWidth>minuse) {
        return minuse;
    }else{
        return useAbleWidth;
    }
}

-(NSString *)description{
    return [NSString stringWithFormat:@"columnIdx:%ld,width:%f,minWidth:%f",(long)_columnIdx,_width,_minWidth];
}

@end
#pragma mark misson
@interface HCYColumnLayoutAddLineMisson : NSObject
@property(strong,nonatomic)id<HCYColumnModel> model;
@property(assign,nonatomic)NSInteger idx;

@end
@implementation HCYColumnLayoutAddLineMisson



@end

#pragma mark columnLayoutManager
@interface HCYColumnLayoutManager()
{
    dispatch_queue_t _calcQueue;
}

@property(assign,nonatomic)NSInteger columnCount;
@property(strong,nonatomic)UITableView *tableView;

@property(strong,nonatomic)NSArray *columnModelArr;
@end
@interface HCYColumnLayoutManager()
@property(assign,nonatomic)CGFloat currentColumnMargin;
@property(strong,nonatomic)NSMutableArray *addLineMissons;
@end
@implementation HCYColumnLayoutManager

- (instancetype)initWithColumnCount:(NSInteger)columnCount tableView:(UITableView *)tableView
{
    DDLogDebug(@"columnLayoutManager Init:%ld,tableView:%@",(long)columnCount,tableView);
    self = [super init];
    if (self) {
        _columnCount=columnCount;
        _tableView=tableView;
        [tableView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        _calcQueue=dispatch_queue_create("columnCalcQueue", DISPATCH_QUEUE_SERIAL);
        _canMinuseColumnHeader=NO;
        _adjustsFontSizeToFitWidth=NO;
        self.tableViewEdge=UIEdgeInsetsMake(0, 20, 0, 20);
        self.minColumnMargin=10;
        [self cleanData];
    }
    return self;
}
-(void)dealloc{
    [_tableView removeObserver:self forKeyPath:@"frame"];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSValue *newVal=change[NSKeyValueChangeNewKey];
    NSValue *oldVal=change[NSKeyValueChangeOldKey];
    if ([oldVal isEqual:newVal]==NO) {
        if ([newVal CGRectValue].size.width!=[oldVal CGRectValue].size.width) {
            [self cleanData];
        }
    }
}
-(void)cleanData{
    NSMutableArray *tmpArrM=[NSMutableArray array];
    for (NSInteger i=0; i<self.columnCount; i++) {
        HCYColumnLayoutModel *model=[HCYColumnLayoutModel new];
        model.columnIdx=i;
        model.minWidth=0;
        model.width=0;
        [tmpArrM addObject:model];
    }

    self.columnModelArr=[tmpArrM copy];
}
-(void)refreshHeader:(id<HCYColumnModel>)header{
    if([header isEqual:_columnHeader]==NO){
        NSInteger aCount=[header titleCount];
        if (aCount!=self.columnCount) {
            self.columnCount=aCount;
        }
        [self cleanData];
    }
    
    for (NSInteger i=0; i<self.columnCount; i++){
        NSString *title=[header titleAtIndex:i];
        UIFont *font=[header fontAtIndex:i];
        CGSize size=[self sizeWithText:title font:font idx:i];
        HCYColumnLayoutModel *columnModel=self.columnModelArr[i];
        CGFloat width=size.width;
        if ([header respondsToSelector:@selector(extWidthAtIdx:)]) {
            width+=[header extWidthAtIdx:i];
        }
        columnModel.minWidth=width;
        columnModel.width=width;
    }
    self.columnHeader=header;
    [self checkColumnMargin];
}

-(void)addModels:(NSArray *)models{
    
    self.addLineMissons=[NSMutableArray array];
    for(id<HCYColumnModel> model in models){
        for (NSInteger i=0; i<self.columnCount; i++) {
            if ([self isNecessaryCalcForModel:model idx:i]) {
                NSString *title=[model titleAtIndex:i];
                NSLog(@"abes:%@",title);
                UIFont *font=[model fontAtIndex:i];
                CGSize size=[self sizeWithText:title font:font idx:i];
                [self modifyColumnToSize:size idx:i data:model];
            }
        }
        [self checkColumnMargin];
    }
    if (self.addLineMissons.count && self.adjustsFontSizeToFitWidth==NO) {
        [self calcAddLine];
    }
//    DDLogDebug(@"columnLayoutManager addModelsEnd:%@",self.columnModelArr);
}

-(void)calcAddLine{
    DDLogDebug(@"exec addLineMisson");
    for (HCYColumnLayoutAddLineMisson *misson in self.addLineMissons) {
        NSInteger idx=misson.idx;
        id<HCYColumnModel> data=misson.model;
        HCYColumnLayoutModel *columnModel=self.columnModelArr[idx];
        
        CGFloat cellHeight= [data cellHeight];
        NSString *title=[data titleAtIndex:idx];
        UIFont *font=[data fontAtIndex:idx];
        CGSize titleSize=[self sizeWithText:title size:CGSizeMake(columnModel.width, MAXFLOAT) font:font idx:idx];
        if(titleSize.height-cellHeight>-1){
            [data setCellHeight:ceilf(titleSize.height+2)];//加了个separView所以么。加个2好看点。上下还有点距离
            DDLogInfo(@"addLine");
        }else{
            DDLogInfo(@"enoughHeight");
        }
    }
}
-(void)checkColumnMargin{
    CGFloat maxWidth=0;
    for (HCYColumnLayoutModel *model in self.columnModelArr) {
        maxWidth+=model.width;
    }
    if (maxWidth+self.minColumnMargin*(self.columnCount-1)<self.tableView.width) {
        self.currentColumnMargin=(self.tableView.width-maxWidth)/self.columnCount;
    }else{
        self.currentColumnMargin=0;
    }
}
-(BOOL)isNecessaryCalcForModel:(id<HCYColumnModel>)model idx:(NSInteger)idx{
    NSString *title=[model titleAtIndex:idx];
    UIFont *font=[model fontAtIndex:idx];
    HCYColumnLayoutModel *columnModel=[self modelAtIdx:idx];
    if (self.canMinuseColumnHeader==NO && columnModel.minWidth==0) {
        columnModel.minWidth=[title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:0 attributes:@{NSFontAttributeName:font} context:nil].size.width;
        return YES;
    }
    CGFloat neWidth=[title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:0 attributes:@{NSFontAttributeName:font} context:nil].size.width;
    return neWidth>columnModel.width;
    
}
-(HCYColumnLayoutModel *)modelAtIdx:(NSInteger)idx{
    return self.columnModelArr[idx];
}
-(void)modifyColumnToSize:(CGSize)size idx:(NSInteger)idx data:(id<HCYColumnModel>)data{
    HCYColumnLayoutModel *columnModel=[self modelAtIdx:idx];
    //超长了
    if (size.width>columnModel.width) {
        //说明还能缩放
        if (self.currentColumnMargin>self.minColumnMargin) {
            //还能缩放多少
            CGFloat maxMargin=(self.currentColumnMargin-self.minColumnMargin)*(self.columnCount-1)-20;
            //需要缩放多少
            CGFloat minus=size.width-columnModel.width;
            if(maxMargin>minus){
                columnModel.width=size.width;
            }else{
                //需要换行，当前列的宽就变到他那份的最大
                if (maxMargin>0 ){
                    CGFloat mineMargin= maxMargin/(CGFloat)self.columnCount;
                    columnModel.width+=mineMargin;
                }
                //换行操作留到最后。等所有的行都算完了再来
                HCYColumnLayoutAddLineMisson *misson=[HCYColumnLayoutAddLineMisson new];
                misson.model=data;
                misson.idx=idx;
                [self.addLineMissons addObject:misson];
            }
            [self checkColumnMargin];
        }

    }else{
        columnModel.width=size.width;
    }

}

-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font idx:(NSInteger)i{
    return [self sizeWithText:text size:CGSizeMake(MAXFLOAT, MAXFLOAT) font:font idx:i];
    
}
-(CGSize)sizeWithText:(NSString *)text size:(CGSize)size font:(UIFont *)font idx:(NSInteger)i{
    return [text boundingRectWithSize:size options:(NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:font} context:nil].size;
    
}
-(CGRect)rectForColumnAtIndex:(NSInteger)columnIdx row:(NSIndexPath *)path{
    return CGRectMake([self xAtIdx:columnIdx], 0, [self widhtForColumn:columnIdx],0);
}
-(CGFloat)xAtIdx:(NSInteger)columnIdx{
    CGFloat left=self.tableViewEdge.left;
    for (NSInteger i=0; i<columnIdx; i++) {
        left+=[self widhtForColumn:i];
        left+=MAX(self.minColumnMargin,self.currentColumnMargin);
    }
    return left;
    
}
-(CGFloat)widhtForColumn:(NSInteger)columnIdx{
   return  [[self modelAtIdx:columnIdx] width];
 }
@end


