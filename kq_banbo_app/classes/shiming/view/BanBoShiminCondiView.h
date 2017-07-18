
//
//  BanBoShiminCondiView.h
//  kq_banbo_app
//
//  Created by hcy on 2016/12/5.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BanBoShiminCondiView,BanBoBanzhuItem;
@protocol BanBoShiminCondiViewDelegate <NSObject>
-(void)conditionView:(BanBoShiminCondiView *)view searchBtnClicked:(UIButton *)searchBtn;
-(void)conditionViewConditionChanged:(BanBoShiminCondiView *)conditionView;
@end

/**
 实名制-头上那个班组小班组搜索条件的view
 */
@interface BanBoShiminCondiView : UIView

@property(strong,nonatomic)BanBoBanzhuItem *banzhu;
@property(strong,nonatomic)BanBoBanzhuItem *xiaobanzhu;
@property(copy,nonatomic)NSString *gongren;
@property(weak,nonatomic)id<BanBoShiminCondiViewDelegate> delegate;
@end
