//
//  BanBoBloodPressureView.h
//  kq_banbo_app
//
//  Created by hcy on 2016/12/13.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface BanBoBloodPressureView : UIView
@property(copy,nonatomic)NSString *userName;
@property(assign,nonatomic)NSInteger highPressure;
@property(assign,nonatomic)NSInteger lowPressure;
@property(assign,nonatomic)NSInteger pluseFreq;
@property (weak, nonatomic) IBOutlet UIImageView *signIcon;
@property (weak, nonatomic) IBOutlet UILabel *updateStrLabel;

@end
