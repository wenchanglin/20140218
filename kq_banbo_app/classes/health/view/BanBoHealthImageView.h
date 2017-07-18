//
//  BanBoHealthImageView.h
//  kq_banbo_app
//
//  Created by hcy on 2016/12/12.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BanBoHealthImageView : UIView
@property(strong,nonatomic,readonly)UIImageView *imageView;
@property(assign,nonatomic)CGPoint imageViewInset;
@end


@interface BanBoHealthImageViewSecond : UIImageView
@property(strong,nonatomic)UIImage *bb_centerImage;
@property(copy,nonatomic)NSString *bb_centerText;
-(void)bb_hiddenOverlay;
@end
