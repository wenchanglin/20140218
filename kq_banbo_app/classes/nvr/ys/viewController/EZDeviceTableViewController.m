//
//  EZCameraTableViewController.m
//  EZOpenSDKDemo
//
//  Created by DeJohn Dong on 15/10/28.
//  Copyright © 2015年 hikvision. All rights reserved.
//

#import "EZDeviceTableViewController.h"

#import "EZAccessToken.h"
#import "MJRefresh.h"
#import "DeviceListCell.h"
#import "DDKit.h"
#import "EZLivePlayViewController.h"
#import "EZPlaybackViewController.h"
#import "EZMessageListViewController.h"
#import "EZSettingViewController.h"
#import "EZCameraTableViewController.h"
#import "EZAreaInfo.h"
#import "EZUserInfo.h"
#import "EZCameraInfo.h"
#import "BanBoNVRManager.h"
#import "BanBoProject.h"
#define EZDeviceListPageSize 30

@interface EZDeviceTableViewController ()

@property (nonatomic, strong) NSMutableArray *deviceList;
@property (nonatomic) NSInteger currentPageIndex;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *addButton;
//@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;
//@property (nonatomic) BOOL isSharedDevice; //是否是分享设备的segmented档选中
@property(nonatomic,strong)NSMutableArray * shebeiNum;
@property(nonatomic,strong)NSMutableArray * shebeiChannel;
@property(nonatomic,strong)NSMutableArray * deviceArr;
@property (nonatomic) NSInteger go2Type;

@end

@implementation EZDeviceTableViewController
- (instancetype)init
{
    static UIStoryboard *ezStoryBorad;
    if(!ezStoryBorad){
        ezStoryBorad=[UIStoryboard storyboardWithName:@"EZMain" bundle:nil];
    }
    if (ezStoryBorad) {
        DDLogDebug(@"load EZDeviceTableViewControll from sb");
        return [ezStoryBorad instantiateInitialViewController];
    }else{
        DDLogDebug(@"load EZDeviceTableViewControll as new Obj");
        self = [super init];
        if (self) {
            
        }
        return self;
    }
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"监控";
    _deviceArr = [NSMutableArray array];
    _shebeiChannel = [NSMutableArray array];
    [HCYUtil showProgressWithStr:@"获取信息"];
    _deviceList = [NSMutableArray array];
    _shebeiNum = [NSMutableArray array];
    __weak typeof(self) wself=self;
    NSLog(@"%zd",self.project.projectId);
     [self getSerinalNum];
    [[BanBoNVRManager sharedInstance] getYSNVRInfoWithProject:self.project.projectId completion:^(NSString* token, NSError *error) {
        if (!wself) {
            return ;
        }
        dispatch_async_main_safe(^{
            [HCYUtil dismissProgress];
            if (error) {
                [HCYUtil showError:error];
            }else{
                if (!token.length) {
                    [HCYUtil showErrorWithStr:@"没有token"];
                }else{
                    [[GlobalKit shareKit] setAccessToken:token];
                    [EZOPENSDK setAccessToken:[GlobalKit shareKit].accessToken];
                    [wself addRefreshKit];
                }
            }
        });
    }];
}
-(void)getSerinalNum
{
    [[BanBoNVRManager sharedInstance] getYSSerialNumbWithProject:self.project.projectId completion:^(id data, NSError *error) {
        for (NSDictionary * dict in data) {
            [_shebeiNum addObject:dict[@"SerialNum"]];
            [_shebeiChannel addObject:dict[@"ChannelList"]];
        }
    }];
}
- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    if (_needRefresh)
    {
        _needRefresh = NO;
        [self.tableView.header beginRefreshing];
    }
    [self.tableView reloadData];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    EZDeviceInfo *deviceInfo = sender;
    if ([[segue destinationViewController] isKindOfClass:[EZLivePlayViewController class]]) {
        ((EZLivePlayViewController *)[segue destinationViewController]).deviceInfo = deviceInfo;
    } else if ([[segue destinationViewController] isKindOfClass:[EZPlaybackViewController class]]) {
        ((EZPlaybackViewController *)[segue destinationViewController]).deviceInfo = deviceInfo;
    } else if ([[segue destinationViewController] isKindOfClass:[EZMessageListViewController class]]) {
        ((EZMessageListViewController *)[segue destinationViewController]).deviceInfo = deviceInfo;
    } else if ([[segue destinationViewController] isKindOfClass:[EZSettingViewController class]]) {
        ((EZSettingViewController *)[segue destinationViewController]).deviceInfo = deviceInfo;
    } else if ([[segue destinationViewController] isKindOfClass:[EZCameraTableViewController class]]) {
        ((EZCameraTableViewController *)[segue destinationViewController]).deviceInfo = deviceInfo;
        ((EZCameraTableViewController *)[segue destinationViewController]).channelList = _shebeiChannel;
        ((EZCameraTableViewController *)[segue destinationViewController]).go2Type = _go2Type;
    }
}

