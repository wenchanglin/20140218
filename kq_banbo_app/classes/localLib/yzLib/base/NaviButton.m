//
//  NaviButton.m
//  NIM
//
//  Created by hcy on 15/3/26.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NaviButton.h"

@implementation NaviButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, 0, 0, 0);
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    return contentRect;
}
@end
