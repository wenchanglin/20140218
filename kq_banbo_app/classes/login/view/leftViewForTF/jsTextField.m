//
//  jsTextField.m
//  呵呵哒
//
//  Created by 王刚 on 2017/4/1.
//  Copyright © 2017年 sxbl. All rights reserved.
//

#import "jsTextField.h"

@implementation jsTextField
-(id)initWithFrame:(CGRect)frame drawingLeft:(UIImageView *)icon{
    self=[super initWithFrame:frame];
    if (self) {
        self.rightView=icon;
        self.rightViewMode=UITextFieldViewModeAlways;
}
    return self;
}
//-(CGRect)leftViewRectForBounds:(CGRect)bounds{
//    CGRect iconRect=[super leftViewRectForBounds:bounds];
//    iconRect.origin.x +=5;
//    return iconRect;
//}
- (CGRect)rightViewRectForBounds:(CGRect)bounds
{
    CGRect iconRect=[super rightViewRectForBounds:bounds];
        iconRect.origin.x -=15;
        return iconRect;
}

@end
