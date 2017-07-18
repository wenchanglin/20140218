//
//  IDCardBlueTooth.m
//  Test
//
//  Created by hcy on 2016/12/19.
//  Copyright © 2016年 hcy. All rights reserved.
//

#import "IDCardBlueTooth.h"
#import "AppDelegate.h"
@interface IDCardBlueTooth()
@property(assign,nonatomic)NSInteger step;
@property(strong,nonatomic)NSMutableData *idCardData;

@property(assign,nonatomic)NSInteger maxTryCount;
@property(assign,nonatomic)NSInteger currentTryIdx;
@end
@implementation IDCardBlueTooth
- (instancetype)init
{
    self = [super init];
    if (self) {

        self.deviceName=@"Dual-SPP";
    }
    return self;
}
-(void)readData{
   
    if (self.isReading) {
        DDLogDebug(@"readingReturn");
        return;
    }
    self.reading=YES;
    if (self.peripheral==nil) {
        if ([self.delegate respondsToSelector:@selector(bluetooth:commondResult:error:)]) {
            NSError *error=[NSError errorWithDomain:HCYBlueToothErrorDomain code:1 userInfo:@{NSLocalizedDescriptionKey:@"没有连接设备"}];
            [self.delegate bluetooth:self commondResult:nil error:error];
        }
        return;
    }else{
        self.data=nil;
        self.step=0;
        self.maxTryCount=3;
        self.currentTryIdx=1;
        [self.peripheral discoverServices:nil];
    }
}
-(void)connectPeripheralWithError:(NSError *)error{
    [super connectPeripheralWithError:error];
}

#pragma mark peripheralDelegate
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    if (!error) {
        for(CBService *service in peripheral.services){
            NSString *uuidStr=service.UUID.UUIDString;
            if ([uuidStr isEqualToString:@"49535343-FE7D-4AE5-8FA9-9FAFD205E455"]) {
                [peripheral discoverCharacteristics:nil forService:service];
                break;
            }
        }
    }else{
        DDLogDebug(@"discoverService error:%@",error);
    }
}
#define ReadWriteCode     @"49535343-6DAA-4D02-ABF6-19569ACA69FE"
#define WriteNotifyCode   @"49535343-ACA3-481C-91EC-D85E28A60318"
#define Notify            @"49535343-1E4D-4BD9-BA61-23C647249616"
#define WriteCode         @"49535343-8841-43F4-A8D4-ECBE34729BB3"
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    DDLogDebug(@"char:%@",service.characteristics);
    for (CBCharacteristic *character in service.characteristics) {
        NSString *uuid=character.UUID.UUIDString;
        if ([uuid isEqualToString:WriteCode]) {
            self.writeCharacter=character;
        }
        if([uuid isEqualToString:ReadWriteCode]){
            self.readCharacter=character;
        }
        if ([uuid isEqualToString:Notify] /*|| [uuid isEqualToString:WriteNotifyCode]*/) {
            [peripheral setNotifyValue:YES forCharacteristic:character];
        }
    }
    [self sendCommond];
    
}

