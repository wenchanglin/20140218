//
//  EZCameraTableViewController.h
//  EZOpenSDKDemo
//
//  Created by DeJohn Dong on 15/10/28.
//  Copyright © 2015年 hikvision. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BanBoProject;
@interface EZDeviceTableViewController : UITableViewController

@property (nonatomic) BOOL needRefresh;
@property(strong,nonatomic)BanBoProject *project;
@end
