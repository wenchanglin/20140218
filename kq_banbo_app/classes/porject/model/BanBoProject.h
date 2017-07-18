//
//  BanBoProject.h
//  kq_banbo_app
//
//  Created by hcy on 2016/12/5.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 因为不想用homeDetai里那个对象
 */
@interface BanBoProject : NSObject
@property(strong,nonatomic)NSNumber *projectId;
@property(copy,nonatomic)NSString *name;
@end
