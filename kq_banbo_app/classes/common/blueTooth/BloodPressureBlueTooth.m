//
//  BloodPressureBlueTooth.m
//  Test
//
//  Created by hcy on 2016/12/21.
//  Copyright © 2016年 hcy. All rights reserved.
//

#import "BloodPressureBlueTooth.h"
#import <NSObject+MJKeyValue.h>
NSString *const BloodPressureKeyState=@"BloodPressureKeyState";

@interface BloodPressureBlueTooth()
@property(assign,nonatomic)BloodPressureState state;
@end
@implementation BloodPressureBlueTooth
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.deviceName=@"eBlood-Pressure";
    }
    return self;
}
-(void)readData{
    if (self.isReading) {
        DDLogDebug(@"已经在测量了");
        return;
    }
    self.state=BloodPressureStateNotMeasure;
    self.reading=YES;
}
-(void)connectPeripheralWithError:(NSError *)error{
    [super connectPeripheralWithError:error];
    if(!error){
        [self.peripheral discoverServices:nil];
    }
}
-(void)lostConnect{
    self.reading=NO;
    self.state=BloodPressureStateNotMeasure;
    [super lostConnect];
}
#pragma mark service
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    if (error) {
        DDLogDebug(@"error:%@",error);
        [self noticeWithError:error];
    }else{
        DDLogDebug(@"service:%@",peripheral.services);
        for (CBService *service in peripheral.services) {
            CBUUID *uuid=service.UUID;
            NSString *uuidStr=uuid.UUIDString;
            if ([uuidStr isEqualToString:@"FFF0"]) {
                [peripheral discoverCharacteristics:nil forService:service];
                break;
            }
        }
    }
}
#pragma mark characteristics
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    DDLogDebug(@"service:%@,chars:%@",service,service.characteristics);
    if (error) {
        [self noticeWithError:error];
        DDLogDebug(@"error:%@",error);
        return;
    }
    for (CBCharacteristic *aCharacter in service.characteristics) {
        CBCharacteristicProperties properties=  aCharacter.properties;
        if (properties ==CBCharacteristicPropertyNotify) {
            //这款血压仪添加了监听就能自己传数据过来
            [peripheral setNotifyValue:YES forCharacteristic:aCharacter];
        }
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    DDLogDebug(@"didUpdateValue:%@",characteristic);
    NSData *data= characteristic.value;
    DDLogDebug(@"data:%@",data);
    NSInteger length=data.length;
    if (length==2 && self.state==BloodPressureStateNotMeasure && [self isMessureData:data]) {
        self.state=BloodPressureStateMeasuring;
        
        return;
    }
    
    if(length>2 && self.state==BloodPressureStateMeasuring){
        self.state=BloodPressureStateMeasured;
        NSString *dataStr=[NSString stringWithFormat:@"%@",data];
        dataStr=[dataStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        dataStr=[dataStr stringByReplacingOccurrencesOfString:@"<" withString:@""];
        dataStr=[dataStr stringByReplacingOccurrencesOfString:@">" withString:@""];
        //失败
        self.state=BloodPressureStateMeasured;
        if([dataStr hasPrefix:@"ff"]){ //if2
              NSError *error=[NSError errorWithDomain:HCYBlueToothErrorDomain code:1 userInfo:@{NSLocalizedDescriptionKey:@"测量出错"}];
            [self noticeWithError:error];
            DDLogDebug(@"失败的数据");
        }else{
            if (dataStr.length==24) {  //if1
                NSString *highStr=[dataStr substringWithRange:NSMakeRange(2, 4)];
                NSString *lowStr=[dataStr substringWithRange:NSMakeRange(6, 4)];
                NSString *hbStr=[dataStr substringWithRange:NSMakeRange(14, 4)];
                BloodPressureInfo *info=[BloodPressureInfo new];
                info.highPressure=[self bloodPressureWithStr:highStr];
                info.lowPressure=[self bloodPressureWithStr:lowStr];
                info.pluseRate=[self bloodPressureWithStr:hbStr];
                self.data=info;
                [self noticeWithError:nil];
            }else{
                NSError *error=[NSError errorWithDomain:HCYBlueToothErrorDomain code:1 userInfo:@{NSLocalizedDescriptionKey:@"返回的数据格式不正确"}];
                DDLogDebug(@"血压仪返回数据程序无法读取:%@",dataStr);
                [self noticeWithError:error];
            }//end if1
            return;
        } //end if2

    }
    if(self.state==BloodPressureStateMeasured && length==2 && [self isMessureData:data]){
        self.state=BloodPressureStateMeasuring;
    }
    DDLogDebug(@"忽略数据:%@",data);

}
-(BOOL)needCheckDevice{
    return YES;
}
-(void)noticeWithError:(NSError *)error{
    self.reading=NO;
    [super noticeWithError:error];
}
-(void)setState:(BloodPressureState)state{
    if (state==_state) {
        return;
    }
    DDLogDebug(@"setState:%ld",(long)state);
    _state=state;
    switch (state) {
        case BloodPressureStateNotMeasure:
        {
            DDLogDebug(@"状态->未测量");
        }
            break;
        case BloodPressureStateMeasured:
        {
            DDLogDebug(@"状态->测量结束");
        }
            break;
        case BloodPressureStateMeasuring:
        {
            DDLogDebug(@"状态->测量中");
        }
            break;
        default:
            break;
    }
    if ([self.delegate respondsToSelector:@selector(bluetooth:changeState:)]) {
        [self.delegate bluetooth:self noticeCustomStateChange:@{BloodPressureKeyState:@(state)}];
    }
    
}
-(BOOL)isMessureData:(NSData *)data{
    NSString *dataStr=[NSString stringWithFormat:@"%@",data];
    if ([dataStr hasPrefix:@"20"]) {
    }
    return YES;
}
-(NSInteger)bloodPressureWithStr:(NSString *)str{
    if (str.length==4) {
        NSScanner *scanner = [[NSScanner alloc] initWithString:str];
        unsigned int result=0;
        [scanner scanHexInt:&result];
        return  result;
    }
    return -1;
    
    
}

#pragma mark commond

-(Byte)lastByte:(Byte[])cmd{
    int result=0;
    for (int i=1; i<sizeof(cmd); i++) {
        Byte b=cmd[i];
        result=result^b;
    }
    return (Byte)result;
}

@end

@implementation BloodPressureInfo
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"info":@"Info"};
}
@end

