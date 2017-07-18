//
//  TeamDataCollection.h
//  NIM
//
//  Created by Xuhui on 15/3/2.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol YZMemberProtocol <NSObject>
@required
- (NSString *)groupTitle;//组头
- (id)sortKey;//排序

@end

@interface YZDataCollection : NSObject

@property (nonatomic, strong) NSArray *members;
@property (nonatomic, copy) NSComparator groupTitleComparator;
@property (nonatomic, copy) NSComparator groupMemberComparator;
@property (nonatomic, readonly) NSArray *sortedGroupTitles;

- (void)addGroupMember:(id<YZMemberProtocol>)member;

- (void)addGroupAboveWithTitle:(NSString *)title members:(NSArray *)members;

- (void)addGroupBelowWithTitle:(NSString *)title members:(NSArray *)members;

- (NSString *)titleOfGroup:(NSInteger)groupIndex;

- (NSArray *)membersOfGroup:(NSInteger)groupIndex;

- (id<YZMemberProtocol>)memberOfIndex:(NSIndexPath *)indexPath;

- (NSInteger)groupCount;

- (NSInteger)memberCountOfGroup:(NSInteger)groupIndex;

-(NSArray *)sortedGroupTitles;

-(NSComparator)sameGroupTitleCompartor;
@end
@interface YZCell : UITableViewCell
-(void)refrehWithItem:(id<YZMemberProtocol>)item isLast:(BOOL)last userInfo:(NSDictionary *)userInfo;
@end
