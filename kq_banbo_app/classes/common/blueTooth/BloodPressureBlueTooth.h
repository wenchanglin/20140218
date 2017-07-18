//
//  BloodPressureBlueTooth.h
//  Test
//
//  Created by hcy on 2016/12/21.
//  Copyright © 2016年 hcy. All rights reserved.
//

#import "BaseBlueTooth.h"
extern NSString *const BloodPressureKeyState;
typedef NS_ENUM(NSInteger,BloodPressureState){
    BloodPressureStateNotMeasure=1, //未测量
    BloodPressureStateMeasuring,  //正在测量
    BloodPressureStateMeasured    //测量结束
};
@interface BloodPressureBlueTooth : BaseBlueTooth

@end
@interface BloodPressureInfo:NSObject
@property(assign,nonatomic)NSInteger highPressure;
@property(assign,nonatomic)NSInteger lowPressure;
@property(assign,nonatomic)NSInteger pluseRate;

/**
 *
 */
@property(nonatomic,copy) NSString* info;
/**
 *
 */
@property(nonatomic,assign) NSTimeInterval createdate;
@end
