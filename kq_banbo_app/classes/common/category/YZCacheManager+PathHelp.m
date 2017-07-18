//
//  YZCacheManager+PathHelp.m
//  kq_banbo_app
//
//  Created by hcy on 2017/1/6.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "YZCacheManager+PathHelp.h"

@implementation YZCacheManager (PathHelp)
-(NSString *)tmpPathForImage:(UIImage *)image sepcFileName:(NSString *)sepcFileName type:(NSString *)imageType{
    NSData *imageData=nil;
    NSString *suffix=@"jpg";
    if ([imageType isEqualToString:BanBoImageTypeJPG]) {
        imageData=UIImageJPEGRepresentation(image, 0.7);
    }else{
        suffix=@"png";
        imageData=UIImagePNGRepresentation(image);
    }
    if (!imageData) {
        return nil;
    }
      static NSString *key;
//    key=[NSString stringWithFormat:@"%ld.%@",(long)[[NSDate new] timeIntervalSince1970],suffix];
//    if (sepcFileName.length) {
//        key=sepcFileName;
//    }
    
    if (sepcFileName.length) {
        key = [NSString stringWithFormat:@"%@.%@",sepcFileName,suffix];
    }
    [[YZCacheManager sharedInstance] addCache:imageData forKey:key type:YZCacheTypeTmpFile];
    
    return [[YZCacheManager sharedInstance] cachePathForKey:key type:YZCacheTypeTmpFile];
    
}
@end