//- (IBAction)segmentControl:(id)sender {
//    _isSharedDevice = NO;
//    if (self.segmentedControl.selectedSegmentIndex == 1)
//    {
//        _isSharedDevice = YES;
//    }
//    [self addRefreshKit];
//}

#pragma mark - Custom Methods

- (void)addRefreshKit
{
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.currentPageIndex = 0;
        //获取设备列表接口
        [EZOPENSDK getDeviceList:weakSelf.currentPageIndex++
                        pageSize:EZDeviceListPageSize
                      completion:^(NSArray *deviceList, NSInteger totalCount, NSError *error) {
//                           DDLogDebug(@"refreshEnd:%@.totoalCount:%ld,error：%@",deviceList,totalCount,error);
                          EZCameraInfo * dise;
                          if (_deviceList.count>0) {
                              [weakSelf.deviceList removeAllObjects];
                          }
                          for (dise in deviceList) {
                              for (int i=0; i<_shebeiNum.count; i++) {
                                  if(_shebeiNum[i] == dise.deviceSerial)
                                  {
                                      [weakSelf.deviceList addObject:dise];
                                  }
                              }
                          }
                          [weakSelf.tableView reloadData];
                          [weakSelf.tableView.mj_header endRefreshing];
                          if (weakSelf.deviceList.count == totalCount)
                          {
                              [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                          }
                          else
                          {
                              [weakSelf addFooter];
                          }
                      }];
        
    }];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)addFooter {
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_footer  = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.currentPageIndex = 0;
        //获取设备列表接口
        [EZOPENSDK getDeviceList:weakSelf.currentPageIndex++  pageSize:EZDeviceListPageSize
                      completion:^(NSArray *deviceList, NSInteger totalCount, NSError *error) {
                          //[weakSelf.deviceList addObjectsFromArray:deviceList];
                          EZCameraInfo * dise;
                          if (_deviceList.count>0) {
                              [weakSelf.deviceList removeAllObjects];
                          }
                          for (dise in deviceList) {
                              for (int i=0; i<_shebeiNum.count; i++) {
                                  if(_shebeiNum[i] == dise.deviceSerial)
                                  {
                                      [weakSelf.deviceList addObject:dise];
                                  }
                              }
                          }
                          [weakSelf.tableView reloadData];
                          [weakSelf.tableView.mj_footer endRefreshing];
                          if (weakSelf.deviceList.count == totalCount)
                          {
                              [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                          }
                      }];
    }];
}

//- (IBAction)go2AddDevice:(id)sender {
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//        UIStoryboard *addDeviceStoryBoard = [UIStoryboard storyboardWithName:@"AddDevice" bundle:nil];
//        UIViewController *rootViewController = [addDeviceStoryBoard instantiateViewControllerWithIdentifier:@"AddByQRCode"];
//        UIBarButtonItem *returnButton = [[UIBarButtonItem alloc] init];
//        returnButton.title = @"";
//        self.navigationItem.backBarButtonItem = returnButton;
//        [self.navigationController pushViewController:rootViewController animated:YES];
//    } else {
//        [UIView dd_showMessage:@"iOS 7.0以下扫码功能请自行实现"];
//    }
//}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_deviceList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeviceListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EZDeviceCell" forIndexPath:indexPath];
    EZDeviceInfo *info = _deviceList[indexPath.row];//[_deviceList dd_objectAtIndex:indexPath.row];
    
    //    cell.isShared = _isSharedDevice;
    [cell setDeviceInfo:info];
    cell.parentViewController = self;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 73.0 * [UIScreen mainScreen].bounds.size.width/320.0f;
}

- (void)go2Play:(EZDeviceInfo *)deviceInfo {
    _go2Type = 0;
    if (deviceInfo.cameraNum == 1) {
        [self performSegueWithIdentifier:@"go2LivePlay" sender:deviceInfo];
    } else if(deviceInfo.cameraNum > 1) {
        [self performSegueWithIdentifier:@"go2CameraList" sender:deviceInfo];
    }
}

- (void)go2Record:(EZDeviceInfo *)deviceInfo
{
    _go2Type = 1;
    if (deviceInfo.cameraNum == 1) {
        [self performSegueWithIdentifier:@"go2Playback" sender:deviceInfo];
    } else if(deviceInfo.cameraNum > 1) {
        [self performSegueWithIdentifier:@"go2CameraList" sender:deviceInfo];
    }
}

//- (void)go2Setting:(EZDeviceInfo *)deviceInfo
//{
//    [self performSegueWithIdentifier:@"go2Setting" sender:deviceInfo];
//}

//- (void)go2Message:(EZDeviceInfo *)deviceInfo
//{
//    [self performSegueWithIdentifier:@"go2MessageList" sender:deviceInfo];
//}

@end