#pragma mark 命令
-(void)sendCommond{
    if (self.step==0) {
        [self findCard];
    }else if (self.step==1){
        [self selt];
    }else if (self.step==2){
        [self read];
    }else{
        DDLogDebug(@"unsupport Step:%ld",(long)self.step);
    }
}
-(void)findCard{
    DDLogDebug(@"send-findCardCommand");
    self.step=1;
    Byte cmd[]= {(Byte)0xAA,(Byte)0xAA,(Byte)0xAA,0x96, 0x69, 0x00, 0x03, 0x20, 0x01, 0x22};

    NSData *data=[NSData dataWithBytes:cmd length:sizeof(cmd)];
    [self.peripheral writeValue:data forCharacteristic:self.writeCharacter type:CBCharacteristicWriteWithoutResponse];

}
-(void)selt{
    DDLogDebug(@"send-seltCommand");
    self.step=2;
    Byte cmd[] = {(Byte) 0xAA, (Byte) 0xAA, (Byte) 0xAA,0x96, 0x69, 0x00, 0x03, 0x20, 0x02, 0x21  };
    NSData *data=[NSData dataWithBytes:cmd length:sizeof(cmd)];
    [self.peripheral writeValue:data forCharacteristic:self.writeCharacter type:CBCharacteristicWriteWithResponse];
    
}
-(void)read{
    DDLogDebug(@"send-readCommand");
    self.step=3;
    self.idCardData=[NSMutableData data];
    Byte cmd[]= {(Byte) 0xAA, (Byte) 0xAA, (Byte) 0xAA, (Byte) 0x96, 0x69, 0x00, 0x03, 0x30, 0x10, 0x23 };
    NSData *data=[NSData dataWithBytes:cmd length:sizeof(cmd)];
    [self.peripheral writeValue:data forCharacteristic:self.writeCharacter type:CBCharacteristicWriteWithoutResponse];
}
-(void)waitCommand{
    self.step=4;
    DDLogDebug(@"waitResult");
}
-(BOOL)checkRespVal:(NSData *)data{
    Byte respByte[data.length];
    BOOL result=NO;
    [data getBytes:&respByte length:data.length];
    
    @try {
        switch (self.step) {
            case 1:
            {
                if (respByte[9]==(Byte)-97) {
                    result=YES;
                }else{
                    DDLogDebug(@"findCardError:%@",data);
                }
            }
            break;
            case 2:
            {
                if (respByte[9]==(Byte)-112) {
                    result=YES;
                }else{
                    DDLogDebug(@"seltCardError:%@",data);
                }
            }
                break;
            case 3:
            {
                if (self.idCardData.length==0){
                    if (respByte[9]==(Byte)-112) {
                        result=YES;
                    }else{
                        DDLogDebug(@"readCardError:%@",data);
                    }
                }else{
                    DDLogDebug(@"");
                    result=YES;
                }
                if (self.step>=3) {
                    [self.idCardData appendBytes:respByte length:data.length];
                    //为什么是1296.demo里就这么写的~
                    if (self.idCardData.length>=1296) {
                        [self execResultData];
                    }
                    DDLogDebug(@"readCardGetLength:%@,count to:%ld",data,self.idCardData.length);
                }
            }
                break;
            case 4:
                result=YES;
                break;
            default:
            break;
        }
        
    } @catch (NSException *exception) {
    } @finally {
    }
    return result;
}
-(NSString *)toUTF8:(NSString *)str{
    NSData *data=[str dataUsingEncoding:NSUTF16StringEncoding];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}
