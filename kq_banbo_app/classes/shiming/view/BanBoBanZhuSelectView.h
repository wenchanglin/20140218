//
//  BanBoBanZhuSelectView.h
//  kq_banbo_app
//
//  Created by hcy on 2016/12/5.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoModelView.h"
#import "BanBoBanzhuObj.h"
typedef void(^BanBoBanzhuSelectCompletion)(BanBoBanzhuItem *item ,BOOL isCancel);

/**
 班组-小班组选择的view
 */
@interface BanBoBanZhuSelectView : BanBoModelView
+(instancetype)banZhuSelectView;
+(instancetype)xiaoBanzhuSelectViewWithBanzhuItem:(BanBoBanzhuItem *)item;


@property(copy,nonatomic)BanBoBanzhuSelectCompletion completionBlock;
@end

