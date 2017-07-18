//
//  BanBoHealthResultView.h
//  kq_banbo_app
//
//  Created by hcy on 2017/3/13.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 健康结果展示
 */
@interface BanBoHealthResultView : UIView
-(void)beginAnimation;
-(void)stopAnimation;
-(void)setResultImage:(UIImage *)image;
-(void)setResultText:(NSString *)text;
@end
