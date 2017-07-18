//
//  BanBoHealthFourBtnViews.m
//  kq_banbo_app
//
//  Created by hcy on 2016/12/12.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoHealthFourBtnView.h"
@interface BanBoHealthFourBtnView()
@property(strong,nonatomic)NSArray *btnArr;
@property(assign,nonatomic)CGSize minSize;
@end
@implementation BanBoHealthFourBtnView
#define BtnCorrPer 0.03
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.minSize=CGSizeZero;
        [self setupSubviews];
    }
    return self;
}
-(void)setupSubviews{
    NSMutableArray *btnArrM=[NSMutableArray array];
    for (NSInteger i=0; i<4; i++) {
        UIButton *btn=[UIButton new];
        btn.titleLabel.font=[YZLabelFactory blodBigFont];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.adjustsImageWhenHighlighted=NO;
        btn.tag=i;
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btnArrM addObject:btn];
        [self addSubview:btn];
    }
    self.btnArr=[btnArrM copy];
}
-(void)setBtnViewSize:(CGSize)size{
    if (CGSizeEqualToSize(size, self.minSize) || (size.width<0 || size.height<0)) {
        return;
    }
    self.bounds=CGRectMake(0, 0, size.width, size.height);
    self.minSize=size;
    CGFloat btnWidth=MAX(0,(size.width-self.itemMargin)*.5);
    CGFloat btnHeight=MAX(0,(size.height-self.lineMargin)*.5);
    for (UIButton *btn in self.btnArr) {
        btn.layer.cornerRadius=btnWidth*BtnCorrPer;
        btn.size=CGSizeMake(btnWidth, btnHeight);
    }
    [self setNeedsLayout];
}
-(UIButton *)btnAtIdx:(NSInteger)idx{
    if (idx>=0 && idx<self.btnArr.count) {
        return self.btnArr[idx];
    }else{
        return nil;
    }
    
}
-(void)btnClicked:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(fourBtnView:clickBtnAtIdx:)]) {
        [self.delegate fourBtnView:self clickBtnAtIdx:btn.tag];
    }
}
-(void)setTitles:(NSArray *)titles{
    CGFloat maxWidth=0;
    CGFloat maxHeight=0;
    if(titles.count==_btnArr.count){
        for (NSInteger i=0; i<titles.count; i++) {
            UIButton *btn= _btnArr[i];
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            if (CGSizeEqualToSize(btn.size, CGSizeZero)) {
                [btn sizeToFit];
            }
            maxWidth=MAX(btn.width, maxWidth);
            maxHeight=MAX(btn.height, maxHeight);
        }
    }else{
        return;
    }
    BOOL needChangeFrame=NO;
    if (self.minSize.width<maxWidth) {
        self.minSize=CGSizeMake(maxWidth, self.minSize.height);
        needChangeFrame=YES;
    }
    if (self.minSize.height<maxHeight) {
        self.minSize=CGSizeMake(self.minSize.width, maxHeight);
        needChangeFrame=YES;
    }
    if (needChangeFrame) {
        for(UIButton *btn in self.btnArr){
            btn.layer.cornerRadius=maxWidth*BtnCorrPer;
            btn.bounds=CGRectMake(0, 0, maxWidth, maxHeight);
        }
    }
}
-(void)setBgColorArr:(NSArray *)bgColors{
    if (bgColors.count!=_btnArr.count) {
        return;
    }
    for (NSInteger i=0; i<_btnArr.count; i++) {
        UIButton *btn=_btnArr[i];
        [btn setBackgroundColor:bgColors[i]];
    }
}
-(void)setTitleColors:(NSArray *)titleColors forState:(UIControlState)state{
    if (titleColors.count!=_btnArr.count) {
        return;
    }
    for (NSInteger i=0; i<_btnArr.count; i++) {
        UIButton *btn=_btnArr[i];
        [btn setTitleColor:titleColors[i] forState:state];
    }
}

-(void)sizeToFit{
    UIButton *btn1=[self btnAtIdx:0];
    UIButton *btn2=[self btnAtIdx:1];
    UIButton *btn3=[self btnAtIdx:2];
    CGFloat width=btn1.width+btn2.width+_itemMargin;
    CGFloat height=btn1.height+btn3.height+_lineMargin;
    self.bounds=CGRectMake(0, 0, width, height);
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    UIButton *btn1=[self btnAtIdx:0];
    UIButton *btn2=[self btnAtIdx:1];
    UIButton *btn3=[self btnAtIdx:2];
    UIButton *btn4=[self btnAtIdx:3];
    
    CGFloat btnLeft=(self.width-self.minSize.width)*.5;
    CGFloat btnTop=(self.height-self.minSize.height)*.5;
    
    btn1.left=btnLeft;
    btn1.top=btnTop;
    
    btn2.top=btnTop;
    btn2.left=btn1.right+_itemMargin;
    
    btn3.left=btn1.left;
    btn3.top=btn1.bottom+_lineMargin;
    
    btn4.top=btn3.top;
    btn4.left=btn3.right+_itemMargin;
    
}
@end



@implementation BanBoVerBtnsView

-(void)layoutSubviews{
    
    
    
}

@end
