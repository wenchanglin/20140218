//
//  YZTextView.h
//  WorkChat
//
//  Created by hcy on 2016/10/31.
//  Copyright © 2016年 HCY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZTextView : UIView
@property(copy,nonatomic)NSString *yz_placeHolder;
@property(assign,nonatomic)NSInteger maxCount;
@property(assign,nonatomic)BOOL needShowMaxCount;
@property(copy,nonatomic)NSString *text;
@end
