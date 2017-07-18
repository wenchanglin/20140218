
//
//  YZTitleView.m
//  kq_banbo_app
//
//  Created by hcy on 2016/12/1.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "YZTitleView.h"

@interface YZTitleView()
@property(strong,nonatomic)UILabel *label;

@end
@implementation YZTitleView
- (instancetype)initWithFrame:(CGRect)frame
{
    frame.size.height=44;
    self = [super initWithFrame:frame];
    if (self) {
        _label=[UILabel new];
        self.font=[UIFont systemFontOfSize:14.f];
        self.textColor=[UIColor whiteColor];
        self.numberOfLines=2;
        _label.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_label];
    }
    return self;
}
#pragma mark public
-(void)showInNaviItem:(UINavigationItem *)item{
    if ((item.leftBarButtonItems.count && item.rightBarButtonItems.count==0)) {
        self.width=SCREEN_WIDTH*.67;
    }else if(item.leftBarButtonItems.count==0 && item.rightBarButtonItems.count){
        self.width=SCREEN_WIDTH*.72;
    }
    else{
        self.width=SCREEN_WIDTH;
    }
    item.titleView=self;
}
#pragma mark set
-(void)setText:(NSString *)text{
    if ([text isEqualToString:_text]) {
        return;
    }
    _text=[text copy];
    _label.text=text;
    [_label sizeToFit];
}
-(void)setFont:(UIFont *)font{
    _label.font=font;
    _font=font;
}
-(void)setNumberOfLines:(NSInteger)numberOfLines{
    _label.numberOfLines=numberOfLines;
    _numberOfLines=numberOfLines;
}
-(void)setTextColor:(UIColor *)textColor{
    _label.textColor=textColor;
    _textColor=textColor;
}

#pragma mark layout
-(void)layoutSubviews{
    [super layoutSubviews];
    _label.width=self.width;
    _label.height=self.height;
    //    _label.frame=self.bounds;
}

@end
