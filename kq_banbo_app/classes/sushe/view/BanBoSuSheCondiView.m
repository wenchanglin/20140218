//
//  BanBoSuSheCondiView.m
//  kq_banbo_app
//
//  Created by banbo on 2017/4/24.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "BanBoSuSheCondiView.h"
@interface BanBoSuSheCondiView()

@end

@implementation BanBoSuSheCondiView
-(instancetype)initWithFrame:(CGRect)frame
{
    CGFloat lineViewHeight = [BanBoLayoutParam shiminLineViewHeight];
    frame.size.height = lineViewHeight * 3;
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
        [self getCacheData];
    }
    return self;
}
-(void)setupSubviews
{
    BanBoLineHeaderView * banzhuLabel = [self makeLineHeaderView];
    banzhuLabel.leftLabel.text = @"班 组";
    [banzhuLabel.leftLabel sizeToFit];
    banzhuLabel.leftLabel.width *=1.4;
    banzhuLabel.rightLabel.text = BanzhuSelectDefaultText;
    banzhuLabel.rightLabel.textColor=[UIColor lightGrayColor];
    banzhuLabel.rightLabel.userInteractionEnabled=YES;
    banzhuLabel.rightLabel.tag=1;
    [banzhuLabel.rightLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectBanzhu:)]];
    
    [self addSubview:banzhuLabel];
    self.banzhuLabel=banzhuLabel;
    BanBoLineHeaderView *xiaobanzhuLabel=[self makeLineHeaderView];
    xiaobanzhuLabel.leftLabel.text=@"小班组";
    xiaobanzhuLabel.leftLabel.width=banzhuLabel.leftLabel.width;
    xiaobanzhuLabel.rightLabel.text=BanzhuSelectDefaultText;
    xiaobanzhuLabel.rightLabel.textColor=[UIColor lightGrayColor];
    xiaobanzhuLabel.rightLabel.userInteractionEnabled=YES;
    xiaobanzhuLabel.rightLabel.tag=2;
    [xiaobanzhuLabel.rightLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectBanzhu:)]];
    
    [self addSubview:xiaobanzhuLabel];
    xiaobanzhuLabel.top=banzhuLabel.top;
    self.xiaobanzhuLabel=xiaobanzhuLabel;
   
    
}

-(void)selectBanzhu:(UITapGestureRecognizer *)tap{
    UILabel *label=(UILabel*)tap.view;
    if (!self.window) {
        return;
    }
    if (label.tag==1) {
        BanBoBanZhuSelectView *selectView=[BanBoBanZhuSelectView banZhuSelectView];
        __weak typeof(selectView) wselect=selectView;
        selectView.completionBlock=^(BanBoBanzhuItem *item ,BOOL isCancel){
            [wselect dismiss];
            //班组选择变的时候清除小班组选择
            if (isCancel) {
                return ;
            }
            
            if ([item isDefaultItem]) {
                [self cleanCache];
            }else{
                if ([self.banzhu isEqual:item]==NO) {
                    [self cacheBanzhu:item];
                    [self cleanXiaoBanzhu];
                }else{
                    return;
                }
            }
            [self refreshLabel];
        };
        [selectView showInView:[self window]];
    }else if (label.tag==2){
        if (self.banzhu==nil) {
            [HCYUtil toastMsg:@"请先选择班组" inView:self];
            return;
        }
        BanBoBanZhuSelectView *selectView=[BanBoBanZhuSelectView xiaoBanzhuSelectViewWithBanzhuItem:self.banzhu];
        __weak typeof(selectView) wselect=selectView;
        
        selectView.completionBlock=^(BanBoBanzhuItem *item ,BOOL isCancel){
            [wselect dismiss];
            if(isCancel){
                return ;
            }
            if (!isCancel) {
                if ([item isDefaultItem]) {
                    [self cleanXiaoBanzhu];
                }else{
                    [self cacheXiaoBanzhu:item];
                }
            }
            [self refreshLabel];
        };
        [selectView showInView:[self window]];
    }
}
-(void)refreshLabel{
    self.banzhuLabel.rightLabel.text=self.banzhu?self.banzhu.groupname:BanzhuSelectDefaultText;
    [self.banzhuLabel.rightLabel sizeToFit];
    self.xiaobanzhuLabel.rightLabel.text=self.xiaobanzhu?self.xiaobanzhu.groupname:BanzhuSelectDefaultText;
    [self.xiaobanzhuLabel.rightLabel sizeToFit];
    [self noticeConditionChanged];
}
#pragma mark - delegate
-(void)noticeConditionChanged{
    if ([self.delegate respondsToSelector:@selector(conditionViewConditionChanged:)]) {
        [self.delegate conditionViewConditionChanged:self];
    }
    
}
#pragma mark - cache相关
-(void)getCacheData{
    id banzhu=[[YZCacheManager sharedInstance] cacheForKey:YZCacheKeyBanzhuItem type:YZCacheTypeMemory];
    id xiaobanzhu=[[YZCacheManager sharedInstance] cacheForKey:YZCacheKeyXiaoBanzhuItem type:YZCacheTypeMemory];
    if (banzhu) {
        self.banzhu=banzhu;
    }
    if (xiaobanzhu) {
        self.xiaobanzhu=xiaobanzhu;
    }
    
    [self refreshLabel];
}

-(void)cacheBanzhu:(id)banzhu{
    self.banzhu=banzhu;
    [[YZCacheManager sharedInstance] addCache:banzhu forKey:YZCacheKeyBanzhuItem type:YZCacheTypeMemory];
}
-(void)cacheXiaoBanzhu:(id)xiaobanzhu{
    self.xiaobanzhu=xiaobanzhu;
    [[YZCacheManager sharedInstance] addCache:xiaobanzhu forKey:YZCacheKeyXiaoBanzhuItem type:YZCacheTypeMemory];
}
-(void)cleanCache{
    [self cleanBanzhu];
    [self cleanXiaoBanzhu];
}
-(void)cleanBanzhu{
    self.banzhu=nil;
    [[YZCacheManager sharedInstance] removeCacheForKey:YZCacheKeyBanzhuItem type:YZCacheTypeMemory];
}
-(void)cleanXiaoBanzhu{
    self.xiaobanzhu=nil;
    [[YZCacheManager sharedInstance] removeCacheForKey:YZCacheKeyXiaoBanzhuItem type:YZCacheTypeMemory];
}
#pragma mark - layout
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.banzhuLabel.width=self.width;
    self.xiaobanzhuLabel.top=self.banzhuLabel.bottom;
    self.xiaobanzhuLabel.width=self.width;
}
-(BanBoLineHeaderView *)makeLineHeaderView{
    BanBoLineHeaderView *lineHeader=[BanBoLineHeaderView new];
    
    CGFloat lineViewHeight=[BanBoLayoutParam shiminLineViewHeight];
    CGFloat lineViewLeft=20;
    
    lineHeader.bottomSeparView.left=lineViewLeft;
    lineHeader.leftLabel.left=lineViewLeft;
    lineHeader.verSeparPercent=0.7;
    lineHeader.height=lineViewHeight;
    lineHeader.left=0;
    
    return lineHeader;
}
@end
