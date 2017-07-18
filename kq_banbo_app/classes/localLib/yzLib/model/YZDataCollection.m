//
//  YZDataCollection.m
//  NIM
//
//  Created by Xuhui on 15/3/2.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "YZDataCollection.h"

@interface YZPair : NSObject

@property (nonatomic, strong) id first;
@property (nonatomic, strong) id second;

@end

@implementation YZPair

- (instancetype)initWithFirst:(id)first second:(id)second {
    self = [super init];
    if(self) {
        _first = first;
        _second = second;
    }
    return self;
}

@end

@interface YZDataCollection () {
    NSMutableOrderedSet *_aboveGroupTitles;
    NSMutableOrderedSet *_aboveGroups;
    NSMutableOrderedSet *_groupTtiles;
    NSMutableOrderedSet *_groups;
    NSMutableOrderedSet *_belowGroupTitles;
    NSMutableOrderedSet *_belowGroups;
}

@end

@implementation YZDataCollection

- (instancetype)init
{
    self = [super init];
    if(self) {
        _aboveGroupTitles = [[NSMutableOrderedSet alloc] init];
        _aboveGroups = [[NSMutableOrderedSet alloc] init];
        _groupTtiles = [[NSMutableOrderedSet alloc] init];
        _groups = [[NSMutableOrderedSet alloc] init];
        _belowGroupTitles=[[NSMutableOrderedSet alloc] init];
        _belowGroups=[[NSMutableOrderedSet alloc] init];
    }
    return self;
}

- (NSArray *)sortedGroupTitles
{
    return [_groupTtiles array];
}

- (void)setMembers:(NSArray *)members
{
    _members=members;
    NSMutableDictionary *tmp = [NSMutableDictionary dictionary];
    for (id<YZMemberProtocol>member in members) {
        NSString *groupTitle = [member groupTitle];
     
        NSMutableArray *groupedMembers = [tmp objectForKey:groupTitle];
        if(!groupedMembers) {
            groupedMembers = [NSMutableArray array];
        }
        [groupedMembers addObject:member];
        [tmp setObject:groupedMembers forKey:groupTitle];
    }
    [_groupTtiles removeAllObjects];
    [_groups removeAllObjects];
    [tmp enumerateKeysAndObjectsUsingBlock:^(NSString *groupTitle, NSMutableArray *groupedMembers, BOOL *stop) {
        [_groupTtiles addObject:groupTitle];
        [_groups addObject:[[YZPair alloc] initWithFirst:groupTitle second:groupedMembers]];
    }];
    [self sort];
}

- (void)addGroupMember:(id<YZMemberProtocol>)member
{
    NSString *groupTitle = [member groupTitle];
    NSInteger groupIndex = [_groupTtiles indexOfObject:groupTitle];
    YZPair *pair = [_groups objectAtIndex:groupIndex];
    if(!pair) {
        NSMutableArray *members = [NSMutableArray array];
        pair = [[YZPair alloc] initWithFirst:groupTitle second:members];
    }
    NSMutableArray *members = pair.second;
    [members addObject:member];
    [_groupTtiles addObject:groupTitle];
    [_groups addObject:pair];
    [self sort];
}

- (void)addGroupAboveWithTitle:(NSString *)title members:(NSArray *)members {
    YZPair *pair = [[YZPair alloc] initWithFirst:title second:members];
    [_aboveGroupTitles addObject:title];
    [_aboveGroups addObject:pair];
}
-(void)addGroupBelowWithTitle:(NSString *)title members:(NSArray *)members{
    YZPair *pair=[[YZPair alloc] initWithFirst:title second:members];
    [_belowGroupTitles addObject:title];
    [_belowGroups addObject:pair];
}
- (NSString *)titleOfGroup:(NSInteger)groupIndex
{
    if(groupIndex >= 0 && groupIndex < _aboveGroupTitles.count) {
        return [_aboveGroupTitles objectAtIndex:groupIndex];
    }
    groupIndex -= _aboveGroupTitles.count;
    if (groupIndex>=0) {
        if (groupIndex<_groupTtiles.count) {
            return [_groupTtiles objectAtIndex:groupIndex];
        }else{
            groupIndex-=_groupTtiles.count;
            if (groupIndex>=0 && groupIndex<_belowGroupTitles.count) {
                return _belowGroupTitles[groupIndex];
            }
        }
    }
    return nil;
}

- (NSArray *)membersOfGroup:(NSInteger)groupIndex
{
    return [self pairAtIndex:groupIndex].second;
}

- (id<YZMemberProtocol>)memberOfIndex:(NSIndexPath *)indexPath
{
    NSArray *members = nil;
    NSInteger groupIndex = indexPath.section;
    
    YZPair *pair=[self pairAtIndex:groupIndex];
    members=pair.second;
    
    NSInteger memberIndex = indexPath.row;
    if(memberIndex < 0 || memberIndex >= members.count) return nil;
    return [members objectAtIndex:memberIndex];
}
-(YZPair *)pairAtIndex:(NSInteger)idx{
    if (idx>=0 && idx<_aboveGroups.count) {
        return _aboveGroups[idx];
    }
    idx-=_aboveGroups.count;
    if (idx>=0) {
        if (idx<_groups.count) {
            return _groups[idx];
        }else{
            idx-=_groups.count;
            if (idx>=0 && idx<_belowGroups.count) {
                return _belowGroups[idx];
            }
        }
    }
    return nil;
}
- (NSInteger)groupCount
{
    return _aboveGroupTitles.count + _groupTtiles.count+_belowGroupTitles.count;
}

- (NSInteger)memberCountOfGroup:(NSInteger)groupIndex
{
    YZPair *pair=[self pairAtIndex:groupIndex];
    NSArray* members=pair.second;
    return members.count;
}

- (void)sort
{
    [self sortGroupTitle];
    [self sortGroupMember];
}

- (void)sortGroupTitle
{
    [_groupTtiles sortUsingComparator:_groupTitleComparator];
    [_groups sortUsingComparator:^NSComparisonResult(YZPair *pair1, YZPair *pair2) {
        return _groupTitleComparator(pair1.first, pair2.first);
    }];
}

- (void)sortGroupMember
{
    if (!_groupMemberComparator) {
        return;
    }
    [_groups enumerateObjectsUsingBlock:^(YZPair *obj, NSUInteger idx, BOOL *stop) {
        NSMutableArray *groupedMembers = obj.second;
        [groupedMembers sortUsingComparator:^NSComparisonResult(id<YZMemberProtocol> member1, id<YZMemberProtocol> member2) {
            return _groupMemberComparator([member1 sortKey], [member2 sortKey]);
        }];
    }];
}

- (void)setGroupTitleComparator:(NSComparator)groupTitleComparator
{
    _groupTitleComparator = groupTitleComparator;
    [self sortGroupTitle];
}

- (void)setGroupMemberComparator:(NSComparator)groupMemberComparator
{
    _groupMemberComparator = groupMemberComparator;
    [self sortGroupMember];
}
-(NSComparator)sameGroupTitleCompartor{
    return ^NSComparisonResult(NSString* obj1,NSString* obj2){
        return NSOrderedSame;
    };
}
@end
@implementation YZCell

-(void)refrehWithItem:(id<YZMemberProtocol>)item isLast:(BOOL)last userInfo:(NSDictionary *)userInfo{
    
}

@end
