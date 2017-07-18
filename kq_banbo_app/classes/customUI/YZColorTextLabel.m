//
//  YZColorTextLabel.m
//  kq_banbo_app
//
//  Created by hcy on 2016/11/28.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "YZColorTextLabel.h"

@implementation YZColorTextLabel
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.font=[YZLabelFactory normalFont];
    }
    return self;
}
-(void)refreshWithText:(NSString *)text Val:(NSString *)val valColor:(UIColor *)valueColor{
    NSString *labelText=[NSString stringWithFormat:@"%@%@",text,val];
    NSMutableAttributedString *strM=[[NSMutableAttributedString alloc] initWithString:labelText];
    
    [strM addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, labelText.length)];
    [strM addAttribute:NSForegroundColorAttributeName value:self.textColor range:NSMakeRange(0, text.length)];
    [strM addAttribute:NSForegroundColorAttributeName value:valueColor range:NSMakeRange(text.length, val.length)];
    self.attributedText=strM;
//    [self sizeToFit];
    
}
@end
