//
//  HCYImagePickerUtil.m
//  dfgdf
//
//  Created by hcy on 16/4/7.
//  Copyright © 2016年 hcy. All rights reserved.
//

#import "HCYImagePickerUtil.h"
#import "HCYImagePickerListItem.h"
#import "HCYImagePickerContentItem.h"
#import "HCYImagePickerCollector.h"
#define HCYImagePicker_IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define HCYImagePicker_IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define HCYImagePicker_IS_IPHONE_6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)) : NO)

@interface HCYImagePickerUtil()
@property(assign,nonatomic) CGSize  listImageSize;
@property(assign,nonatomic) CGFloat listCellHeight;
@property(strong,nonatomic) NSMutableDictionary *fileSizeDict;
@end
@implementation HCYImagePickerUtil
static HCYImagePickerUtil *sharedUtil;
+(instancetype)sharedUtil{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedUtil=[HCYImagePickerUtil new];
    });
    return sharedUtil;
}
-(CGSize)listImageSize{
    if (CGSizeEqualToSize(_listImageSize, CGSizeZero)) {
        CGFloat imageWidth=[self listCellheight]*0.6;
        CGFloat imageHeight=[self listCellheight]*.7;
        _listImageSize=CGSizeMake(imageWidth, imageHeight);
    }
    return _listImageSize;
}
CGFloat columnCount=4;
CGFloat offset=5;
-(CGSize)defaultContentImageSize{
    CGFloat screenWidth=[UIScreen mainScreen].bounds.size.width;
    CGFloat itemWidth=(screenWidth-offset*(columnCount-1))/columnCount;
    return CGSizeMake(itemWidth, itemWidth);
}
-(CGSize)contentImageSizeWithPHAsset:(PHAsset *)ph{
    CGSize screenSize=[UIScreen mainScreen].bounds.size;
    
    NSInteger imageWidth=ph.pixelWidth;
    NSInteger imageHeight=ph.pixelHeight;
    
    CGFloat widthScale=imageWidth/screenSize.width;
    CGFloat heightScale=imageHeight/screenSize.height;
    if (widthScale>=1 && heightScale>=1) {
        if (widthScale>heightScale) {
            return CGSizeMake(imageWidth/heightScale, screenSize.height);
        }else{
            return CGSizeMake(screenSize.width, imageHeight/widthScale);
        }
    }else{
        if (widthScale<1 && heightScale<1) {
            return CGSizeMake(imageWidth, imageHeight);
        }else{
            //肯定是一个大于1一个小于1
            if(widthScale>=1){
                //宽图的话就把高拉长
                return CGSizeMake(imageWidth/heightScale, screenSize.height);
            }else{
                //长图的话把宽撑大
                return CGSizeMake(screenSize.width, imageHeight/widthScale);
            }
        }
    }
}
-(CGSize)previewImageSize{
    return [UIScreen mainScreen].bounds.size;
}
-(CGFloat)listCellheight{
    if (_listCellHeight==0) {
        _listCellHeight=[self availabeHeight]*.1;
    }
    return _listCellHeight;
}
-(CGFloat)availabeHeight{
    //屏幕高度-状态栏-导航栏
    return [UIScreen mainScreen].bounds.size.height-20-44;
}

static int HCYImagePickerFileSizeMax=1024;
-(NSString *)fileSizeStrWithByteLength:(NSUInteger)length{
    int i=0;
    CGFloat fLength=length;
    while (fLength>HCYImagePickerFileSizeMax*0.98) {
        fLength=fLength/HCYImagePickerFileSizeMax;
        i++;
    }
    NSString *suffix=@"GB";
    if ([[self fileSizeExtDict] objectForKey:@(i)]) {
        suffix=[[self fileSizeExtDict] objectForKey:@(i)];
        NSString *str=@"";
        if (fLength==(NSInteger)fLength) {
        str=[NSString stringWithFormat:@"%ld%@",(long)fLength,suffix];
        }else{
        str=[NSString stringWithFormat:@"%.2f%@",(float)fLength,suffix];
        }
        
        return str;
    }
    return @"";
}
-(NSMutableDictionary *)fileSizeDict{
    if(!_fileSizeDict){
        _fileSizeDict=[NSMutableDictionary dictionary];
    }
    return _fileSizeDict;
    
}
-(NSDictionary *)fileSizeExtDict{
    static NSDictionary *fileSizeExtDict;
    fileSizeExtDict=@{@(0):@"B",
                      @(1):@"KB",
                      @(2):@"MB",
                      @(3):@"GB"};
    return fileSizeExtDict;
}
-(UIImage *)imageWithData:(NSData *)data size:(CGSize)size{
    @autoreleasepool {
        UIGraphicsBeginImageContext(size);
        CGContextRef context=UIGraphicsGetCurrentContext();
        UIImage *tmp=[UIImage imageWithData:data];
        CGRect imageRect= CGRectMake(0, 0, size.width, size.height);
        if (tmp.CGImage) {
            CGContextDrawImage(context,imageRect, tmp.CGImage);
        }else{
            [tmp drawInRect:imageRect];
        }
        CGImageRef bitImage=CGBitmapContextCreateImage(context);
        
        UIImage *result=[UIImage imageWithCGImage:bitImage scale:1 orientation:UIImageOrientationDown];
        
//        UIImage *result=UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return result;
    }
}

-(UIImage *)imageWithColor:(UIColor *)color{
  
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
    
}
-(NSArray *)fillListDataWithSource:(NSArray *)source{
    NSMutableArray *arrM=[NSMutableArray arrayWithCapacity:source.count];
    for (id sourceData in source) {
        HCYImagePickerListItem *listItem=[HCYImagePickerListItem listItemWithObj:sourceData];
        [arrM addObject:listItem];
    }
    return  [arrM copy];
    
}
-(NSArray *)fillContentDataWithSource:(NSArray *)source{
    NSMutableArray *arrM=[NSMutableArray arrayWithCapacity:source.count];
    for (id sourceData in source) {
        HCYImagePickerContentItem *contentItem=[HCYImagePickerContentItem contentItemWithData:sourceData];
        BOOL isSelect=[[HCYImagePickerCollector sharedCollector] itemSelected:contentItem];
        [contentItem setSelected:isSelect];
        [arrM addObject:contentItem];
    }
    return [arrM copy];
}
#ifdef __IPHONE_8_0
static PHCachingImageManager *cacheManager;
-(PHCachingImageManager *)cacheManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cacheManager=[PHCachingImageManager new];
    });
    return cacheManager;
}
#endif
@end
