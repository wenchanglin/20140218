//
//  DtImagePickerSelectItem.m
//  DanteImagePicker
//
//  Created by hcy on 15/11/5.
//  Copyright © 2015年 hcy. All rights reserved.
//

#import "HCYImagePickerContentItem.h"
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetRepresentation.h>

@interface HCYImagePickerContentItem()
{
    BOOL _select;
}
@property(strong,nonatomic)id data;
@property(copy,nonatomic)NSString *sourceLengthStr;
@end
@implementation HCYImagePickerContentItem
+(instancetype)contentItemWithData:(id)data{
    return [[self alloc] initWithData:data];
}
-(instancetype)initWithData:(id)data{
    if (self=[super init]) {
        _data=data;
    }
    return self;
}
-(BOOL)isEqual:(id)object{
    if ([object isKindOfClass:[self class]]) {
        return [_data isEqual:[object data]];
    }
    return NO;
}
#pragma mark contentItem
#ifdef __IPHONE_8_0
-(void)thumbImageWithCompletion:(void (^)(id<HCYImagePickerContentItem>, UIImage *))completion{
    if (completion) {
        PHAsset *asset=(PHAsset *)_data;
        CGSize contentSize=CGSizeMake(50, 50);
        //要速度
        PHImageRequestOptions *options=[PHImageRequestOptions new];
        options.synchronous=NO;
        options.deliveryMode=PHImageRequestOptionsDeliveryModeOpportunistic;
        options.resizeMode=PHImageRequestOptionsResizeModeNone;
        [[[HCYImagePickerUtil sharedUtil] cacheManager] requestImageForAsset:asset targetSize:contentSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            completion(self,result);
        }];
    }
}
-(void)previewImageWithCompletion:(void (^)(id<HCYImagePickerContentItem>, UIImage *))completion sync:(BOOL)sync{
    if (completion) {
        PHAsset *asset=(PHAsset *)_data;
        PHImageRequestOptions *options=[PHImageRequestOptions new];
        //要质量
        options.synchronous=sync;
        CGSize contentSize=[[HCYImagePickerUtil sharedUtil] contentImageSizeWithPHAsset:asset];
        options.deliveryMode=PHImageRequestOptionsDeliveryModeHighQualityFormat;

        [[[HCYImagePickerUtil sharedUtil] cacheManager] requestImageForAsset:asset targetSize:contentSize contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            completion(self,result);
        }];
    }
}
-(void)getSourceLengthWithCompletion:(void (^)(id<HCYImagePickerContentItem>, NSString *))completion{
    
    if (self.sourceLengthStr) {
        completion(self,self.sourceLengthStr);
    }else{
        __weak typeof(self) wself=self;
        PHAsset *asset=(PHAsset *)wself.data;
        [[[HCYImagePickerUtil sharedUtil] cacheManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            NSString *fileSize=[[HCYImagePickerUtil sharedUtil] fileSizeStrWithByteLength:imageData.length];
            wself.sourceLengthStr=fileSize;
            if (completion) {
                completion(wself,fileSize);
            }
        }];
    }
    
    
}
-(void)sourceImageWithCompletion:(void (^)(id<HCYImagePickerContentItem>, UIImage *))completion sync:(BOOL)sync{
    __weak typeof(self) wself=self;
    if (completion) {
        PHAsset *asset=(PHAsset *)wself.data;
        PHImageRequestOptions *options=[PHImageRequestOptions new];
        options.deliveryMode=PHImageRequestOptionsDeliveryModeHighQualityFormat;
        options.synchronous=sync;
        [[[HCYImagePickerUtil sharedUtil] cacheManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            UIImage *image=[UIImage imageWithData:imageData];
            completion(wself,image);
        }];
    }
}

-(BOOL)selected{
    return _select;
}
-(BOOL)isSelected{
    return _select;
}
-(void)setSelected:(BOOL)selected{
    _select=selected;
}
#else

#endif

@end
