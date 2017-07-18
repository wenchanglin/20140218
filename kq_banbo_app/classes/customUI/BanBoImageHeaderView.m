//
//  BanBoImageHeaderView.m
//  kq_banbo_app
//
//  Created by hcy on 2016/12/1.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoImageHeaderView.h"
@interface BanBoImageHeaderView()
@property(strong,nonatomic)UILabel *label;
@end
@implementation BanBoImageHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    frame.size=CGSizeMake(SCREEN_WIDTH, 64);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor hcy_colorWithString:@"#f0f0f0"];
        [self setupSubviews];
    }
    return self;
}
-(void)setupSubviews{
    UIImageView *iconView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"huamingce"]];
    iconView.left=22;
    iconView.top=10;
    
    [self addSubview:iconView];
    
    UILabel *label=[YZLabelFactory grayLabel];
    label.textColor=[UIColor hcy_colorWithString:@"#666666"];
    label.centerY=iconView.centerY*.8;
    label.left=iconView.right+20;
    self.label=label;
    [self addSubview:label];
}
-(void)setText:(NSString *)text{
    if ([text isEqualToString:_text]) {
        return;
    }
    _text=[text copy];
    self.label.text=text;
    [self.label sizeToFit];
}

@end
