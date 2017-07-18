//
//  DtImagePickerGroupController.h
//  CustomImagePicker
//
//  Created by hcy on 15/8/18.
//  Copyright (c) 2015年 hcy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCYImagePickerHeader.h"
/**
 *  单相册-图片
 */
@interface HCYImagePickerGroupController : UIViewController
/**
 *  单相册图片选择器
 *
 *  @param item      相册

 *
 *  @return  5
 */
-(instancetype)initWithListItem:(id<HCYImagePickerListItem> )item;

@end
