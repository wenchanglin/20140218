//
//  HCYImagePickerHeader.h
//  dfgdf
//
//  Created by hcy on 16/4/6.
//  Copyright © 2016年 hcy. All rights reserved.
//

#ifndef HCYImagePickerHeader_h
#define HCYImagePickerHeader_h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#ifdef __IPHONE_8_0
#import <Photos/Photos.h>
#endif
#import "HCYImagePickerUtil.h"
#import "HCYImagePickerViewController.h"
/**
 *  列表item协议
 */
@protocol HCYImagePickerListItem<NSObject>
@required
-(NSString *)albumTitle;
-(void)albumThumbImageWithData:(id<HCYImagePickerListItem>)data completion:(void(^)(id<HCYImagePickerListItem> item, UIImage *image))completion;
-(NSString *)albumImageCountStr;
/**
 *  真实类型数据 PHAssetCollection or ALAsset
 *
 *  @return1
 */
-(id)data;
//数据相关
/**
 *  获得所有的内容(资源)PHAssetor ALAsset
 *
 *  @param completion 2
 */
-(void)allAlbumImagesWithCompletion:(void(^)(NSArray *contentArr,NSError *error))completion;
@end
/**
 *  内容item协议
 */
@protocol HCYImagePickerContentItem <NSObject>
/**
 *  小图
 *
 *  @param completion 回调
 */
-(void)thumbImageWithCompletion:(void(^)(id<HCYImagePickerContentItem> data,UIImage *result))completion;
/**
 *  大图
 *
 *  @param completion 回调
 */
-(void)previewImageWithCompletion:(void(^)(id<HCYImagePickerContentItem> data,UIImage *result))completion sync:(BOOL)sync;
/**
 *  原图
 *
 *  @param completion 回调
 */
-(void)sourceImageWithCompletion:(void(^)(id<HCYImagePickerContentItem> data,UIImage *result))completion sync:(BOOL)sync;

/**
 获得原图大小
 @param completion 回调
 */
-(void)getSourceLengthWithCompletion:(void(^)(id<HCYImagePickerContentItem> data,NSString *sizeLength))completion;

/**
 *  选中否
 */
@property(assign,nonatomic,getter=isSelected)BOOL selected;

@end


#define dispatch_async_main_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}
#endif /* HCYImagePickerHeader_h */
