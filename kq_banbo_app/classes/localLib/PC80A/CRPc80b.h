//
//  CRPc80b.h
//  health
//
//  Created by Creative on 15/7/27.
//  Copyright (c) 2015年 creative. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRCommon.h"
#import "CreativePeripheral.h"
@protocol  CRPc80bDelegate;
@interface CRPc80b : NSObject
@property (assign,nonatomic) id<CRPc80bDelegate> delegate;
@property(nonatomic,assign) CreativePeripheral *peri;
+(CRPc80b *)sharedInstance;

//-(void) SetECGAction:(BOOL)bFlag port:(CreativePeripheral *)currentPort;
-(void) QueryDeviceVer:(CreativePeripheral *)currentPort;
-(void)closeTimer;
-(void)restartTimer;
//@property (nonatomic) CreativePeripheral *SpotCheckPort;
-(void)setTimePC80B:(CreativePeripheral *)currentPort Time:(NSString *)time;
//-(void) setProtocolVersion:(CreativePeripheral *)currentPort;
@end

@protocol CRPc80bDelegate <NSObject>
@required




@optional

-(void)pc80B:(CRPc80b *)pc80B OnGetDeviceVer:(int)nHWMajeor HWMinor:(int)nHWMinor SWMajor:(int)nSWMajeor SWMinor:(int)nSWMinor ALMajor:(int)nALMajeor ALMinor:(int)nALMinor;

-(void)pc80B:(CRPc80b *)pc80B OnGetECGRealTimePrepare:(struct ecgWave)wave andGain:(int)nGain lead:(BOOL)bLeadOff;
-(void)pc80B:(CRPc80b *)pc80B OnGetECGRealTimeMeasure:(struct ecgWave)wave andGain:(int)nGain lead:(BOOL)bLeadOff andMode:(int)nTransMode;

-(void)pc80B:(CRPc80b *)pc80B OnGetFileTransmit:(BOOL)bFinish andData:(Byte *)ecgData andLengh:(Byte)len;

-(void)pc80B:(CRPc80b *)pc80B OnGetECGAction:(BOOL)bStart;
-(void)stopMeasure:(CRPc80b *)pc80B;
-(void)timeSynchroniztion:(CRPc80b *)pc80B;
-(void)pc80B:(CRPc80b *)pc80B OnGetPower:(int)nPower;
-(void)pc80B:(CRPc80b *)pc80B OnGetRealTimeResult:(int)nHR andResult:(int)nResult;
-(void)ackSetProtocolVersion:(CRPc80b *)pc80B;
-(void)onGetFileRequest:(CRPc80b *)pc80B;
@end
