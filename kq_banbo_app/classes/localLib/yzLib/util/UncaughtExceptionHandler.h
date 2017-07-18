//
//  UncaughtExceptionHandler.h
//  NIM
//
//  Created by hcy on 16/3/7.
//  Copyright © 2016年 YzChina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UncaughtExceptionHandler : NSObject{
    BOOL dismissed;
}

@end
void HandleException(NSException *exception);
void SignalHandler(int signal);
void InstallUncaughtExceptionHandler(void);


