
//
//  YZListHeader.h
//  WorkChat
//
//  Created by hcy on 2016/10/25.
//  Copyright © 2016年 HCY. All rights reserved.
//

#ifndef YZListHeader_h
#define YZListHeader_h
#import "YZDataCollection.h"
#import "YZListCell.h"
#import "YZListViewController.h"
@protocol YZListItem<YZMemberProtocol>
@required;
-(NSString *)reuseId;//重用id
-(NSString *)cellClass;//要构造的cellCls
@property(assign,nonatomic)CGFloat cellHeight;
@optional
-(NSDictionary *)userInfo;
@end

#endif /* YZListHeader_h */
