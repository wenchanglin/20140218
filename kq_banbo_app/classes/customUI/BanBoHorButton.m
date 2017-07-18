//
//  BanBoHorButton.m
//  kq_banbo_app
//
//  Created by hcy on 2016/11/28.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoHorButton.h"

@implementation BanBoHorButton
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setTitleColor:BanBoLabelGrayColor forState:UIControlStateNormal];
        self.titleLabel.font=[YZLabelFactory normalFont];
        self.userInteractionEnabled=NO;
    }
    return self;
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    UIImage *image=[self imageForState:self.state];
    CGRect titleRect=[self titleRectForContentRect:contentRect];
    CGFloat y=0;
    if (titleRect.size.height>image.size.height) {
        y=(titleRect.size.height-image.size.height)*.5;
    }
    return CGRectMake(CGRectGetMaxX(titleRect)+4, y, image.size.width, image.size.height);
    
}
-(CGRect)titleRectForContentRect:(CGRect)contentRect{
        NSString *title=[self titleForState:self.state];
        if (title.length) {
            CGSize size=[title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:0 attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil].size;
            return CGRectMake(0, 0, size.width, size.height);
        }else{
            return CGRectZero;
        }
}
-(void)sizeToFit{
    
    CGRect imageRect=[self imageRectForContentRect:self.bounds];
    CGRect titleRect=[self titleRectForContentRect:self.bounds];
    self.width=CGRectGetMaxX(imageRect)+1;
    self.height=MAX(CGRectGetHeight(imageRect), CGRectGetHeight(titleRect))+1;
    
}
@end
