//
//
//  kq_banbo_app
//
//  Created by hcy on 2017/3/13.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "BanBoHealthResultView.h"
@interface BanBoHealthResultView()
@property(strong,nonatomic)UIImageView *imageView;
@property(strong,nonatomic)UILabel *resultTitleLabel;
@property(strong,nonatomic)UITextView *resultContentTextView;
@property(strong,nonatomic)UIActivityIndicatorView *animationView;
@end
@implementation BanBoHealthResultView
#define resultTitleBottom2Content 9
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        
        _imageView=[UIImageView new];
        [self addSubview:_imageView];
        
        _resultTitleLabel=[YZLabelFactory blackLabel];
        _resultTitleLabel.text=@"测量结果:";
        [_resultTitleLabel sizeToFit];
        [self addSubview:_resultTitleLabel];
        
        _resultContentTextView=[UITextView new];
        _resultContentTextView.font=[YZLabelFactory bigFont];
        _resultContentTextView.height=100;
        _resultContentTextView.userInteractionEnabled=NO;
        _resultContentTextView.text=@"";
        _resultContentTextView.textColor=[UIColor blackColor];
        [self addSubview:_resultContentTextView];
        
        _animationView=[[UIActivityIndicatorView  alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_animationView sizeToFit];
        [self addSubview:_animationView];
        self.height=MAX(self.height, _resultTitleLabel.height+_resultTitleLabel.height+resultTitleBottom2Content+1);
    }
    return self;
}
#pragma mark publicMethods
-(void)beginAnimation{
    _animationView.hidden=NO;
    [_animationView startAnimating];
}
-(void)stopAnimation{
    [_animationView stopAnimating];
    _animationView.hidden=YES;
}
-(void)setResultImage:(UIImage *)image{
    _imageView.image=image;
    [_imageView sizeToFit];
    [self setNeedsLayout];
}
-(void)setResultText:(NSString *)text{
    [self stopAnimation];
    DDLogInfo(@"测量结果:%@",text);
    [_resultContentTextView setText:text];
}
#pragma mark layout
-(void)layoutSubviews{
    [super layoutSubviews];
    
    _imageView.top=6;
    _imageView.left=6;
    _imageView.height=_resultTitleLabel.height;
    
    _resultTitleLabel.bottom=_imageView.bottom;
    _resultTitleLabel.left=_imageView.right+4;
    
    _resultContentTextView.left=_resultTitleLabel.left;
    _resultContentTextView.top=_resultTitleLabel.bottom+resultTitleBottom2Content;
    _resultContentTextView.width=self.width-_resultContentTextView.left;
    
    
    _animationView.centerX=self.width*.5;
    _animationView.bottom=self.height*.6;
}
@end