#pragma mark 数据解析
-(void)execResultData{
    DDLogDebug(@"exec");
    Byte prefix[]={0xff,0xfe};
    NSData *strdata= [self.idCardData subdataWithRange:NSMakeRange(16, 256)];//16,256
    NSMutableData *newDataM=[NSMutableData dataWithBytes:prefix length:2];
    [newDataM appendData:strdata];

    NSString *str=[[NSString alloc] initWithData:newDataM encoding:NSUTF16LittleEndianStringEncoding];

    DDLogDebug(@"姓名:%@",str);
    NSInteger start=0;
    NSString *name=[self subStrFromStr:str start:&start length:16];
    NSString *sexCode=[self subStrFromStr:str start:&start length:1];
    NSString *nation_code = [self subStrFromStr:str start:&start length:2];
    
    NSString *birth_year=[self subStrFromStr:str start:&start length:4];
    NSString *birth_month=[self subStrFromStr:str start:&start length:2];
    NSString *birth_day=[self subStrFromStr:str start:&start length:2];
    
    NSString *birthday=[NSString stringWithFormat:@"%@-%@-%@",birth_year,birth_month,birth_day];
    NSString *address=[self subStrFromStr:str start:&start length:35];
    NSString *id_num=[self subStrFromStr:str start:&start length:18];
    NSString *signOffice=[self subStrFromStr:str start:&start length:15];
    
    
    
    NSString *useful_s_year=[self subStrFromStr:str start:&start length:4];
    NSString *useful_s_month=[self subStrFromStr:str start:&start length:2];
    NSString *useful_s_day=[self subStrFromStr:str start:&start length:2];
    
    NSString *useful_s_date=[NSString stringWithFormat:@"%@-%@-%@",useful_s_year,useful_s_month,useful_s_day];
    NSString *useful_e_year=[self subStrFromStr:str start:&start length:4];
    NSString *useful_e_date=@"长";
    if (![useful_e_year isEqualToString:@"长"]) {
        NSString *useful_e_month=[self subStrFromStr:str start:&start length:2];
        NSString *useful_e_day=[self subStrFromStr:str start:&start length:2];
        useful_e_date=[NSString stringWithFormat:@"%@-%@-%@",useful_e_year,useful_e_month,useful_e_day];
    }
    IDCardInfo *info=[IDCardInfo new];
    info.name=name;
    info.sexNum=[sexCode integerValue];
    if([sexCode isEqualToString:@"1"]){
            info.gender=@"男";
    }else if ([sexCode isEqualToString:@"2"]){
        info.gender=@"女";
    }else if([sexCode isEqualToString:@"0"]){
        info.gender=@"未知";
    }else if ([sexCode isEqualToString:@"9"]){
        info.gender=@"未说明";
    }else{
        info.gender=sexCode;
    }
    info.nation=[self nationStrWithCode:nation_code];
    info.birthDay=birthday;
    info.address=address;
    info.id_num=id_num;
    info.sign_office=signOffice;
    info.useful_s_date=useful_s_date;
    info.useful_e_date=useful_e_date;
    self.data=info;
    [self noticeWithError:nil];
}
-(NSString *)subStrFromStr:(NSString *)str start:(NSInteger*)start length:(NSInteger)length{
    NSString *retStr= [str substringWithRange:NSMakeRange(*start, length)];
    *start+=length;
    retStr=[retStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    return retStr;
    
}
#pragma mark  characteristic代理
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
//    NSLog(@"val:%@,char:%@,%@",characteristic.value,characteristic.UUID,characteristic.UUID.UUIDString);
//    return;
    if ([self checkRespVal:characteristic.value]) {
        [self sendCommond];
    }else{
        DDLogDebug(@"checkRespValFailure");
        if(self.currentTryIdx<self.maxTryCount){
            self.step=0;
            [self sendCommond];
            self.currentTryIdx++;
            DDLogDebug(@"进行:%ld次尝试",(long)self.currentTryIdx);
        }else{
            NSString *errorStr=@"读取信息失败";
            switch (self.step) {
                case 1:
                {
                    errorStr=@"寻卡失败";
                }
                    break;
                case 2:
                {
                    errorStr=@"打开卡失败";
                }
                    break;
                case 3:
                {
                    errorStr=@"读取卡失败";
                }
                    break;
                default:
                    break;
            }
            NSError *error=[NSError errorWithDomain:HCYBlueToothErrorDomain code:1 userInfo:@{NSLocalizedDescriptionKey:errorStr}];
            [self noticeWithError:error];
        }
    
    }
}
-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    DDLogDebug(@"didWriteValue:%@ ,error:%@",characteristic,error);
}
-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    DDLogDebug(@"didUpdateNotificationState:%@,error:%@",characteristic,error);
    if (error) {
        DDLogDebug(@"notifyError:%@",error);
    }else{
    }
}
#pragma mark privateFunc
-(NSString *)nationStrWithCode:(NSString *)nationCode
{
    NSInteger code=[nationCode integerValue];
    NSString* nation;
    switch (code)
    {
        case 1:
            nation = @"汉";
            break;
        case 2:
            nation = @"蒙古";
            break;
        case 3:
            nation = @"回";
            break;
        case 4:
            nation = @"藏";
            break;
        case 5:
            nation = @"维吾尔";
            break;
        case 6:
            nation = @"苗";
            break;
        case 7:
            nation = @"彝";
            break;
        case 8:
            nation = @"壮";
            break;
        case 9:
            nation = @"布依";
            break;
        case 10:
            nation = @"朝鲜";
            break;
        case 11:
            nation = @"满";
            break;
        case 12:
            nation = @"侗";
            break;
        case 13:
            nation = @"瑶";
            break;
        case 14:
            nation = @"白";
            break;
        case 15:
            nation = @"土家";
            break;
        case 16:
            nation = @"哈尼";
            break;
        case 17:
            nation = @"哈萨克";
            break;
        case 18:
            nation = @"傣";
            break;
        case 19:
            nation = @"黎";
            break;
        case 20:
            nation = @"傈僳";
            break;
        case 21:
            nation = @"佤";
            break;
        case 22:
            nation = @"畲";
            break;
        case 23:
            nation = @"高山";
            break;
        case 24:
            nation = @"拉祜";
            break;
        case 25:
            nation = @"水";
            break;
        case 26:
            nation = @"东乡";
            break;
        case 27:
            nation = @"纳西";
            break;
        case 28:
            nation = @"景颇";
            break;
        case 29:
            nation = @"柯尔克孜";
            break;
        case 30:
            nation = @"土";
            break;
        case 31:
            nation = @"达斡尔";
            break;
        case 32:
            nation = @"仫佬";
            break;
        case 33:
            nation = @"羌";
            break;
        case 34:
            nation = @"布朗";
            break;
        case 35:
            nation = @"撒拉";
            break;
        case 36:
            nation = @"毛南";
            break;
        case 37:
            nation = @"仡佬";
            break;
        case 38:
            nation = @"锡伯";
            break;
        case 39:
            nation = @"阿昌";
            break;
        case 40:
            nation = @"普米";
            break;
        case 41:
            nation = @"塔吉克";
            break;
        case 42:
            nation = @"怒";
            break;
        case 43:
            nation = @"乌孜别克";
            break;
        case 44:
            nation = @"俄罗斯";
            break;
        case 45:
            nation = @"鄂温克";
            break;
        case 46:
            nation = @"德昂";
            break;
        case 47:
            nation = @"保安";
            break;
        case 48:
            nation = @"裕固";
            break;
        case 49:
            nation = @"京";
            break;
        case 50:
            nation = @"塔塔尔";
            break;
        case 51:
            nation = @"独龙";
            break;
        case 52:
            nation = @"鄂伦春";
            break;
        case 53:
            nation = @"赫哲";
            break;
        case 54:
            nation = @"门巴";
            break;
        case 55:
            nation = @"珞巴";
            break;
        case 56:
            nation = @"基诺";
            break;
        case 97:
            nation = @"其他";
            break;
        case 98:
            nation = @"外国血统中国籍人士";
            break;
        default:
            nation = @"";
            break;
    }
    return nation;
}
@end
#pragma mark cardInf
@implementation IDCardInfo

-(NSDictionary *)param{
    NSStringEncoding enc1 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *data1 = [self.name dataUsingEncoding:enc1];
    NSString *retStr1 = [[NSString alloc] initWithData:data1 encoding:enc1];
    NSStringEncoding enc2 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *data2 = [self.address dataUsingEncoding:enc2];
    NSString *retStr2 = [[NSString alloc] initWithData:data2 encoding:enc2];
    NSStringEncoding enc3 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *data3 = [self.id_num dataUsingEncoding:enc3];
    NSString *retStr3 = [[NSString alloc] initWithData:data3 encoding:enc3];
    return @{@"Name":retStr1,
             @"Sex":@(self.sexNum),
             @"Address":retStr2,
             @"CardId":retStr3};
   
}

@end

