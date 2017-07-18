//
//  BanBoModelView.m
//  kq_banbo_app
//
//  Created by hcy on 2016/12/5.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoModelView.h"
@interface BanBoModelView()<UIGestureRecognizerDelegate>
@property(strong,nonatomic)UITapGestureRecognizer *closeTapGesture;
@property(strong,nonatomic,readonly)CALayer *bgLayer;

@end
@implementation BanBoModelView

- (instancetype)initWithFrame:(CGRect)frame
{
    frame.size.width=SCREEN_WIDTH;
    frame.size.height=SCREEN_HEIGHT;
    self = [super initWithFrame:frame];
    if (self) {
        CALayer *bgLayer=[CALayer new];
        bgLayer.frame=self.bounds;
        bgLayer.backgroundColor=[UIColor hcy_colorWithString:@"#010000"].CGColor;
        bgLayer.opacity=[self bgLayerShowVal];
        [self.layer addSublayer:bgLayer];
        _bgLayer=bgLayer;
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(f_tapClose)];
        tap.delegate=self;
        self.closeTapGesture=tap;
        [self addGestureRecognizer:tap];
    }
    return self;
}
-(void)showInView:(UIView *)supView{
    [self showInView:supView fromWhere:kCATransitionFromBottom dur:0.25];
}
-(void)dismiss{
    [self dismissToWhere:@"" dur:0.25];
}
-(void)showInView:(UIView *)supView fromWhere:(NSString *)fromWhere dur:(NSTimeInterval)dur{
    BOOL needViewAnimation=NO;
    if ([fromWhere isEqualToString:kCATransitionFromBottom]) {
        self.containerView.top=supView.height;
        needViewAnimation=YES;
    }    
    CGFloat animationDur=dur;
    
    CABasicAnimation* fadeAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnim.fromValue = [NSNumber numberWithFloat:[self bgLayerHiddenVal]];
    fadeAnim.toValue = [NSNumber numberWithFloat:[self bgLayerShowVal]];
    fadeAnim.duration = animationDur;
    [self.bgLayer addAnimation:fadeAnim forKey:@"opacity"];
    
    self.bgLayer.opacity=[self bgLayerShowVal];
    [supView addSubview:self];
    if (needViewAnimation) {
        [UIView animateWithDuration:animationDur animations:^{
            self.containerView.top-=self.containerView.height;
        }];
    }
}
-(void)f_tapClose{
    [self closeGestureTaped:self.closeTapGesture];
}
-(void)closeGestureTaped:(UITapGestureRecognizer *)tap{
    [self dismissToWhere:kCATransitionFromBottom dur:0.25];
}
-(void)dismissToWhere:(NSString *)toWhere dur:(NSTimeInterval)dur{
    NSTimeInterval animationDur=dur;
    
    CABasicAnimation* fadeAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnim.fromValue = [NSNumber numberWithFloat:[self bgLayerShowVal]];
    fadeAnim.toValue = [NSNumber numberWithFloat:[self bgLayerHiddenVal]];
    fadeAnim.duration = animationDur;
    [self.bgLayer addAnimation:fadeAnim forKey:@"opacity"];
    self.bgLayer.opacity=[self bgLayerHiddenVal];
    
    [UIView animateWithDuration:animationDur animations:^{
        self.containerView.top=self.superview.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(CGFloat)bgLayerShowVal{
    return 0.36;
}
-(CGFloat)bgLayerHiddenVal{
    return 0;
}
-(void)setEnableTapBgToClose:(BOOL)enableTapBgToClose{
    if (enableTapBgToClose==_enableTapBgToClose) {
        return;
    }
    _enableTapBgToClose=enableTapBgToClose;
    _closeTapGesture.enabled=enableTapBgToClose;
}


#pragma mark gestureDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if(!self.enableTapBgToClose){
        return NO;
    }
    if (self.containerView) {
        CGPoint p= [touch locationInView:self];
        return !CGRectContainsPoint(self.containerView.frame, p);
    }else{
        return YES;
    }
}
-(void)dealloc{
    DDLogDebug(@"modelView:%@-dealloc",self);
}
@end
