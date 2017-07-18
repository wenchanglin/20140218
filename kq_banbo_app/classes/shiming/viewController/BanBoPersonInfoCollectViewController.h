//
//  BanBoPersonInfoCollectViewController.h
//  kq_banbo_app
//
//  Created by hcy on 2016/12/8.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoColumnListViewController.h"
@class BanBoShiminUser,BanBoProject;
typedef void(^PersonInfoCollectionViewCompletion)(BOOL needUpdate);
/**
 个人信息采集
 */
@interface BanBoPersonInfoCollectViewController : BanBoColumnListViewController

/**
 因为用户可能多次更新信息。但是如果多次让外面去刷新比较废。因为那会是看不到的。所以只要更新了。当用户回退到上个页面的时候去刷新就可以了
 */
@property(copy,nonatomic)PersonInfoCollectionViewCompletion completion;
/**
 初始化方法

 @param user 用户
 @return 对象
 */
-(instancetype)initWithUser:(BanBoShiminUser *)user project:(BanBoProject *)project;
@end
