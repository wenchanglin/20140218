//
//  BanBoHealthInfoCollectViewController.h
//  kq_banbo_app
//
//  Created by hcy on 2016/12/8.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BanBoHealthImageView.h"
#import "BanBoShiminDetail.h"
#import "BanBoProject.h"
#import "BanBoHealthManager.h"
/**
 回调

 @param data 成功的数据。各个子类自己定义
 @param error 有错误
 @param isCancel 是否是取消
 */
typedef void(^BanBoHealthCollectCompletionBlock)(id data,NSError *error,BOOL isCancel);

/**
 个人信息采集结果页面基类
 */
@interface BanBoHealthInfoCollectViewController : UIViewController
@property(strong,nonatomic)BanBoShiminUser *user;
@property(strong,nonatomic)BanBoProject *project;
@property(assign,nonatomic)BOOL isViewMode;
/**
 通过这个回调来告诉外面操作结果
 */
@property(strong,nonatomic)BanBoHealthCollectCompletionBlock completion;
-(void)healthSetTitle:(NSString *)title;

/**
 addSubview to this view
 */
@property(strong,nonatomic,readonly)UIView *healthContentView;

-(BanBoHealthImageView *)healthImageView:(CGRect)frame imageInset:(CGPoint)p;
-(BanBoHealthImageViewSecond *)healthImageViewV2:(CGRect)frame bgImage:(UIImage *)bgImage centerImage:(UIImage *)centerImage centerText:(NSString *)centerText;

-(UIButton *)blueBtnWithTitle:(NSString *)title;
-(UIButton *)redBtnWithTitle:(NSString *)title;
-(CGFloat)btnHeight;

/**
 拍照

 @param completion 回调
 */
-(void)getImageFromCameraWithCompletion:(void(^)(UIImage *image,NSError *error,BOOL isCancel))completion;
@end
