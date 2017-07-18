//
//  NVRSDKManager.m
//  kq_banbo_app
//
//  Created by hcy on 2017/2/20.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "NVRSDKManager.h"
#import "hcnetsdk.h"
#import "IOSPlayM4.h"
#include <stdio.h>
#include <ifaddrs.h>
#include <sys/socket.h>
#include <sys/poll.h>
#include <net/if.h>
#include <map>
#import "HikDec.h"
#import "Preview.h"

//莹石
//不抽了。太麻烦。跟demo一样把
//sdkfrom 。用来资源释放用
typedef NS_ENUM(NSInteger,NVRSDKFrom){
    NVRSDKFromNone=0,
    NVRSDKFromHK,
    NVRSDKFromYS
};
@interface NVRSDKManager(){
    //海康
    int m_lUserID;
    int g_iStartChan;
    int g_iPreviewChanNum;
    dispatch_queue_t queue;
}
@property(assign,nonatomic)NVRSDKFrom sdkfrom;
@property(strong,nonatomic)NVRChannel *currentChannel;
//萤石




@end
@implementation NVRSDKManager
- (instancetype)init
{
    self = [super init];
    if (self) {
        BOOL bRet = NET_DVR_Init();
        if (!bRet)
        {
            DDLogError(@"NET_DVR_Init failed");
        }else{
            queue=dispatch_queue_create("hkQueue", DISPATCH_QUEUE_CONCURRENT);
        }
    }
    return self;
}
-(void)clean{
    if(self.sdkfrom==NVRSDKFromHK){
        if (queue) {
            dispatch_async(queue, ^{
                stopPreview(0);
                NET_DVR_Logout(m_lUserID);
                NET_DVR_Cleanup();
            });
        }else{
            stopPreview(0);
            NET_DVR_Logout(m_lUserID);
            NET_DVR_Cleanup();
        }
    }else if (self.sdkfrom==NVRSDKFromYS){
//        [EZOpenSDK releasePlayer:_player];
//        [EZOpenSDK releasePlayer:_talkPlayer];
    }
}
-(void)dealloc{
    DDLogInfo(@"NVRSDKManager-dealloc");
}
#pragma mark 登录
-(void)loginDeviceWithInfo:(NVRLoginInfo *)info completion:(NVRLoginCompletionBlock)completion{
    if (!completion) {
        return;
    }
    dispatch_async(queue, ^{
        if ([info isKindOfClass:[HKLoginInfo class]]) {
            self.sdkfrom=NVRSDKFromHK;
            [self loginHKWithInfo:(HKLoginInfo *)info completion:completion];
        }else if ([info isKindOfClass:[YSLoginInfo class]]){
            self.sdkfrom=NVRSDKFromYS;
            [self loginYSWithInfo:(YSLoginInfo *)info completion:completion];
        }
    });
}

-(void)loginYSWithInfo:(YSLoginInfo *)info completion:(NVRLoginCompletionBlock)completion{
    //萤石

}
-(void)loginHKWithInfo:(HKLoginInfo *)info completion:(NVRLoginCompletionBlock)completion{
    NET_DVR_DEVICEINFO_V30 logindeviceInfo = {0};
    
    // encode type
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    m_lUserID = NET_DVR_Login_V30((char*)[info.remoteUrl UTF8String],
                                  info.port,
                                  (char*)[info.userName cStringUsingEncoding:enc],
                                  (char*)[info.pwd UTF8String],
                                  &logindeviceInfo);
    DDLogInfo(@"start-LoginNVRDevice");
    //     login on failed
    if (m_lUserID == -1)
    {
        DDLogInfo(@"LoginNVRDevice-fail");
        char *msg=NET_DVR_GetErrorMsg();
        if (msg==NULL) {
            msg=(char *)[@"loginDeviceFailed" UTF8String];
        }
        NSError *error=[NSError errorWithDomain:@"" code:1 userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithUTF8String:msg]}];
        completion(nil,error);
        return;
    }
    //数字通道
    if(logindeviceInfo.byIPChanNum > 0)
    {
        g_iStartChan = logindeviceInfo.byStartDChan;
        g_iPreviewChanNum = logindeviceInfo.byIPChanNum + logindeviceInfo.byHighDChanNum * 256;
        NSArray*channels=[self getChannels];
        completion(channels,nil);
        
    }else{
        NSError *error=[NSError errorWithDomain:@"" code:2 userInfo:@{NSLocalizedDescriptionKey:@"没有通道"}];
        completion(nil,error);
        return;
    }
}


-(NSArray *)getChannels{
    DDLogInfo(@"getChannels");
    NET_DVR_IPPARACFG_V40 cfg={0};
    DWORD ret;
    NSMutableArray *channnelArrM=[NSMutableArray array];
    //获得能用的通道数
    int enableCount=0;
    bool b=  NET_DVR_GetDVRConfig(m_lUserID, NET_DVR_GET_IPPARACFG_V40, 0,&cfg , sizeof(cfg), &ret);
    if (b) {
        int devInfoCount=sizeof(cfg.struIPDevInfo)/sizeof(NET_DVR_IPDEVINFO_V31);
        for (int i=0; i<devInfoCount; i++) {
            NET_DVR_IPDEVINFO_V31 info=cfg.struIPDevInfo[i];
            if (info.byEnable==1) {
                enableCount++;
            }
        }
        DDLogDebug(@"enableCount:%d",enableCount);
    }else{
        //激活失
        DDLogError(@"getDVR_CONFIG_ERROR");
        return @[];
    }
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingEUC_CN);
    for(int i=0;i<enableCount;i++){
        NET_DVR_PICCFG_V30 piccfg;
        DWORD ret=0;
        int channelNum=33+i;
        if (NET_DVR_GetDVRConfig(m_lUserID, NET_DVR_GET_PICCFG_V30,channelNum , &piccfg, sizeof(NET_DVR_PICCFG_V30),&ret)) {
            NSString *str2=[NSString stringWithCString:(char *)piccfg.sChanName encoding:enc];
            HKChannel *channel=[HKChannel new];
            channel.num=channelNum;
            channel.name=str2;
            [channnelArrM addObject:channel];
        }
    }
    
    return [channnelArrM copy];
    
}

-(void)playChanel:(HKChannel *)channel onView:(UIView *)view completion:(void (^)(NSError *))completion{
    if(!channel || !view){
        completion([NSError errorWithDomain:@"" code:1 userInfo:@{NSLocalizedDescriptionKey:@"参数缺少"}]);
    }
    if(self.currentChannel){
        stopPreview(0);
    }
   int previewID= startPreview(m_lUserID, channel.num, view, 0);
    DDLogDebug(@"preivewId:%d",previewID);
    if (previewID==-1) {
        NSError *error=[NSError errorWithDomain:@"" code:2 userInfo:@{NSLocalizedDescriptionKey:@"视频播放失败"}];
        completion(error);
    }else{

        
        self.currentChannel=channel;
        completion(nil);
    }
}

@end
#pragma mark 登录信息类实现
@implementation NVRLoginInfo
@end
@implementation HKLoginInfo
@end
@implementation YSLoginInfo
@end

#pragma mark 通道类实现
@implementation NVRChannel
@end

@implementation HKChannel
-(NSString *)channelNumStr{
    return [NSString stringWithFormat:@"%d",self.num];
}

@end
