//
//  DtImagePickerSelectItem.h
//  DanteImagePicker
//
//  Created by hcy on 15/11/5.
//  Copyright © 2015年 hcy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HCYImagePickerHeader.h"
/**
 详情item
 */
@interface HCYImagePickerContentItem : NSObject<HCYImagePickerContentItem>
+(instancetype)contentItemWithData:(id)data;

@end
