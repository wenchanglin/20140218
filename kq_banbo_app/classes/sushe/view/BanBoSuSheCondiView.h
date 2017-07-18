//
//  BanBoSuSheCondiView.h
//  kq_banbo_app
//
//  Created by banbo on 2017/4/24.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BanBoLineHeaderView.h"
#import "BanBoBanZhuSelectView.h"
#import "BanBoBanzhuObj.h"
@class BanBoSuSheCondiView;

@protocol BanBoSuSheCondiViewDelegate<NSObject>
-(void)conditionViewConditionChanged:(BanBoSuSheCondiView *)conditionView;
@end
@interface BanBoSuSheCondiView : UIView
@property(nonatomic,strong)BanBoBanzhuItem * banzhu;
@property(nonatomic,strong)BanBoBanzhuItem * xiaobanzhu;
@property(nonatomic,strong)NSString * gongren;
@property(nonatomic,weak)id<BanBoSuSheCondiViewDelegate>delegate;
@property(strong,nonatomic)BanBoLineHeaderView *banzhuLabel;
@property(strong,nonatomic)BanBoLineHeaderView *xiaobanzhuLabel;
@end
