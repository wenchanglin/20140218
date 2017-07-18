//
//  YZCacheManager.h
//  kq_banbo_app
//
//  Created by hcy on 2016/12/14.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,YZCacheType){
    YZCacheTypeMemory=1,
    YZCacheTypeDocumentVal,  //值-到documents
    YZCacheTypeDocumentFile, //文件-到documents
    YZCacheTypeTmpFile       //文件-到cache

};
extern NSString *const YZCacheKeyBanzhuItem;
extern NSString *const YZCacheKeyXiaoBanzhuItem;
extern NSString *const YZCacheKeyBanzhuItemInReport;
extern NSString *const YZCacheKeyXiaoBanzhuItemInReport;
extern NSString *const YZCacheKeyGongren;
@interface YZCacheManager : NSObject
+ (instancetype)sharedInstance;
-(void)addCache:(id)cache forKey:(NSString *)key type:(YZCacheType)type;
-(void)removeCacheForKey:(NSString *)key type:(YZCacheType)type;
-(id)cacheForKey:(NSString *)key type:(YZCacheType)type;

-(NSString *)cachePathForKey:(NSString *)key type:(YZCacheType)type;
@end
