//
//  YZListCell.m
//  YZWaimaiCustomer
//
//  Created by hcy on 16/8/17.
//  Copyright © 2016年 hcy@yz. All rights reserved.
//

#import "YZListCell.h"
NSString* const YZListCellEventNamePickerCellClicked=@"YZListCellEventNamePickerCellClicked";
NSString* const YZListCellEventNameClickOrderResInfo=@"YZListCellEventNameClickOrderResInfo";
NSString* const YZListCellEventNameOrderOperaBtnClicked=@"YZListCellEventNameOrderOperaBtnClicked";

@implementation YZListCell
-(void)refrehWithItem:(id<YZMemberProtocol>)item isLast:(BOOL)last userInfo:(NSDictionary *)userInfo{
    
}
-(void)list_sendEvents:(YZListCellEvent *)event{
    if([self.delegate respondsToSelector:@selector(list_onCatchEvent:)]){
        [self.delegate list_onCatchEvent:event];
    }
}
@end
@implementation YZListCellEvent


@end
