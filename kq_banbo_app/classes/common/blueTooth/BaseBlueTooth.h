//
//  BaseBlueTooth.h
//  Test
//
//  Created by hcy on 2016/12/19.
//  Copyright © 2016年 hcy. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
#import <CoreBluetooth/CoreBluetooth.h>
extern NSString *const HCYBlueToothErrorDomain;

@class BaseBlueTooth;
@protocol HCYBlueToothDelegate <NSObject>
@required
-(void)bluetooth:(BaseBlueTooth *)blueTooth changeState:(CBManagerState)state;
@optional
-(void)bluetooth:(BaseBlueTooth *)blueTooth connectPeripheralWithError:(NSError *)error;
-(void)bluetooth:(BaseBlueTooth *)blueTooth lostConnectWithError:(NSError *)error;
-(void)bluetooth:(BaseBlueTooth *)blueTooth commondResult:(id)data error:(NSError *)error;

/**
 需要实时监听返回数据的话可以用这个代理

 @param blueTooth 蓝牙
 @param val 值
 */
-(void)bluetooth:(BaseBlueTooth *)blueTooth hasReturnVal:(NSData *)val;

/**
 自身状态变更需要通知
 比如血压仪可能第一次测量失败之类的

 @param blueTooth 蓝牙设备
 @param changeDict 子类自定义
 */
-(void)bluetooth:(BaseBlueTooth *)blueTooth noticeCustomStateChange:(NSDictionary *)changeDict;
@end
@interface BaseBlueTooth : NSObject<CBPeripheralDelegate>

+(NSError *)noAuthError;
//父类
-(BOOL)canScan;
-(BOOL)needCheckDevice;
-(void)startScan;
-(void)stopScan;
-(void)releasePeripheral;
-(void)connectPeripheral;
-(void)noticeWithError:(NSError *)error;
//子类需要重写的
-(void)readData;
/**
 must call super

 @param error 错误
 */
-(void)connectPeripheralWithError:(NSError *)error;

/**
 must call super
 */
-(void)lostConnect;

@property(weak,nonatomic) id<HCYBlueToothDelegate> delegate;
@property(assign,nonatomic)NSTimeInterval timeCountInterval;
@property(strong,nonatomic)CBPeripheral *peripheral;
//子类自己实装处理
@property(strong,nonatomic)id data;//会被回调给completion
@property(assign,nonatomic,getter=isReading)BOOL reading;
@property(strong,nonatomic)NSString *deviceName;
@property(strong,nonatomic)CBCharacteristic *writeCharacter;
@property(strong,nonatomic)CBCharacteristic *readCharacter;


@end
