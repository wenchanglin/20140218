//
//  BanBoHealthImageView.m
//  kq_banbo_app
//
//  Created by hcy on 2016/12/12.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoHealthImageView.h"

@implementation BanBoHealthImageView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView=[[UIImageView alloc] init];
        [self addSubview:_imageView];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect imageRect=CGRectInset(self.bounds, self.imageViewInset.x, self.imageViewInset.x);
    self.imageView.frame=imageRect;
}

@end

@interface BanBoHealthImageViewSecond()
@property(strong,nonatomic)UIImageView *bb_centerImageView;
@property(strong,nonatomic)UILabel*    bb_centerLabel;
@end
@implementation BanBoHealthImageViewSecond
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *centerImageView=[UIImageView new];
        [self addSubview:centerImageView];
        _bb_centerImageView=centerImageView;
        
        UILabel *centerLabel=[UILabel new];
        centerLabel.textColor=[UIColor hcy_colorWithString:@"#999999"];
        [self addSubview:centerLabel];
        _bb_centerLabel=centerLabel;
        
    }
    return self;
}

-(void)setBb_centerImage:(UIImage *)bb_centerImage{
    _bb_centerImage=bb_centerImage;
    _bb_centerImageView.image=bb_centerImage;
    [_bb_centerImageView sizeToFit];
    [self setNeedsLayout];
}
-(void)setBb_centerText:(NSString *)bb_centerText{
    _bb_centerText=[bb_centerText copy];
    _bb_centerLabel.text=bb_centerText;
    [_bb_centerLabel sizeToFit];
    [self setNeedsLayout];
}
-(void)bb_hiddenOverlay{
    _bb_centerText=@"";
    _bb_centerImage=nil;
    [self setNeedsLayout];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    if (_bb_centerImage) {
        _bb_centerImageView.centerX=self.width*.5;
        _bb_centerImageView.top=self.height*.3;
        _bb_centerLabel.hidden=NO;
        _bb_centerLabel.top=_bb_centerImageView.bottom+8;
        _bb_centerLabel.centerX=self.width*.5;
    }else{
        _bb_centerImageView.frame=CGRectZero;
        _bb_centerLabel.hidden=YES;
    }
}

@end
