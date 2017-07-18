//
//  YZCacheManager.m
//  kq_banbo_app
//
//  Created by hcy on 2016/12/14.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "YZCacheManager.h"
NSString *const YZCacheKeyBanzhuItem=@"YZCacheKeyBanzhuItem";
NSString *const YZCacheKeyXiaoBanzhuItem=@"YZCacheKeyXiaoBanzhuItem";
NSString *const YZCacheKeyGongren=@"YZCacheKeyGongren";
NSString *const YZCacheKeyBanzhuItemInReport=@"YZCacheKeyBanzhuItemInReport";
NSString *const YZCacheKeyXiaoBanzhuItemInReport=@"YZCacheKeyXiaoBanzhuItemInReport";
@interface YZCacheManager()
@property(strong,nonatomic)NSMutableDictionary *memoryCacheDict;
@property(strong,nonatomic)NSUserDefaults *defaults;
@property(copy,nonatomic)NSString *documentFilePathDir;
@property(copy,nonatomic)NSString *tmpFilePathDir;

@property(strong,nonatomic)NSFileManager *fileManager;
@end
@implementation YZCacheManager
static YZCacheManager *cacheManager;
+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cacheManager=[YZCacheManager new];
    });
    return cacheManager;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.memoryCacheDict=[NSMutableDictionary dictionary];
        self.defaults=[NSUserDefaults standardUserDefaults];
        self.fileManager=[NSFileManager defaultManager];
    }
    return self;
}
#pragma mark func
-(void)addCache:(id)cache forKey:(NSString *)key type:(YZCacheType)type{
    if (key && cache) {
        switch (type) {
            case YZCacheTypeMemory:
            {
                [self.memoryCacheDict setObject:cache forKey:key];
            }
                break;
            case YZCacheTypeDocumentVal:
            {
                [_defaults setObject:cache forKey:key];
                [_defaults synchronize];
            }
            case YZCacheTypeDocumentFile:
            case YZCacheTypeTmpFile:
            {
                if ([cache respondsToSelector:@selector(writeToFile:options:error:)]) {
                    NSError *writeError=nil;
                    NSString *cachePath=[self cachePathForKey:key type:type];
                    [cache  writeToFile:cachePath options:0 error:&writeError];
                    if (writeError) {
                        DDLogError(@"saveFileError:%@ key:%@",cachePath,key);
                    }
                }
            }
                break;

            default:
                break;
        }
    }
}
-(void)removeCacheForKey:(NSString *)key type:(YZCacheType)type{
    if (key) {
        switch (type) {
            case YZCacheTypeMemory:
            {
                [self.memoryCacheDict removeObjectForKey:key];
            }
                break;
            case YZCacheTypeDocumentVal:
            {
                [_defaults removeObjectForKey:key];
                [_defaults synchronize];
            }
            case YZCacheTypeDocumentFile:
            {
                NSString *cachePath=[self cachePathForKey:key type:YZCacheTypeDocumentFile];
                [self.fileManager removeItemAtPath:cachePath error:nil];
            }
                break;
            default:
                break;
        }
    }
}
-(id)cacheForKey:(NSString *)key type:(YZCacheType)type{
    if (key) {
        switch (type) {
            case YZCacheTypeMemory:
            {
                return self.memoryCacheDict[key];
            }
                break;
            case YZCacheTypeDocumentVal:
            {
                return [_defaults objectForKey:key];
            }
                break;
            case YZCacheTypeDocumentFile:
            {
                NSString *cachePath=[self cachePathForKey:key type:YZCacheTypeDocumentFile];
                if ([self.fileManager fileExistsAtPath:cachePath]) {
                    return [NSData dataWithContentsOfFile:cachePath];
                }else{
                    return nil;
                }
            }
            default:
                break;
        }
    }
    return nil;
    
}
#pragma mark private
-(NSString *)cachePathForKey:(NSString *)key type:(YZCacheType)type{
    NSString *subDir=@"";
    switch (type) {
        case YZCacheTypeDocumentFile:
        {
            subDir=[self.documentFilePathDir stringByAppendingPathComponent:@"documentFile"];
        }
            break;
        case YZCacheTypeTmpFile:
        {
            subDir=self.tmpFilePathDir;
        }
            break;
        default:
            break;
    }
    
    if([[NSFileManager defaultManager] fileExistsAtPath:subDir]==NO){
        [[NSFileManager defaultManager] createDirectoryAtPath:subDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *fileName=[NSString stringWithFormat:@"%@",key];
    return [subDir stringByAppendingPathComponent:fileName];
}

-(NSString *)documentFilePathDir{
    if (!_documentFilePathDir) {
        NSArray *path= NSSearchPathForDirectoriesInDomains(9, 1, 1);
        if (path.count) {
            NSString *documentDir= [path lastObject];
            _documentFilePathDir=[documentDir stringByAppendingPathComponent:@"fileCache"];
        }else{
            DDLogError(@"can't find app Document file cache invalid");
        }
    }
    return [_documentFilePathDir copy];
}
-(NSString *)tmpFilePathDir{
    if (!_tmpFilePathDir) {
        NSArray *path=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, 1, 1);
        if (path.count) {
            _tmpFilePathDir=[[path lastObject] copy];
        }else{
            DDLogError(@"can't find app Cache file cache invalid");
        }
    }
    return _tmpFilePathDir;
}
-(void)dealloc{
    self.memoryCacheDict=nil;
}
@end
