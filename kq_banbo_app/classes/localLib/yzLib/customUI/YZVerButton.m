//
//  YZVerButton.m
//  kq_banbo_app
//
//  Created by hcy on 2016/11/30.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "YZVerButton.h"

@implementation YZVerButton
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setTitleColor:BanBoLabelGrayColor forState:UIControlStateNormal];
        self.titleLabel.font=[YZLabelFactory normalFont];
        self.titleLabel.textAlignment=NSTextAlignmentCenter;
    }
    return self;
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    NSString *title=[self currentTitle];
    if (title.length) {
        CGSize titleSize=[title sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
        return CGRectMake(0, contentRect.size.height-titleSize.height-1, self.width, titleSize.height+1);
    }else{
        return CGRectZero;
    }
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    UIImage *image=[self currentImage];
    if (image) {
        return CGRectMake(MAX(0, (contentRect.size.width-image.size.width)*.5), 5, image.size.width, image.size.height);
        
    }else{
        return CGRectZero;
    }
}
-(void)sizeToFit{
    CGRect imageRect=  [self imageRectForContentRect:self.bounds];
    CGRect titleRect=[self titleRectForContentRect:self.bounds];
    CGRect z=CGRectZero;
    z.size=CGSizeMake(MAX(imageRect.size.width, titleRect.size.width), imageRect.size.height+titleRect.size.height+5);
    
    self.bounds=z;
    
}
@end
