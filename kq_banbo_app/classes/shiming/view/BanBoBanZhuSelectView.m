//
//  BanBoBanZhuSelectView.m
//  kq_banbo_app
//
//  Created by hcy on 2016/12/5.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoBanZhuSelectView.h"
#import "BanBoShiMinManager.h"

@interface BanBoBanZhuSelectView()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)NSMutableArray *dataM;
@property(strong,nonatomic)UITableView *tableView;

@property(strong,nonatomic)BanBoBanzhuItem *banzhuItem;
@property(strong,nonatomic)BanBoBanzhuItem *defaultItem;


@end
@implementation BanBoBanZhuSelectView
+(instancetype)banZhuSelectView{
    BanBoBanZhuSelectView *selectView=[BanBoBanZhuSelectView new];
    
    return selectView;
}
+(instancetype)xiaoBanzhuSelectViewWithBanzhuItem:(BanBoBanzhuItem *)item{
    BanBoBanZhuSelectView *selectView=[BanBoBanZhuSelectView new];
    selectView.banzhuItem=item;
    return selectView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    frame.origin.y=0;
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
        self.enableTapBgToClose=YES;
    }
    return self;
}
@synthesize containerView=_containerView;
-(void)setupSubviews{
    UITableView *tableView=[[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    tableView.dataSource=self;
    tableView.delegate=self;
    [self addSubview:tableView];
    _tableView=tableView;
    _containerView=tableView;
}
-(void)closeGestureTaped:(UITapGestureRecognizer *)tap{
    if (self.completionBlock) {
        self.completionBlock(self.dataM[0],YES);
    }
    [super closeGestureTaped:tap];
    
}
-(void)showInView:(UIView *)containerView fromWhere:(NSString *)fromWhere dur:(NSTimeInterval)dur{
    [super showInView:containerView fromWhere:@"" dur:0.25];
}
-(void)showInView:(UIView *)view{
    __weak typeof(self) wself=self;
    
    self.defaultItem.groupname=@"正在请求数据请稍等";
    [self.tableView reloadData];
    if (self.banzhuItem) {
        BanboShiminRequestParam *param=[BanboShiminRequestParam new];
        param.banzhu=@(self.banzhuItem.groupid);
        [[BanBoShiMinManager sharedInstance] getXiaoBanzhuForBanzhuWithParam:param completion:^(id data, NSError *error) {
            if (!wself) {
                return;
            }
            dispatch_async_main_safe(^{
                if (error) {
                    [HCYUtil showError:error];
                }else{
                    [wself reloadTableView:data];
                }
            });
        }];
    }else{
        [[BanBoShiMinManager sharedInstance] getBanzhuWithCompletion:^(id data, NSError *error) {
            if (!wself) {
                return;
            }
            dispatch_async_main_safe(^{
                if (error) {
                    [HCYUtil showError:error];
                }else{
                    [wself reloadTableView:data];
                }
            });
        }];
    }
    [super showInView:view fromWhere:@"" dur:0.25];
}

-(void)reloadTableView:(NSArray *)data{
    self.tableView.userInteractionEnabled=NO;
    self.dataM=nil;
    if (data) {
        [self.dataM addObjectsFromArray:data];
    }
    [self.tableView reloadData];
    self.tableView.userInteractionEnabled=YES;
    [self setNeedsLayout];
}
#pragma mark tableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataM.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseId=@"eakdklasjdlka";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
        cell.textLabel.textColor=[UIColor hcy_colorWithString:@"#333333"];
        cell.textLabel.font=[YZLabelFactory normalFont];
    }
    BanBoBanzhuItem *item=self.dataM[indexPath.row];
    cell.textLabel.text=item.groupname;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self cellHeight];
}
#pragma mark tbvDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BanBoBanzhuItem *item= [self.dataM objectAtIndex:indexPath.row];
    if (self.completionBlock) {
        self.completionBlock(item,NO);
    }
}
#pragma mark layout
-(void)layoutSubviews{
    [super layoutSubviews];
    _tableView.width=self.width*.8;
    CGFloat tableViewHeight=self.dataM.count*[self cellHeight];
    CGFloat maxHeight=self.height;
    CGFloat yMargin=0;
    if (self.top==0) {
        maxHeight-=64;
#pragma mark - 这里设置班组选择蒙版控件
        yMargin=64; //最开始是64
    }
    if (self.dataM.count*[self cellHeight]>maxHeight) {
        tableViewHeight=ceil(floorf(maxHeight/[self cellHeight])-1)*[self cellHeight];
        _tableView.bounces=YES;
    }else{
        _tableView.bounces=NO;
    }
    _tableView.height=tableViewHeight;
    _tableView.centerX=self.width*.5;
    _tableView.centerY=maxHeight*.5+yMargin;
}

#pragma mark param
-(CGFloat)maxHeight{
    return self.height;
}
-(CGFloat)cellHeight{
    return 43.f;
}
-(NSMutableArray *)dataM{
    if (!_dataM) {
        NSMutableArray *itemArrM=[NSMutableArray array];
        
        BanBoBanzhuItem *item=[BanBoBanzhuItem new];
        item.groupname=@"请选择班组";
        item.gid=-1;
        self.defaultItem=item;
        [itemArrM addObject:item];
        
        _dataM=itemArrM;
    }
    return _dataM;
}

@end
