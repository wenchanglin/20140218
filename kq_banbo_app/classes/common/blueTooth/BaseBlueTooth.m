//
//  BaseBlueTooth.m
//  Test
//
//  Created by hcy on 2016/12/19.
//  Copyright © 2016年 hcy. All rights reserved.
//

#import "BaseBlueTooth.h"
#import "BanBoCommonInterManager.h"
NSString *const HCYBlueToothErrorDomain=@"HCYBlueToothErrorDomain";
@interface BaseBlueTooth()<CBCentralManagerDelegate>
@property(strong,nonatomic,readonly)CBCentralManager *manager;

@end
@implementation BaseBlueTooth
- (instancetype)init
{
    self = [super init];
    if (self) {
        //5
        self.timeCountInterval=30;
    }
    return self;
}

@synthesize manager=_manager;

-(CBCentralManager *)manager{
    if (!_manager) {
        dispatch_queue_t queue=dispatch_queue_create("blueToothHCY", DISPATCH_QUEUE_SERIAL);
        CBCentralManager *centeralManager=[[CBCentralManager alloc] initWithDelegate:self queue:queue];
        _manager=centeralManager;
        
        
    }
    return _manager;
}
-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    [self.delegate bluetooth:self changeState:central.state];
}
-(void)setDelegate:(id<HCYBlueToothDelegate>)delegate{
    _delegate=delegate;
    self.manager.delegate=self;
    
}

-(void)noticeConnectResultWithError:(NSError *)error{
    DDLogDebug(@"noticeConnectResultWithError:%@",error);
    dispatch_async_main_safe(^{
        if ([self.delegate respondsToSelector:@selector(bluetooth:connectPeripheralWithError:)]) {
            [self.delegate bluetooth:self connectPeripheralWithError:error];
        }        
    });

}
-(void)noticeWithError:(NSError *)error{
    dispatch_async_main_safe(^{
        if([self.delegate respondsToSelector:@selector(bluetooth:commondResult:error:)]){
            [self.delegate bluetooth:self commondResult:self.data error:error];
        }
    });
    
    self.reading=NO;
}

#pragma mark 扫描
-(BOOL)canScan{
    return self.manager.state==CBManagerStatePoweredOn;
}
-(void)startScan{
   
    BOOL canScan=NO;
    NSError *error=nil;
    switch (self.manager.state) {
        case CBManagerStatePoweredOn:
        {
            canScan=YES;
            
        }
            break;
        case CBManagerStatePoweredOff:
        {
            error=[NSError errorWithDomain:HCYBlueToothErrorDomain code:1 userInfo:@{NSLocalizedDescriptionKey:@"请打开蓝牙"}];
            self.peripheral=nil;
        }
            break;
        case CBManagerStateUnknown:
        {
        }
            break;
        case CBManagerStateResetting:
        {
            error=[NSError errorWithDomain:HCYBlueToothErrorDomain code:1 userInfo:@{NSLocalizedDescriptionKey:@"请重启蓝牙"}];
        }
            break;
        case CBManagerStateUnsupported:
        case CBManagerStateUnauthorized:
        {
            error=[NSError errorWithDomain:HCYBlueToothErrorDomain code:1 userInfo:@{NSLocalizedDescriptionKey:@"设备没有蓝牙获取权限已经被禁用"}];
        }
        default:
            break;
    }
    if(!canScan){
        if (error) {
            [self noticeConnectResultWithError:error];
        }
        return;
        
    }
    [self.manager scanForPeripheralsWithServices:nil options:nil];
    __weak typeof(self) wself=self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.timeCountInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (wself) {
            if (wself.peripheral==nil) {
                [wself stopScan];
                [wself noticeConnectResultWithError:[BaseBlueTooth noAuthError]];
            }
        }
        
    });


}
+(NSError *)noAuthError{
    return [NSError errorWithDomain:HCYBlueToothErrorDomain code:1 userInfo:@{NSLocalizedDescriptionKey:@"没有找到设备"}];
}
-(void)stopScan{

    [self.manager stopScan];
}
#pragma mark managerDelegate
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI{
    DDLogDebug(@"per:%@",peripheral);
    if ([peripheral.name isEqualToString:self.deviceName]) {
        [self stopScan];
        if (_peripheral) {
            return;
        }
        DDLogDebug(@"tryToConnectPeripheral:%@",peripheral);
        peripheral.delegate=self;
        _peripheral=peripheral;
        [_peripheral discoverServices:@[[CBUUID UUIDWithString:@"180A"]]];
        
        //if ([self needCheckDevice]) {
          //  BanboBlueToothInfo *info=[BanboBlueToothInfo new];
            //info.name=self.deviceName;
           // info.identifier=peripheral.identifier.UUIDString;
//            __weak typeof(self) wself=self;
//            [[BanBoCommonInterManager sharedInstance] checkBlueToothWithInfo:info completion:^(id data, NSError *error) {
//                if (error) {
//                    wself.peripheral=nil;
//                    [wself connectPeripheralWithError:[BaseBlueTooth noAuthError]];
//                }else{
                    [central connectPeripheral:self.peripheral options:nil];//wself.peripheral
//                }
//            }];
      //  }else{
        //    [central connectPeripheral:peripheral options:nil];
        }
    //}
}

#pragma mark 连接
-(void)connectPeripheral{
    if (self.peripheral) {
        [self noticeConnectResultWithError:nil];
    }else{
        [self startScan];
    }
}
-(void)releasePeripheral{
    if(self.peripheral){
        [self.manager cancelPeripheralConnection:self.peripheral];
        DDLogDebug(@"取消连接设备");
    }
}

#pragma mark 连接相关回调
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    DDLogDebug(@"didConnect");
    [self connectPeripheralWithError:nil];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    DDLogDebug(@"didFailToConnectPeripheral:%@",error);
    [self connectPeripheralWithError:error];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    _peripheral=nil;
    DDLogDebug(@"didDisconnectPeripheral:%@",error);
    [self lostConnect];
}
#pragma mark 默认实现
-(void)readData{
    
}
-(BOOL)needCheckDevice{
    return NO;
}
#pragma mark public
-(void)connectPeripheralWithError:(NSError *)error{
    [self stopScan];
    [self noticeConnectResultWithError:error];
}
-(void)loseConnectWithError:(NSError *)error{
    if ([self.delegate respondsToSelector:@selector(bluetooth:lostConnectWithError:)]) {
        [self.delegate bluetooth:self lostConnectWithError:error];
    }
    self.peripheral=nil;
}
-(void)lostConnect{
    [self loseConnectWithError:[NSError errorWithDomain:HCYBlueToothErrorDomain code:1 userInfo:@{NSLocalizedDescriptionKey:@"连接已断开"}]];
}
-(void)dealloc{

    DDLogDebug(@"baseBlueTooth-dealloc:%@",self);
}
@end
