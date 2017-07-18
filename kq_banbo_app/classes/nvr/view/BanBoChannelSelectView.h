//
//  BanBoChannelSelectView.h
//  kq_banbo_app
//
//  Created by hcy on 2017/2/21.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "BanBoModelView.h"
@class BanBoChannelSelectView,HKChannel;
@protocol BanBoChannelSelectViewDelegate <NSObject>
-(void)channelSelectView:(BanBoChannelSelectView *)view selectChannel:(HKChannel *)channel;
@end


@interface BanBoChannelSelectView : BanBoModelView
-(void)setChannels:(NSArray *)channels;

/**
 设置内容view顶端

 @param top 顶端
 */
-(void)setChannelTop:(CGFloat)top;
@property(weak,nonatomic)id<BanBoChannelSelectViewDelegate> delegate;
@end
