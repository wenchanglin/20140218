//
//  EZCameraTableViewController.m
//  EZOpenSDKDemo
//
//  Created by DeJohn Dong on 16/9/20.
//  Copyright © 2016年 hikvision. All rights reserved.
//

#import "EZCameraTableViewController.h"
#import "EZLivePlayViewController.h"
#import "EZPlaybackViewController.h"
#import "EZCameraInfo.h"
#import "DDKit.h"

@interface EZCameraTableViewController ()

@property (nonatomic, strong) NSMutableArray *cameraList;
@property (nonatomic) NSInteger cameraIndex;

@end

@implementation EZCameraTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设备通道列表";
    if (!_cameraList) {
        _cameraList = [NSMutableArray new];
    }
    [_cameraList addObjectsFromArray:self.deviceInfo.cameraInfo];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_cameraList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EZCameraCell" forIndexPath:indexPath];
    
    EZCameraInfo *info = [_cameraList dd_objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",info.cameraName];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _cameraIndex = indexPath.row;
    if (_go2Type == 1) {
        [self performSegueWithIdentifier:@"go2Playback" sender:self.deviceInfo];
    } else {
        [self performSegueWithIdentifier:@"go2LivePlay" sender:self.deviceInfo];
    }
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    EZDeviceInfo *deviceInfo = sender;
    if ([[segue destinationViewController] isKindOfClass:[EZLivePlayViewController class]]) {
        ((EZLivePlayViewController *)[segue destinationViewController]).deviceInfo = deviceInfo;
        ((EZLivePlayViewController *)[segue destinationViewController]).cameraIndex = _cameraIndex;
    } else if ([[segue destinationViewController] isKindOfClass:[EZPlaybackViewController class]]) {
        ((EZPlaybackViewController *)[segue destinationViewController]).deviceInfo = deviceInfo;
        ((EZPlaybackViewController *)[segue destinationViewController]).cameraIndex = _cameraIndex;
    }
}

@end
