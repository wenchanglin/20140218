//
//  HCYImagePickerBrowserCustomView.h
//  HCYImagePickerDemo
//
//  Created by hcy on 16/8/16.
//  Copyright © 2016年 hcy. All rights reserved.
//


#import "HCYImagePickerHeader.h"
@class HCYImagePickerCollector;
@interface HCYImagePickerBrowserCustomView : UIView
@property(strong,nonatomic,readonly)HCYImagePickerCollector *dataCollector;
@property(strong,nonatomic,readonly)id<HCYImagePickerContentItem> item;
-(void)refreshWithItem:(id<HCYImagePickerContentItem>)item;
@end
