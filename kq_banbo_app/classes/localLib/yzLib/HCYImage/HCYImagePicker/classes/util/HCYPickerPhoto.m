//
//  HCYPickerPhoto.m
//  HCYImagePickerDemo
//
//  Created by hcy on 2016/11/1.
//  Copyright © 2016年 hcy. All rights reserved.
//

#import "HCYPickerPhoto.h"
#import "HCYImagePickerContentItem.h"
@implementation HCYPickerPhoto
-(void)getImageWithCompletion:(void (^)(HCYPhoto *, UIImage *, NSError *))completion{
    [self.contentItem previewImageWithCompletion:^(id<HCYImagePickerContentItem> data, UIImage *result) {
        if (completion) {
            completion(self,result,nil);
        }
    } sync:NO];
}

@end
