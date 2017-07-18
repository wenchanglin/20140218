//
//  BanBoShiminKGTJViewController.m
//  kq_banbo_app
//
//  Created by hcy on 2016/12/7.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoShiminKQTJViewController.h"
#import "BanBoImageHeaderView.h"
#import "BanBoProject.h"
#import "BanBoHomeTotal.h"
#import "BanBoShiminListItem.h"
#import "BanBoImageHeaderView.h"
@interface BanBoShiminKQTJViewController ()
@property(strong,nonatomic)BanBoImageHeaderView *imageHeaderView;
@end

@implementation BanBoShiminKQTJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customTabbar.hidden=YES;
    self.logoutBtn.hidden=YES;
    self.dataTableView.tableHeaderView=nil;
    
    self.imageHeaderView.text=[self headerTitle];
}
-(NSString *)headerTitle{
    NSString *str=[NSString stringWithFormat:@"%@%@",self.project.name,self.item.title];
    return str;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark fatherClass
-(void)refreshColorLabel:(BanBoProjectTotal *)data{
    
    [super refreshColorLabel:data];
    self.imageHeaderView.text=[NSString stringWithFormat:@"%@(%ld)",[self headerTitle],(long)data.TotalWorker];
}
-(UIColor *)bgColorForCellAtIndexPath:(NSIndexPath *)path{
    if (path.row==0) {
        return BanBoShiminYellowColor;
    }else{
        return  [super bgColorForCellAtIndexPath:path];
    }
}
@synthesize topView=_topView;
-(UIView *)topView{
    if (!_topView) {	
        UIView *topView=[super topView];
        BanBoImageHeaderView *header=[BanBoImageHeaderView new];
        _imageHeaderView=header;
        
        UIView *view=[[UIView alloc] initWithFrame:topView.frame];
        view.height+=header.height;
        [view addSubview:header];
        [view addSubview:topView];
        topView.top=header.bottom;
        view.backgroundColor=[UIColor clearColor];
        _topView=view;
    }
    return _topView;
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
