//
//  HCYImagePickerUtil.h
//  dfgdf
//
//  Created by hcy on 16/4/7.
//  Copyright © 2016年 hcy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#ifdef  __IPHONE_8_0
#import <Photos/Photos.h>
#endif
@class PHAsset;
@interface HCYImagePickerUtil : NSObject
+(instancetype)sharedUtil;
/**
 *  列表图片大小
 *
 *  @return 图片大小
 */
-(CGSize)listImageSize;



-(CGSize)defaultContentImageSize;
/**
 *  collectionView图片大小
 *
 *  @return collectionView图片大小
 */
-(CGSize)contentImageSizeWithPHAsset:(PHAsset *)ph;
/**
 *  previewImage大小
 *
 *  @return previewImage
 */
-(CGSize)previewImageSize;
/**
 *  列表行高
 *
 *  @return 列表行高
 */
-(CGFloat)listCellheight;

-(UIImage *)imageWithData:(NSData *)data size:(CGSize)size;
-(UIImage *)imageWithColor:(UIColor *)color;
/**
 *  用来缓存图片大小
 *
 *  @return  用来缓存图片大小
 */
-(NSMutableDictionary *)fileSizeDict;
-(NSString *)fileSizeStrWithByteLength:(NSUInteger)fileLength;
#ifdef __IPHONE_8_0
-(PHCachingImageManager *)cacheManager;
#endif
//中介
/**
 *  用提供的数据源提供列表数据
 *
 *  @param source 从系统框架里获得的原始数据源
 *
 *  @return 适用于本框架的数据源
 */
-(NSArray *)fillListDataWithSource:(NSArray *)source;
-(NSArray *)fillContentDataWithSource:(NSArray *)source;
@end
