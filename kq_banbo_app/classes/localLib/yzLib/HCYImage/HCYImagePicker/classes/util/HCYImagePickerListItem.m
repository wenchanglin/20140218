//
//  HCYImagePickerGroupItem.m
//  dfgdf
//
//  Created by hcy on 16/4/6.
//  Copyright © 2016年 hcy. All rights reserved.
//

#import "HCYImagePickerListItem.h"
@interface HCYImagePickerListItem()
@property(strong,nonatomic)id data;
@property(copy,nonatomic)NSString *albumImageCountStr;

@end
@implementation HCYImagePickerListItem
+(instancetype)listItemWithObj:(id)obj{
    return [[self alloc] initWithItem:obj];
}
-(instancetype)initWithItem:(id)item{
    if (self=[super init]) {
        _data=item;
    }
    return self;
}
#pragma mark gorupItem
#ifdef __IPHONE_8_0
-(id)data{
    return _data;
}
-(NSString *)albumTitle{
    PHAssetCollection *collection=(PHAssetCollection *)_data;
    return [collection localizedTitle];
}
-(PHFetchOptions *)imageFetchOption{
    PHFetchOptions *options=[PHFetchOptions new];
    options.sortDescriptors=@[[NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:NO]];
    return options;
}
-(NSArray *)contentImages{
    @autoreleasepool {
        PHFetchOptions *options=[self imageFetchOption];
        NSMutableArray *arrM=[NSMutableArray arrayWithCapacity:options.fetchLimit];
        PHFetchResult *result=[PHAsset fetchAssetsInAssetCollection:_data options:options];
        if (result.count) {
            
            for (PHAsset *ass in result) {
                //predict不会来。就只能这么写了
                if (ass.mediaType==PHAssetMediaTypeImage) {
                    [arrM addObject:ass];
                }
            }
        }
        return [arrM copy];
    }
}
-(void)albumThumbImageWithData:(id<HCYImagePickerListItem>)data completion:(void (^)(id<HCYImagePickerListItem>, UIImage *))completion{
    if (completion) {
        PHAsset *firstAsset=[self contentImages][0];
        CGSize imgeSize=[[HCYImagePickerUtil sharedUtil] listImageSize];
        [[[HCYImagePickerUtil sharedUtil] cacheManager] requestImageForAsset:firstAsset targetSize:imgeSize contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if (result) {
                completion(data,result);
            }
        }];
    }
}
-(NSString *)albumImageCountStr{
    if (!_albumImageCountStr) {
        PHAssetCollection *collection=(PHAssetCollection *)_data;
        if (collection.estimatedAssetCount!=NSNotFound) {
            _albumImageCountStr=[NSString stringWithFormat:@"%ld",(unsigned long)collection.estimatedAssetCount];
        }else{
            @autoreleasepool {
                PHFetchResult *result= [PHAsset fetchAssetsInAssetCollection:_data options:[self imageFetchOption]];
                if (result.count) {
                    _albumImageCountStr=[NSString stringWithFormat:@"%ld",(unsigned long)result.count];
                }else{
                    _albumImageCountStr=@"无法获取";
                }
            }
        }
    }
    return [_albumImageCountStr copy];
}
-(void)allAlbumImagesWithCompletion:(void (^)(NSArray *, NSError *))completion{
    if(completion){
        completion(self.contentImages,nil);
    }
}
#else
-(NSString *)groupTitle{
    
}
-(UIImage *)albumThumbImage{
    
}
-(NSString *)imageCountStr{
    
}
#endif
@end
