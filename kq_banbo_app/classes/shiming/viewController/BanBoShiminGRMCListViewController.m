//
//  BanBoShiminGRMCItemListViewController.m
//  kq_banbo_app
//
//  Created by hcy on 2016/12/7.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoShiminGRMCListViewController.h"
#import "BanBoShiminListItem.h"
#import "BanBoShiminDetail.h"
#import "BanBoPersonInfoCollectViewController.h"
@interface BanBoShiminGRMCListViewController ()
@property(strong,nonatomic)UIButton *personBtn;
@property(strong,nonatomic)UIButton *healthBtn;
@property(strong,nonatomic)UIView *sectionSelectView;
@property(assign,nonatomic)BOOL needUpdate;
@end

@implementation BanBoShiminGRMCListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.sectionSelectView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.needUpdate) {
        [self refreshData:NO];
    }
}
-(CGRect)banbo_dataTableFrame{
    return CGRectMake(0, self.sectionSelectView.bottom, self.view.width, self.view.height-self.sectionSelectView.bottom);
}
-(UIView *)sectionSelectView{
    if (!_sectionSelectView) {
        UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, self.topView.bottom+10, self.view.width, [self grmcViewHeight])];
        headerView.backgroundColor=[UIColor whiteColor];
        
        UIButton *personBtn=[self grmcMakeBtnWithTitle:@"个人信息"];
        UIButton *healthBtn=[self grmcMakeBtnWithTitle:@"健康管理"];
        personBtn.left=20;
        healthBtn.left=personBtn.right+20;
        [headerView addSubview:personBtn];
        [personBtn setSelected:YES];
        [headerView addSubview:healthBtn];
        
        self.healthBtn=healthBtn;
        self.personBtn=personBtn;
        // Do any additional setup after loading the view.
        _sectionSelectView=headerView;
    }
    return _sectionSelectView;
}


-(void)grmcBtnClicked:(UIButton *)btn{
    if (btn==self.personBtn) {
        self.listItem.tag=BanBoShiminTypeGRMC;
        [self.personBtn setSelected:YES];
        [self.healthBtn setSelected:NO];
        self.columnHeader=[BanBoColumnHeaderMaker grmcHeader];
    }else{
        self.listItem.tag=BanBoShiminTypeJKGL;
        [self.healthBtn setSelected:YES];
        [self.personBtn setSelected:NO];
        self.columnHeader=[BanBoColumnHeaderMaker healthHeader];
    }
    [self.columnLayoutManager refreshHeader:self.columnHeader];
    
    [self refreshData:NO];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.listItem.tag==BanBoShiminTypeJKGL){
        BanboShiminUserCellObj *cellObj=(BanboShiminUserCellObj *)[self memberOfIndex:indexPath];
        BanBoShiminUser *user= cellObj.user;
        BanBoPersonInfoCollectViewController *healthCollectVC=[[BanBoPersonInfoCollectViewController alloc] initWithUser:user project:self.project];
        __weak typeof(self) wself=self;
        healthCollectVC.completion=^(BOOL needUpdate){
            if (wself) {
                wself.needUpdate=needUpdate;
            }
        };
        [self.navigationController pushViewController:healthCollectVC animated:YES];
    }
}

//-(BanBoColumnHeader *)healthHeader{
//    return [[self columnHeaderDict] objectForKey:@(BanBoShiminTypeJKGL)];
//
//}
//-(BanBoColumnHeader *)columnHeader{
//    if (self.healthBtn.selected==YES) {
//        return [self healthHeader];
//    }else{
//        return [super columnHeader];
//    }
//    
//}
//-(HCYColumnLayoutManager *)columnLayoutManager{
//    if ([self.healthBtn isSelected]) {
//        return self.healthColumnLayoutManager;
//    }else{
//        return [super columnLayoutManager];
//    }
//    
//}
#pragma mark other
-(UIButton *)grmcMakeBtnWithTitle:(NSString *)title{
    UIButton *btn=[BanBoBtnMaker sectionSelectBtnWithNormalTitle:title];
    btn.height=[self grmcViewHeight];
    [btn addTarget:self action:@selector(grmcBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
-(CGFloat)grmcViewHeight{
    return 30;
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
