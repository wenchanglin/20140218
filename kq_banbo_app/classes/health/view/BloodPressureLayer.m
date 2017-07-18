//
//  BloodPressureLayer.m
//  Test
//
//  Created by hcy on 2017/1/11.
//  Copyright © 2017年 hcy. All rights reserved.
//

#import "BloodPressureLayer.h"
@interface BloodPressureLayer()
@property(assign,nonatomic)CGFloat xPX2MMUnit;
@property(assign,nonatomic)CGFloat yPX2MMUnit;
@property(assign,nonatomic)NSInteger maxCount;
@property(assign,nonatomic)CGFloat lineWidth;

@property(strong,nonatomic)NSMutableArray *yArrCountM;

@end
@implementation BloodPressureLayer
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.gain=2;
        self.allowsEdgeAntialiasing=YES;
        self.yArrCountM=[NSMutableArray array];
        self.lineWidth=2;
    }
    return self;
}
-(void)clean{
    self.yArrCountM=[NSMutableArray array];
    [self setNeedsDisplay];
}
-(void)drawInContext:(CGContextRef)ctx{
    if (!ctx) {
        return;
    }
//    [self setupParam];
    CGContextSaveGState(ctx);
    CGContextClearRect(ctx, self.bounds);
    
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetStrokeColorSpace(ctx, CGColorSpaceCreateDeviceRGB());
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);

    CGFloat xPlus=2.f;
    CGFloat lineWidth=self.lineWidth;
    NSInteger count=self.yArrCountM.count;
    if (count) {
        CGContextSetLineWidth(ctx,lineWidth);
        CGFloat y=self.bounds.size.height*.5;
        
        CGContextMoveToPoint(ctx,0, y);
        for (NSInteger i=0; i<count; i++) {
            CGFloat x=(xPlus+lineWidth)*i;
            y=[self.yArrCountM[i] floatValue];
            CGContextAddLineToPoint(ctx, x, y);
        }
        CGFloat waveRight= (xPlus+lineWidth)*count;
        NSLog(@"waveRight:%f",waveRight);
        if (waveRight<self.bounds.size.width) {
            CGFloat leftHeight=self.bounds.size.width-waveRight;
            while (leftHeight>0) {
                CGContextAddLineToPoint(ctx, waveRight++, y);
                leftHeight--;
            }
        }
        CGContextStrokePath(ctx);
    }
   
    CGContextRestoreGState(ctx);
}
-(void)setupParam{
//    UIScreen* screen= [UIScreen mainScreen];
//    CGFloat scale=screen.scale;
    self.maxCount=CGRectGetWidth(self.frame)/self.lineWidth;
//    _xPX2MMUnit=25.4/self.bounds.size.width;
//    _yPX2MMUnit=_xPX2MMUnit;
    _xPX2MMUnit = 0.079375;
    _yPX2MMUnit = 0.079375;
}
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];

    [self setupParam];
}
-(void)insertY:(CGFloat)y{
    CGFloat result=y;
#ifdef HCYCGV2
    result=[self resultForY:y];
    NSLog(@"y:%f,result:%f",y,result);
#endif
    if(self.yArrCountM.count==0){
        [self.yArrCountM addObject:@(result)];
    }else{
        [self.yArrCountM insertObject:@(result) atIndex:0];
        if (self.yArrCountM.count>self.maxCount) {
            [self.yArrCountM removeLastObject];
        }
    }
}
-(CGFloat)resultForY:(CGFloat)y{
    CGFloat aY=y-2048;
    CGFloat heightMm=self.bounds.size.height*.1;
//    heightMm=32.940624;
    CGFloat zoomECGforMm = (float) (self.bounds.size.height/ 416.f);
    zoomECGforMm=0.013;
    float result= heightMm*.5 - zoomECGforMm * (aY * _gain);
    NSLog(@"result1:%f",result);
    result=result/_yPX2MMUnit;
    return result;
    
}
-(void)setGain:(int)gain{
    if (gain==_gain) {
        return;
    }
    _gain=gain;
    DDLogDebug(@"setGain:%d",gain);
}
//-(void)insertY:(CGFloat)y atIdx:(NSInteger)idx{
//    if(idx<0){
//        return;
//    }
//    if (self.yArrCountM.count) {
//        if (idx<self.yArrCountM.count) {
//            [self.yArrCountM insertObject:@(y) atIndex:idx];
//        }else{
//            [self.yArrCountM addObject:@(y)];
//        }
//    }else{
//        [self.yArrCountM addObject:@(y)];
//    }
//    
//}
@end
