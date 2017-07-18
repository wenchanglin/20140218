//
//  BanBoChannelSelectView.m
//  kq_banbo_app
//
//  Created by hcy on 2017/2/21.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "BanBoChannelSelectView.h"
#import "NVRSDKManager.h"
@interface BanBoChannelSelectView()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)NSArray *channels;
@property(assign,nonatomic)CGFloat channelTop;

@end
@implementation BanBoChannelSelectView
@synthesize containerView=_containerView;
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.enableTapBgToClose=YES;
        CGFloat width=SCREEN_WIDTH*.6;
        CGFloat height=width;
        
        CGFloat x=(SCREEN_WIDTH-width)*.5;
        CGFloat y=64;
        UITableView *tableView=[[UITableView alloc] initWithFrame:CGRectMake(x, y, width, height) style:UITableViewStylePlain];
        tableView.tableFooterView=[UIView new];
        
        tableView.dataSource=self;
        tableView.delegate=self;
        tableView.estimatedRowHeight=43.f;
        
        [self addSubview:tableView];
        _tableView=tableView;
        _containerView=tableView;

    }
    return self;
}

-(void)setChannelTop:(CGFloat)top{
    self.tableView.top=top;
    _channelTop=top;
    if (self.tableView.bottom>SCREEN_HEIGHT) {
        self.tableView.height=(SCREEN_HEIGHT*.6)-self.tableView.top;
    }
}
-(void)setChannels:(NSArray *)channels{
    _channels=channels;
    [self reload];
}
-(void)showInView:(UIView *)superView fromWhere:(NSString *)fromWhere dur:(NSTimeInterval)dur{
    [super showInView:superView fromWhere:fromWhere dur:dur];
    self.tableView.top=self.channelTop;
    
}
#pragma mark tableView
-(void)reload{
    dispatch_async_main_safe(^{
        self.tableView.userInteractionEnabled=NO;
        [self.tableView reloadData];
        self.tableView.userInteractionEnabled=YES;
    });
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.channels.count;
}
static int channelLabelTag=213;
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"11"];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"11"];
        UILabel *contentLabel=[YZLabelFactory blackLabel];
        contentLabel.textAlignment=NSTextAlignmentCenter;
        contentLabel.tag=channelLabelTag;
        [cell.contentView addSubview:contentLabel];
        contentLabel.frame=cell.contentView.bounds;
        contentLabel.autoresizingMask=63;
    }
    UILabel *contentLabel=[cell.contentView viewWithTag:channelLabelTag];
    if (contentLabel) {
        HKChannel *channel=self.channels[indexPath.row];
        contentLabel.text=channel.name;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([self.delegate respondsToSelector:@selector(channelSelectView:selectChannel:)]) {
        [self.delegate channelSelectView:self selectChannel:self.channels[indexPath.row]];
    }
}



#pragma mark super
-(CGFloat)bgLayerShowVal{
    return 0.4;
}
-(CGFloat)bgLayerHiddenVal{
    return 0;
}

@end
