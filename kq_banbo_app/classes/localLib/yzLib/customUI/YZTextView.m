//
//  YZTextView.m
//  WorkChat
//
//  Created by hcy on 2016/10/31.
//  Copyright © 2016年 HCY. All rights reserved.
//

#import "YZTextView.h"
#import "UIView+HCY.h"
@interface YZTextView()<UITextViewDelegate>
@property(strong,nonatomic)CATextLayer *placeHolderLayer;
@property(strong,nonatomic)UITextView *textView;
@property(assign,nonatomic)CGPoint textStartPoint;

@property(strong,nonatomic)UILabel *wordCountLabel;
@end
@implementation YZTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupTextView];
        [self setupPlaceHolder];
        [self setupWordCount];
    }
    return self;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(BOOL)isFirstResponder{
    return [self.textView isFirstResponder];
}
#pragma mark textView
-(void)setupTextView{
    _textView=[[UITextView alloc] initWithFrame:self.bounds];

    _textView.font=[UIFont systemFontOfSize:16.f];
    _textView.delegate=self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:self.textView];
    [self addSubview:_textView];

}
@dynamic text;
-(NSString *)text{
    return _textView.text;
}
-(void)setText:(NSString *)text{
    self.textView.text=text;
}
#pragma mark placeHolder
-(void)setupPlaceHolder{
    self.yz_placeHolder=@"";
    _placeHolderLayer=[[CATextLayer alloc] init];
    UIFont *font=_textView.font;
    _placeHolderLayer.font=(__bridge CFTypeRef)font;
    _placeHolderLayer.fontSize=font.lineHeight;
    _placeHolderLayer.foregroundColor=[UIColor grayColor].CGColor;
    _placeHolderLayer.wrapped=YES;
    _placeHolderLayer.contentsScale=[UIScreen mainScreen].scale;
    [self.layer addSublayer:_placeHolderLayer];
    //获取光标位置修正placeHolderlayer
    UITextRange *range = _textView.selectedTextRange;
    CGRect  rect = [_textView caretRectForPosition:range.start];
    _textStartPoint=rect.origin;
}
-(void)setYz_placeHolder:(NSString *)yz_placeHolder{
    if ([yz_placeHolder isEqualToString:_yz_placeHolder]) {
        return;
    }
    _yz_placeHolder=[yz_placeHolder copy];
    self.placeHolderLayer.string=[yz_placeHolder copy];
}
#pragma mark wordCount
-(void)setupWordCount{
    UIFont *textFont=self.textView.font;
    UIFont *workCountFont=[UIFont fontWithName:textFont.fontName size:textFont.pointSize-2];
    
    _wordCountLabel=[UILabel new];
    _wordCountLabel.font=workCountFont;
    _wordCountLabel.textColor=[UIColor grayColor];
    _wordCountLabel.hidden=YES;
    
    [self addSubview:_wordCountLabel];
    
}
-(void)setNeedShowMaxCount:(BOOL)needShowMaxCount{
    if (needShowMaxCount==_needShowMaxCount) {
        return;
    }
    _needShowMaxCount=needShowMaxCount;
    if(needShowMaxCount && _wordCountLabel.isHidden){
        _wordCountLabel.hidden=NO;
    }
    if (needShowMaxCount==NO && _wordCountLabel.isHidden==NO) {
        _wordCountLabel.hidden=YES;
    }
    [self refreshWordCount];
}
-(void)refreshWordCount{
    _wordCountLabel.text=[self workCountText];
    [_wordCountLabel sizeToFit];
    [self layoutIfNeeded];
}
-(NSString *)workCountText{
    NSInteger length=self.textView.text.length;
    NSInteger count=self.maxCount;
    return [NSString stringWithFormat:@"%ld/%ld",(long)length,(long)count];
}
#pragma mark notification
-(void)textChanged:(NSNotification *)notification{
    if (self.textView.text.length && _placeHolderLayer.isHidden==NO) {
        _placeHolderLayer.hidden=YES;
    }
    if (self.textView.text.length==0 && _placeHolderLayer.isHidden==YES) {
        _placeHolderLayer.hidden=NO;
    }
    [self refreshWordCount];
}
#pragma mark textViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSInteger length1=textView.text.length;
    NSInteger length2=text.length;
    if (length1+length2>self.maxCount && self.maxCount>0) {
        return NO;
    }else{
        return YES;
    }
}


#pragma mark layout
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat x=self.textStartPoint.x;
    CGFloat y=self.textStartPoint.y;
    _placeHolderLayer.frame=CGRectMake(x,y, CGRectGetWidth(self.bounds)-x, CGRectGetHeight(self.bounds)-y);
    
    if (self.needShowMaxCount) {
        _wordCountLabel.right=self.width-20;
        _wordCountLabel.bottom=self.height-10;
        self.textView.left=0;
        self.textView.top=0;
        self.textView.width=self.width;
        self.textView.height=self.height-(10+_wordCountLabel.height);
        
    }else{
        self.textView.frame=self.bounds;
        self.wordCountLabel.frame=CGRectZero;
    }
    
}

@end
