//
//  HCYUtil.m
//  NewYiContact
//
//  Created by hcy on 2/19/15.
//  Copyright (c) 2015 hcy. All rights reserved.
//

#import "HCYUtil.h"

#import "UIView+Toast.h"
//hcy518
#import <SVProgressHUD/SVProgressHUD.h>
#import <MBProgressHUD.h>
#import <AFNetworkReachabilityManager.h>

#import <SystemConfiguration/CaptiveNetwork.h>

@interface HCYUtil()<UIAlertViewDelegate>
@end
@implementation HCYUtil
+(CGRect)screenRect{
    return  [UIScreen mainScreen].bounds;
}
+ (void)initialize
{
    if (self == [HCYUtil class]) {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    }
}
#pragma mark 网络
+(NSString *)wifiName{
    CFArrayRef myArray = CNCopySupportedInterfaces();
    NSString *wifiName=@"";
    if (myArray != nil) {
        
        CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        
        if (myDict != nil) {
            
            NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
            
            
            
            wifiName = [dict valueForKey:@"SSID"];
            
        }
    }
    
    return wifiName;
}
#pragma mark 提示类

+(void)toastMsg:(NSString *)msg inView:(UIView *)view{
    if(view==nil){
        view=[[UIApplication sharedApplication].windows lastObject];
    }
    dispatch_async_main_safe(^{
        DDLogInfo(@"showToast:%@ inView:%@",msg,view);
        [view makeToast:msg duration:2.0 position:CSToastPositionCenter];
    });
}
+(void)showProgressWithStr:(NSString *)str{
    DDLogDebug(@"showProgress:%@",str);
    dispatch_async_main_safe(^{
        [SVProgressHUD showWithStatus:str];
    });
}
+(void)showProgressWithProcess:(CGFloat)process{
    dispatch_async_main_safe(^{
        [SVProgressHUD showProgress:process];
    });
}
+(void)showProgress:(CGFloat)progress str:(NSString *)str{
    dispatch_async_main_safe(^{
        [SVProgressHUD showProgress:progress status:str];
    });
}
+(BOOL)isShowProgress{
    return [SVProgressHUD isVisible];
}
+(void)dismissProgress{
    DDLogDebug(@"dismissProgress");
    dispatch_async_main_safe(^{
        [SVProgressHUD dismiss];
    });
}
+(void)showError:(NSError *)error{
    if (error.code!=BanBoRemoteErrorTokenInvalid) {
        NSString *str=@"";
        NSDictionary *dict=[error userInfo];
        if (dict[@"resultDes"]) {
            str=dict[@"resultDes"];
        }
        if (str.length==0) {
            str=dict[NSLocalizedDescriptionKey];
        }
        if(str.length==0){
            NSString *domainStr=@"错误";
            if ([error.domain isEqualToString:NSURLErrorDomain]) {
                domainStr=@"网络错误";
            }
            str=[NSString stringWithFormat:@"%@ %ld",domainStr,(long)error.code];
        }
       
       [self showErrorWithStr:str];
    }
}
+(void)showErrorWithStr:(NSString *)errorStr{
    [self toastMsg:errorStr inView:nil];
}
#pragma mark 颜色图片
+ (UIImage*) createImageWithColor: (UIColor*) color
{
    return [self createImageWithColor:color size:CGSizeMake(1.f, 1.f)];
}
+(UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)imageSize{
    CGRect rect=CGRectMake(0.0f, 0.0f, imageSize.width, imageSize.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
#pragma mark UI
+(UIBarButtonItem *)getNilBarItemWithWidth:(CGFloat )width{
    UIBarButtonItem*  negativeSpacer=  [[UIBarButtonItem alloc]
                                        initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                        target:nil action:nil];
    negativeSpacer.width = width;
    return negativeSpacer;
}
#pragma mark 类型转换
+(NSString *)dateStrFromDate:(NSDate *)date dateFormat:(NSString *)dateformat{
    NSDateFormatter *formatter=[self hcyUtil_dateFormatter];
    formatter.dateFormat=dateformat;
    return [formatter stringFromDate:date];
}
+(NSDate *)dateFromString:(NSString *)dateStr dateFormat:(NSString *)dateformat{
    NSDateFormatter *formatter=[self hcyUtil_dateFormatter];
    formatter.dateFormat=dateformat;
    return [formatter dateFromString:dateStr];
}

static NSDateFormatter *dataFormatter;
+(NSDateFormatter *)hcyUtil_dateFormatter{
    if (!dataFormatter) {
    dataFormatter=[[NSDateFormatter alloc] init];
    }
    return dataFormatter;
}
#pragma mark 计算
+(CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize attrs:(NSDictionary *)attris{
    CGRect rect=[text boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading attributes:attris context:nil];
    return rect.size;
}
+(NSInteger)getDecimalCountForFloat:(CGFloat)f{
    int result=0;
    [self getDecimalCountForFloat:f count:&result];
    return result;
}
+(void)getDecimalCountForFloat:(CGFloat)f count:(int *)count{
    if (f-(NSInteger)f==0) {
        return;
    }else{
        *count=*count+1;
        f=(f-(NSInteger)f)*10;
        [self getDecimalCountForFloat:f count:count];
    }
}
#pragma mark 文本处理
+(NSString *)escapeWithStr:(NSString *)str{
    if (str==nil || ![str isKindOfClass:[NSString class]]) {
        return @"";
    }

    __block NSString *changeStr=str;
    NSDictionary *changeDict=@{@"'":@"''",
                           @"/":@"//",
                           @"[":@"/[",
                           @"]":@",]",
                           @"%%":@"/%%",
                           @"&":@"/&",
                           @"_":@"/_",
                           @"(":@"/(",
                           @")":@"/)"};
    [changeDict enumerateKeysAndObjectsUsingBlock:^(NSString* key, id obj, BOOL *stop) {
//        NSString *val=changeDict[key];
//        changeStr=[changeStr replaceStr:key WithStr:val];
    }];
    if (![str isEqualToString:changeStr]) {
        DDLogDebug(@"sqlChange-fromStr:%@,toStr:%@",str,changeStr);
    }
    return changeStr;
}
+(NSString *)formatter4Sql:(NSString *)sql{
   return  [sql stringByReplacingOccurrencesOfString:@"\\s+" withString:@" " options:NSRegularExpressionSearch range:NSMakeRange(0, sql.length)];
}

@end
