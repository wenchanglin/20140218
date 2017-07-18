//
//  BanBoVRCondiView.h
//  kq_banbo_app
//
//  Created by banbo on 2017/6/26.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "BanBoShiminCondiView.h"
#import "BanBoBanzhuObj.h"

@class BanBoVRCondiView;
@protocol BanBoVRCondiViewDelegate <NSObject>
-(void)conditionView:(BanBoVRCondiView *)view searchBtnClicked:(UIButton *)searchBtn;
-(void)conditionViewConditionChanged:(BanBoVRCondiView *)conditionView;
@end
@interface BanBoVRCondiView : UIView
@property(strong,nonatomic)BanBoBanzhuItem *banzhu;
@property(strong,nonatomic)BanBoBanzhuItem *xiaobanzhu;
@property(copy,nonatomic)NSString *gongren;
@property(weak,nonatomic)id<BanBoVRCondiViewDelegate> delegate;
@end
