//
//  YZListCell.h
//  YZWaimaiCustomer
//
//  Created by hcy on 16/8/17.
//  Copyright © 2016年 hcy@yz. All rights reserved.
//

#import "YZDataCollection.h"
@class YZListCell,YZListCellEvent;
extern NSString* const YZListCellEventNamePickerCellClicked;
extern NSString* const YZListCellEventNameClickOrderResInfo;//点击订单餐厅
extern NSString* const YZListCellEventNameOrderOperaBtnClicked; //点击订单操作按钮


@protocol YZListCellDelegate <NSObject>
@optional
-(void)list_onCatchEvent:(YZListCellEvent *)event;
@end

@interface YZListCell : YZCell
@property(weak,nonatomic)id<YZListCellDelegate> delegate;

-(void)list_sendEvents:(YZListCellEvent *)event;
@end

@interface YZListCellEvent : NSObject
@property(copy,nonatomic)NSString *eventName;
@property(strong,nonatomic)YZListCell *cell;
@property(strong,nonatomic)id data;
@property(strong,nonatomic)NSDictionary *userInfo;
@end
