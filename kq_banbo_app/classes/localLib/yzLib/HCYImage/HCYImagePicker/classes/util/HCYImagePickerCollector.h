//
//  DtImagePickerCollector.h
//  DanteImagePicker
//
//  Created by hcy on 15/11/5.
//  Copyright © 2015年 hcy. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "HCYImagePickerGroupBottomView.h"
#import "HCYImagePickerHeader.h"
@class HCYImagePickerCollector;
@protocol HCYImagePickerCollectorDelegate <NSObject>
-(void)collector:(HCYImagePickerCollector *)collector addItem:(id)item;
-(void)collector:(HCYImagePickerCollector *)collector removeItem:(id)item;
@optional
/**
 *  添加图片时候超过最大值时候触发
 */
-(void)collectorItemBeyond:(HCYImagePickerCollector *)collector;

/**
 发送图片(最外面实现就行）

 @param collector 3
 */
-(void)collectorNeedSendImages:(HCYImagePickerCollector *)collector;
@end

/**
 *  收集者。负责记录选择的数据
 */
@interface HCYImagePickerCollector : NSObject

/**
 创建收集者
 */
+(void)create;

/**
 获得收集者
 @return 收集者
 */
+(instancetype)sharedCollector;

/**
 注销收集者（用在图片选择完成）
 */
+(void)destory;

/**
 发送图片
 */
-(void)send;
@property(assign,nonatomic)BOOL sourceImage;
-(NSInteger)itemCount;
@property(assign,nonatomic)NSInteger maxCount;


-(BOOL)itemSelected:(id<HCYImagePickerContentItem>)item;
-(BOOL)addItem:(id<HCYImagePickerContentItem> )item;
-(void)removeItem:(id<HCYImagePickerContentItem> )item;

/**
 发送时候调用

 @param completion <#completion description#>
 */
-(void)getSelectImagesWithCompletion:(void(^)(NSArray *images))completion;
//Delegate
-(void)addDelegate:(id<HCYImagePickerCollectorDelegate>)delegate;
-(void)removeDelegate:(id<HCYImagePickerCollectorDelegate>)delegate;



@end
