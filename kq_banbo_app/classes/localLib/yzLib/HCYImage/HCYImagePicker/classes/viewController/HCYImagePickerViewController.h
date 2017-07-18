//
//  DtImagePickerViewController.h
//  CustomImagePicker
//
//  Created by hcy on 15/8/18.
//  Copyright (c) 2015年 hcy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HCYImagePickerViewController;
@protocol HCYImagePickerViewControllerDelegate <NSObject>
@required

-(void)imagePicker:(HCYImagePickerViewController *)picker selectWithImages:(NSArray *)images;
-(void)imagePickerDidCanceled:(HCYImagePickerViewController *)picker;
-(void)imagePickerselectItemBeyondMark:(HCYImagePickerViewController *)picker;

@end
@interface HCYImagePickerConfig : NSObject

/**
 default is white
 */
@property(strong,nonatomic)UIColor *barTintColor;

/**
 default is gary
 */
@property(strong,nonatomic)UIColor *tintColor;
@end
/**
 *图片选择器-相册列表
 */
@interface HCYImagePickerViewController : UIViewController
-(instancetype)initWithConfig:(HCYImagePickerConfig *)config;
@property(weak,nonatomic)id<HCYImagePickerViewControllerDelegate> delegate;
@property(assign,nonatomic)NSInteger selectCount;
@end
