//
//  BanBoCardNumberView.m
//  kq_banbo_app
//
//  Created by hcy on 2016/12/27.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoCardNumberView.h"
@interface BanBoCardNumberView()<UITextFieldDelegate>
@property(strong,nonatomic)UIButton *minuseBtn;
@property(strong,nonatomic)UITextField *contentField;
@property(strong,nonatomic)UIButton *plusBtn;
@property(strong,nonatomic)NSPredicate *numberPredicate;

@end
@implementation BanBoCardNumberView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
        self.min=0;
        self.max=10000;
        self.numberPredicate=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"\\d+"];
    }
    return self;
}
-(void)setupSubviews{
    _minuseBtn=[UIButton new];
    
    _minuseBtn.adjustsImageWhenHighlighted=NO;
    [_minuseBtn addTarget:self action:@selector(minuseBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_minuseBtn setBackgroundImage:[UIImage imageNamed:@"jianhao"] forState:UIControlStateNormal];
    [_minuseBtn sizeToFit];
    
    
    [self addSubview:_minuseBtn];
    
    _plusBtn=[UIButton new];
    
    _plusBtn.adjustsImageWhenHighlighted=NO;
    [_plusBtn addTarget:self action:@selector(plusBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_plusBtn setBackgroundImage:[UIImage imageNamed:@"jiahao"] forState:UIControlStateNormal];
    [_plusBtn sizeToFit];
    
    [self addSubview:_plusBtn];
    
    _contentField=[UITextField new];
    _contentField.returnKeyType=UIReturnKeyDone;
    _contentField.text=@"0";
    _contentField.font=[YZLabelFactory normalFont];
    _contentField.delegate=self;
    _contentField.textAlignment=NSTextAlignmentCenter;
    [self addSubview:_contentField];
}
#pragma mark btnEvents
-(void)minuseBtnClicked:(UIButton *)btn{
    NSInteger val=[self.contentField.text integerValue];
    val--;
    [self setVal:val];
}
-(void)plusBtnClicked:(UIButton *)btn{
    NSInteger val=[self.contentField.text integerValue];
    val++;
    [self setVal:val];
}
-(void)setVal:(NSInteger)val{
    if (val<self.min || val>self.max) {
        return;
    }
    NSString *str=[NSString stringWithFormat:@"%ld",(long)val];
    self.contentField.text=str;
}
-(void)setCurrentNumber:(NSInteger)currentNumber{
    if (currentNumber<self.min || currentNumber>self.max) {
        return;
    }
    _currentNumber=currentNumber;
    [self setVal:currentNumber];
}
#pragma mark textFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [textField endEditing:YES];
        return YES;
    }
    
    if ([self.numberPredicate evaluateWithObject:string]) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark layout
-(void)layoutSubviews{
    [super layoutSubviews];
    _minuseBtn.left=0;
    _minuseBtn.centerY=self.height*.5;
    
    _plusBtn.right=self.width;
    _plusBtn.centerY=self.height*.5;
    
    _contentField.left=_minuseBtn.right+5;
    _contentField.width=_plusBtn.left-_contentField.left;
    _contentField.height=self.height;
}
@end
