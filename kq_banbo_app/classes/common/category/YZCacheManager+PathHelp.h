//
//  YZCacheManager+PathHelp.h
//  kq_banbo_app
//
//  Created by hcy on 2017/1/6.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "YZCacheManager.h"
#define BanBoImageTypeJPG  @"jpg"
#define BanBoImageTypePNG  @"jpg"
@interface YZCacheManager (PathHelp)

/**
 给图片生成一个本地路径
 
 @param image 图片
 @param sepcFileName 自定义文件名（默认用时间来）
 @param imageType 类型
 @return 本地路径
 */
-(NSString *)tmpPathForImage:(UIImage *)image sepcFileName:(NSString *)sepcFileName type:(NSString *)imageType;
@end
