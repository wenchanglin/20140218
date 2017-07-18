//
//  BanBoCellObj.m
//  kq_banbo_app
//
//  Created by hcy on 2016/12/7.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoCellObj.h"

@implementation BanBoCellObj
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellHeight=44.f;

    }
    return self;
}
-(NSString *)cellClass{
    return @"UITableViewCell";
}
-(id)sortKey{
    return @1;
}
-(NSString *)groupTitle{
    return @"";
}
-(NSString *)reuseId{
    return [self cellClass];
}
@end
@implementation BanBoColumnCellObj
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.customReuseId=@"";
    }
    return self;
}
-(NSString *)reuseId{
    if ([_customReuseId length]) {
        return [_customReuseId copy];
    }else{
        return [self cellClass];
    }
}
-(NSString *)titleAtIndex:(NSInteger)idx{
    return @"NotSet";
}
-(UIFont *)fontAtIndex:(NSInteger)idx{
    return [YZLabelFactory normalFont];
}

@end
