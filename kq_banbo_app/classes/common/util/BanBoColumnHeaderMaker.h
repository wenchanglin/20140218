//
//  BanBoColumnHeaderMaker.h
//  kq_banbo_app
//
//  Created by hcy on 2017/1/16.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BanBoColumnHeader;
@interface BanBoColumnHeaderMaker : UIView
+(BanBoColumnHeader *)gzlbHeader;
+(BanBoColumnHeader *)grmcHeader;
+(BanBoColumnHeader *)xxglHeader;
+(BanBoColumnHeader *)kqglHeader;
+(BanBoColumnHeader *)yhkhHeader;
//+(BanBoColumnHeader *)kqtjHeader;
+(BanBoColumnHeader *)healthHeader;
+(BanBoColumnHeader *)VRXQYeHeader;
/**
 报道界面

 @return header
 */
+(BanBoColumnHeader *)personalHeader;

@end
