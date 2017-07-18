//
//  HCYPhoto.h
//  FriendCircle
//
//  Created by hcy on 15/12/14.
//  Copyright © 2015年 hcy. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  照片模型类
 *  加载照片顺序
 *  1.sourceImageView.image
 *  2.sourePath处的image
 *  3.
 *
 */
@interface HCYPhoto : UIView
#pragma mark 通用属性
/**
 *  用来表示模型唯一性
 */
@property(copy,nonatomic)NSString *photoIdentifier;
/**
 *用来做动画用
 */
@property(strong,nonatomic)UIImageView *sourceImageView;

/**
 本地图片(有可能放置图片的imageView无法取得）
 */
@property(strong,nonatomic)UIImage *sourceImage;


/**
 如果sourcePath没有就会调用这个来获取图片

 @param completion 回调
 */
-(void)getImageWithCompletion:(void(^)(HCYPhoto *photo,UIImage *image,NSError *error))completion;

/**
 *  是否需要自动缩放
 */
@property(assign,nonatomic,getter=isAutoResize)BOOL autoResize;
/**
 *  是否需要下载
 */
@property(assign,nonatomic)BOOL needDownload;
/*
 *下载地址
 */
@property(copy,nonatomic)NSString *downloadUrl;
@property(assign,nonatomic)int64_t fileLength;//nim使用

@end
