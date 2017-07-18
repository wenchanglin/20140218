//
//  BanBoVRCondiView.m
//  kq_banbo_app
//
//  Created by banbo on 2017/6/26.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "BanBoVRCondiView.h"
#import "BanBoLineHeaderView.h"
#import "BanBoBanZhuSelectView.h"
#define BanzhuSelectDefaultText @"请选择班组"
@interface BanBoVRCondiView()<UITextFieldDelegate>
@property(strong,nonatomic)BanBoLineHeaderView *banzhuLabel;
@property(strong,nonatomic)BanBoLineHeaderView *xiaobanzhuLabel;
@property(strong,nonatomic)BanBoLineHeaderView *gongrenLabel;

@property(strong,nonatomic)UITextField *gongrenField;
@property(strong,nonatomic)UIButton *searchBtn;


@end
@implementation BanBoVRCondiView
- (instancetype)initWithFrame:(CGRect)frame
{
    CGFloat lineViewHeight=[BanBoLayoutParam shiminLineViewHeight];
    frame.size.height=lineViewHeight*3;
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
        [self getCacheData];
    }
    
    return self;
}
-(void)setupSubviews{
    BanBoLineHeaderView *banzhuLabel=[self makeLineHeaderView];
    banzhuLabel.leftLabel.text=@"班  组 ";
    [banzhuLabel.leftLabel sizeToFit];
    banzhuLabel.leftLabel.width*=1.4;
    
    banzhuLabel.rightLabel.text=BanzhuSelectDefaultText;
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
    
    BanBoLineHeaderView *gongrenLabel=[self makeLineHeaderView];
    gongrenLabel.leftLabel.text=@"工  人  ";
    gongrenLabel.leftLabel.width=banzhuLabel.leftLabel.width;
    
    [self addSubview:gongrenLabel];
    gongrenLabel.top=xiaobanzhuLabel.top;
    self.gongrenLabel=gongrenLabel;
    
    UIButton *searchBtn=[UIButton new];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn setImage:[UIImage imageNamed:@"搜索"] forState:UIControlStateNormal];
    searchBtn.titleLabel.font=[YZLabelFactory normalFont];
    searchBtn.adjustsImageWhenHighlighted=NO;
    [searchBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [searchBtn sizeToFit];
    [searchBtn addTarget:self action:@selector(searchBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [gongrenLabel addSubview:searchBtn];
    _searchBtn=searchBtn;
    
    UITextField *gongrenField=[UITextField new];
    gongrenField.enablesReturnKeyAutomatically=YES;
    gongrenField.returnKeyType=UIReturnKeySearch;
    gongrenField.delegate=self;
    gongrenField.font=[YZLabelFactory normalFont];
    gongrenField.placeholder=@"请输入姓名或工号";
    [gongrenLabel addSubview:gongrenField];
    _gongrenField=gongrenField;
}
#pragma mark events
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.gongrenField endEditing:YES];
}
-(void)searchBtnClicked:(UIButton *)btn{
    
    [self.gongrenField endEditing:YES];
    [[YZCacheManager sharedInstance] addCache:self.gongrenField.text forKey:YZCacheKeyGongren type:YZCacheTypeMemory];
    [self noticeSearch];
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
#pragma mark delegate
-(void)noticeConditionChanged{
    if ([self.delegate respondsToSelector:@selector(conditionViewConditionChanged:)]) {
        [self.delegate conditionViewConditionChanged:self];
    }
    
}
-(void)noticeSearch{
    if([self.delegate respondsToSelector:@selector(conditionView:searchBtnClicked:)]){
        [self.delegate conditionView:self searchBtnClicked:self.searchBtn];
    }
}
#pragma mark cache相关
-(void)getCacheData{
    id banzhu=[[YZCacheManager sharedInstance] cacheForKey:YZCacheKeyBanzhuItem type:YZCacheTypeMemory];
    id xiaobanzhu=[[YZCacheManager sharedInstance] cacheForKey:YZCacheKeyXiaoBanzhuItem type:YZCacheTypeMemory];
    id gongren=[[YZCacheManager sharedInstance] cacheForKey:YZCacheKeyGongren type:YZCacheTypeMemory];
    if (banzhu) {
        self.banzhu=banzhu;
    }
    if (xiaobanzhu) {
        self.xiaobanzhu=xiaobanzhu;
    }
    if (gongren) {
        self.gongrenField.text=gongren;
    }
    [self refreshLabel];
}


-(void)cacheBanzhu:(id)banzhu{
    self.banzhu=banzhu;
    NSLog(@"代码192行da:%@",banzhu);
    [[YZCacheManager sharedInstance] addCache:banzhu forKey:YZCacheKeyBanzhuItem type:YZCacheTypeMemory];
}
-(void)cacheXiaoBanzhu:(id)xiaobanzhu{
    NSLog(@"代码200行xiao:%@",xiaobanzhu);
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
#pragma mark textFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    [self noticeSearch];
    return YES;
}
#pragma mark param
@dynamic gongren;
-(NSString *)gongren{
    return self.gongrenField.text;
}
-(void)setGongren:(NSString *)gongren{
    self.gongrenField.text=gongren;
}
#pragma mark layout
-(void)layoutSubviews{
    [super layoutSubviews];
    self.banzhuLabel.width=self.width;
    
    self.xiaobanzhuLabel.top=self.banzhuLabel.bottom;
    self.xiaobanzhuLabel.width=self.width;
    
    self.gongrenLabel.top=self.xiaobanzhuLabel.bottom;
    self.gongrenLabel.width=self.width;
    
    _searchBtn.right=self.width-20;
    _searchBtn.centerY=_gongrenLabel.height*.5;
    
    _gongrenField.left=_gongrenLabel.rightLabel.left;
    _gongrenField.top=0;
    _gongrenField.height=_gongrenLabel.height;
    _gongrenField.width=(_searchBtn.left- _gongrenField.left-10);
    
}
-(BanBoLineHeaderView *)makeLineHeaderView{
    BanBoLineHeaderView *lineHeader=[BanBoLineHeaderView new];
    
    CGFloat lineViewHeight=[BanBoLayoutParam shiminLineViewHeight];
    CGFloat lineViewLeft=20;
    lineHeader.leftLabel.textColor = [UIColor hcy_colorWithString:@"#fda803"];//#fda803
    lineHeader.bottomSeparView.left=lineViewLeft;
    lineHeader.leftLabel.left=lineViewLeft;
    lineHeader.verSeparPercent=0.7;
    lineHeader.height=lineViewHeight;
    lineHeader.left=0;
    
    return lineHeader;
}

@end
