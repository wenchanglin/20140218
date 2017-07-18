//
//  DtImagePickerCollector.m
//  DanteImagePicker
//
//  Created by hcy on 15/11/5.
//  Copyright © 2015年 hcy. All rights reserved.
//

#import "HCYImagePickerCollector.h"

@interface HCYImagePickerCollector(){
    dispatch_queue_t _imageQueue;
}
@property(strong,nonatomic)NSMutableArray *selectItems;
@property(strong,nonatomic)NSMutableArray *delegateArr;

@end
@implementation HCYImagePickerCollector
- (instancetype)init
{
    self = [super init];
    if (self) {
        _selectItems=[NSMutableArray array];
        _delegateArr=[NSMutableArray array];
        _imageQueue=dispatch_queue_create("HCYImagePickerCollectorqueue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}
static HCYImagePickerCollector *collector;
+(void)create{
    if (!collector) {
        collector=[HCYImagePickerCollector new];
    }
}
+(instancetype)sharedCollector{
    return collector;
}
+(void)destory{
    collector.delegateArr=[@[] mutableCopy];
    collector=nil;
}

-(void)dealloc{
    NSLog(@"HCYImagePickerCollector-dealloc");
}
-(void)send{
    for (NSValue * delegateValue in _delegateArr) {
        id delegate=[delegateValue nonretainedObjectValue];
        if ([delegate respondsToSelector:@selector(collectorNeedSendImages:)]) {
            [delegate collectorNeedSendImages:self];
            break;
        }
    }
}
-(NSInteger)itemCount{
    return self.selectItems.count;
}
-(void)addDelegate:(id<HCYImagePickerCollectorDelegate>)delegate{
    NSValue *val=[NSValue valueWithNonretainedObject:delegate];
    [_delegateArr addObject:val];
}
-(void)removeDelegate:(id<HCYImagePickerCollectorDelegate>)delegate{
    for (NSValue *tmpDelegate in _delegateArr) {
        if (tmpDelegate.nonretainedObjectValue==delegate) {
            [_delegateArr removeObject:tmpDelegate];
            break;
        }
    }
}
-(BOOL)addItem:(id<HCYImagePickerContentItem> )item{
    if (self.selectItems.count+1>self.maxCount) {
        for (NSValue * delegateValue in _delegateArr) {
            id delegate=[delegateValue nonretainedObjectValue];
            if ([delegate respondsToSelector:@selector(collectorItemBeyond:)]) {
                [delegate collectorItemBeyond:self];
            }
        }
        return NO;
    }
    if (![self.selectItems containsObject:item]) {
        [self.selectItems addObject:item];
        [item setSelected:YES];
    }
    for (NSValue * delegateValue in _delegateArr) {
        id delegate=[delegateValue nonretainedObjectValue];
        if ([delegate respondsToSelector:@selector(collector:addItem:)]) {
            [delegate collector:self addItem:item];
        }
    }
    return YES;

}
-(void)removeItem:(id<HCYImagePickerContentItem> )item{
    [self.selectItems removeObject:item];
    [item setSelected:NO];
    for (NSValue * delegateValue in _delegateArr) {
        id delegate=[delegateValue nonretainedObjectValue];
        if ([delegate respondsToSelector:@selector(collector:removeItem:)]) {
            [delegate collector:self removeItem:item];
        }
    }
}
-(BOOL)itemSelected:(id<HCYImagePickerContentItem>)item{
    __block BOOL result=NO;
    [self.selectItems enumerateObjectsUsingBlock:^(id<HCYImagePickerContentItem> obj, NSUInteger idx, BOOL * stop) {
        if ([obj isEqual:item]) {
            result=YES;
            *stop=YES;
        }
    }];
    return result;
}
-(void)getSelectImagesWithCompletion:(void (^)(NSArray *))completion{
    dispatch_async(_imageQueue, ^{
        __block NSMutableArray *imagesArrM=[NSMutableArray array];
        dispatch_group_t group=dispatch_group_create();
        dispatch_queue_t queue=dispatch_queue_create("imageQueue", DISPATCH_QUEUE_SERIAL);
        
        for (id<HCYImagePickerContentItem> item in _selectItems) {
            dispatch_group_async(group, queue, ^{
                if ([self sourceImage]) {
                    NSLog(@"getSourceImage");
                    [item sourceImageWithCompletion:^(id<HCYImagePickerContentItem> data, UIImage *result) {
                        NSLog(@"getSourdeImageComp:%@",result);
                        [imagesArrM addObject:result];
                        
                    } sync:YES];
                }else{
                    NSLog(@"getPreviewImage");
                    [item previewImageWithCompletion:^(id<HCYImagePickerContentItem> data, UIImage *result) {
                        [imagesArrM addObject:result];
                                            } sync:YES];
                }
            });
        }
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            NSLog(@"notify");
            if (completion) {
                NSLog(@"imagesCount:%ld",(unsigned long)imagesArrM.count);
                completion([imagesArrM copy]);
            }
        });
        
    });    
}

@end
