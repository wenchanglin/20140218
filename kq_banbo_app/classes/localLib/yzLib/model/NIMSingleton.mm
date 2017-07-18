//
//  YXManager.m
//  yixin_iphone
//
//  Created by amao on 11/13/13.
//  Copyright (c) 2013 Netease. All rights reserved.
//

#import "NIMSingleton.h"

#pragma mark - NIMSingletonManagerImpl
@interface NIMSingletonManagerImpl : NSObject
@property (nonatomic,strong)    NSString                *key;
@property (nonatomic,strong)    NSMutableDictionary     *singletons;
@end


@implementation NIMSingletonManagerImpl

+ (NIMSingletonManagerImpl *)coreImpl:(NSString *)key
{
    NIMSingletonManagerImpl *impl = [[NIMSingletonManagerImpl alloc]init];
    impl.key = key;
    return impl;
}

- (id)init
{
    if (self = [super init])
    {
        _singletons = [[NSMutableDictionary alloc]init];
    }
    return self;
}



- (instancetype)singletonByClass:(Class)singletonClass
{
    NSString *singletonClassName = NSStringFromClass(singletonClass);
    id singleton = [_singletons objectForKey:singletonClassName];
    if (!singleton) {
        singleton = [[singletonClass alloc]init];
        [_singletons setObject:singleton forKey:singletonClassName];
    }
    return singleton;
}

- (void)callSingletonSelector: (SEL)selecotr
{
    NSArray *array = [_singletons allValues];
    for (id obj in array)
    {
        if ([obj respondsToSelector:selecotr])
        {
            [obj performSelector:selecotr];
        }
    }
}

@end

#pragma mark - NIMSingletonManager()
@interface NIMSingletonManager ()
@property (nonatomic,strong)    NSRecursiveLock *lock;
@property (nonatomic,strong)    NIMSingletonManagerImpl *core;
+ (instancetype)sharedManager;
- (id)singletonByClass:(Class)singletonClass;
@end

#pragma mark - NIMSingleton
@implementation NIMSingleton
+ (instancetype)sharedInstance
{
    return [[NIMSingletonManager sharedManager] singletonByClass:[self class]];
}

- (void)start
{
    DDLogDebug(@"NIMSingletonManager %@ Started", self);
}
@end

#pragma mark - NIMSingletonManager
@implementation NIMSingletonManager

+ (instancetype)sharedManager
{
    static NIMSingletonManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NIMSingletonManager alloc]init];
    });
    return instance;
}

- (id)init
{
    if (self = [super init]) {
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)createSingletonManager {
    [_lock lock];
    NSString *key = @"ss";
    _core = [NIMSingletonManagerImpl coreImpl:key];
    [_lock unlock];
}

- (void)destroySingletonManager {
    [_lock lock];
    [self callSingletonClean];
    _core = nil;
    [_lock unlock];
}

- (id)singletonByClass: (Class)singletonClass
{
    id instance = nil;
    [_lock lock];
    instance = [_core singletonByClass:singletonClass];
    [_lock unlock];
    return instance;
}

#pragma mark - Call Functions
- (void)callSingletonClean
{
    [self callSelector:@selector(onCleanData)];
}


- (void)callReceiveMemoryWarning
{
    [self callSelector:@selector(onReceiveMemoryWarning)];
}


- (void)callEnterBackground
{
    [self callSelector:@selector(onEnterBackground)];
}

- (void)callEnterForeground
{
    [self callSelector:@selector(onEnterForeground)];
}

- (void)callAppWillTerminate
{
    [self callSelector:@selector(onAppWillTerminate)];
}

- (void)callSelector: (SEL)selector
{
    [_core callSingletonSelector:selector];
}


@end
