//
//  BloodPressureLayer.h
//  Test
//
//  Created by hcy on 2017/1/11.
//  Copyright © 2017年 hcy. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

/**
 用来画心电图的layer
 */
@interface BloodPressureLayer : CALayer
//-(void)insertY:(CGFloat)y atIdx:(NSInteger)idx;
-(void)insertY:(CGFloat)y;
@property(assign,nonatomic)int gain;
-(void)clean;
@end
