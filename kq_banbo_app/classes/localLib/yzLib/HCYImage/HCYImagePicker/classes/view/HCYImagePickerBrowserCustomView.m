
//
//  HCYImagePickerBrowserCustomView.m
//  HCYImagePickerDemo
//
//  Created by hcy on 16/8/16.
//  Copyright © 2016年 hcy. All rights reserved.
//

#import "HCYImagePickerBrowserCustomView.h"
#import "HCYImagePickerCollector.h"
@implementation HCYImagePickerBrowserCustomView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         _dataCollector=[HCYImagePickerCollector sharedCollector];
    }
    return self;
}
-(void)refreshWithItem:(id<HCYImagePickerContentItem>)item{
    _item=item;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
