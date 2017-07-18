//
//  BanBoDailyPhotoCollectViewController.m
//  kq_banbo_app
//
//  Created by hcy on 2016/12/9.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoDailyPhotoCollectViewController.h"
#import "BanBoShiminGRMCListViewController.h"
#import "YZHttpService.h"
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>
#import "BanBoHealthFourBtnView.h"
@interface BanBoDailyPhotoCollectViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,BanBoHealthFourBtnsViewDelegate>
@property(strong,nonatomic)BanBoHealthImageViewSecond *iconView;
@property(strong,nonatomic)UIImage * lifeImage;
@property(strong,nonatomic)UIImageView * imageV;
@end

@implementation BanBoDailyPhotoCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self healthSetTitle:@"生活照拍照"];
    [self setupSubviews];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(createImg) name:@"获取成功" object:nil];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
 
    
}

-(void)createImg
{
    
    _imageV.image = self.lifeImage;
}
-(void)setupSubviews{
    if (!self.isViewMode) {
        CGFloat iconViewWidth=self.view.width*.7;
        CGRect iconRect=CGRectMake(0, 23,iconViewWidth, iconViewWidth*1.2);
        BanBoHealthImageViewSecond *iconView=[self healthImageViewV2:iconRect bgImage:[HCYUtil createImageWithColor:[UIColor hcy_colorWithRed:207 green:208 blue:209 alpha:1] size:iconRect.size] centerImage:[UIImage imageNamed:@"生活照拍照图标"] centerText:@"点击上传生活照"];
        iconView.centerX=self.view.width*.5;
        
        [self.healthContentView addSubview:iconView];
        self.iconView=iconView;
        
        iconView.userInteractionEnabled=YES;
        UITapGestureRecognizer *iconTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePhotoBtnClick:)];
        [self.iconView addGestureRecognizer:iconTap];
        //btns 取消 保存
        BanBoHealthFourBtnView *btnView=[BanBoHealthFourBtnView new];
        
        CGFloat btnLineMargin=10;
        CGFloat btnMargin=20;
        CGFloat btnHeigt=40;
        CGFloat btnWidth=130;
        
        CGFloat btnViewWidth=btnWidth*2+btnMargin;
        CGFloat btnViewHeight=btnHeigt*2+btnLineMargin;
        
        btnView.delegate=self;
        [btnView setBackgroundColor:[UIColor clearColor]];
        btnView.itemMargin=btnMargin;
        btnView.lineMargin=btnLineMargin;
        [btnView setBtnViewSize:CGSizeMake(btnViewWidth, btnViewHeight)];
        [btnView setTitles:@[@"取消",@"保存",@"",@""]];
        [btnView setBgColorArr:@[BanBoHealthBtnGrayColor,BanBoHealthRedColor,BanBoViewBgGrayColor,BanBoViewBgGrayColor]];
        [btnView setTitleColors:@[BanBoHealthCancelBtnTitleColor,[UIColor whiteColor],BanBoHealthCancelBtnTitleColor,[UIColor whiteColor]] forState:UIControlStateNormal];
        
        btnView.centerY=(iconView.bottom+(self.healthContentView.height-iconView.bottom)*.5);
        btnView.centerX=self.view.width*.5;
        
        [self.healthContentView addSubview:btnView];
    }
  else
  {
      [HCYUtil showProgressWithStr:@"图片下载中"];
      [[BanBoHealthManager sharedInstance]getLifePic:Inter_GetLifePic forUser:self.user.CardId completion:^(id data, NSError *error) {
          self.lifeImage = [UIImage imageWithData:data];
          DDLogInfo(@"生活照：%@",self.lifeImage);
          [HCYUtil dismissProgress];
          [[NSNotificationCenter defaultCenter]postNotificationName:@"获取成功" object:nil];
      }];
      CGFloat iconViewWidth=self.view.width*.7;
      CGRect iconRect=CGRectMake(([UIScreen mainScreen].bounds.size.width-iconViewWidth)/2, 23,iconViewWidth, iconViewWidth*1.2);
      _imageV = [[UIImageView alloc]initWithFrame:iconRect];
      [self.healthContentView addSubview:_imageV];
      _imageV.image  =[UIImage imageNamed:@"生活照拍照图标"];
      
      

  }
}

-(void)fourBtnView:(BanBoHealthFourBtnView *)btnView clickBtnAtIdx:(NSInteger)btnIdx
{
    switch (btnIdx) {
        case 0:
        {
         [self back];
        }
            break;
        case 1:
        {
        [self saveBtnClick:nil];
        }
            break;
        default:
            break;
    }
}

#pragma mark btnEvent
-(void)back{
    if (self.completion) {
        self.completion(nil,nil,YES);
    }
}
-(void)takePhotoBtnClick:(UIButton *)btn{
    [super getImageFromCameraWithCompletion:^(UIImage *image, NSError *error, BOOL isCancel) {
        if(image){
            self.iconView.image=image;
            [self.iconView bb_hiddenOverlay];
        }
        if (error) {
            [HCYUtil showError:error];
        }
    }];
}
-(void)saveBtnClick:(UIButton *)btn{
    if (self.iconView.image==nil) {
        [HCYUtil toastMsg:@"没有照片" inView:self.view];
        return;
    }else{
        __weak typeof(self) wself=self;
        [HCYUtil showProgressWithStr:@"正在保存"];
        [[BanBoHealthManager sharedInstance] uploadDailyImage:self.iconView.image forUser:self.user.CardId inProject:self.project.projectId progres:nil completion:^(id data, NSError *error) {
            if (!wself) {
                return ;
            }
            dispatch_async_main_safe(^{
                [HCYUtil dismissProgress];
                if (error) {
                    [HCYUtil showError:error];
                    return ;
                }
                [HCYUtil toastMsg:@"保存成功" inView:wself.view];
            
                if (wself.completion) {
                    wself.completion(wself.iconView.image,error,NO);
                }
                
                //      4.13修改BanBoShiminGRMCListViewController * grmcListVC = [[BanBoShiminGRMCListViewController alloc]init];
                [wself.navigationController popViewControllerAnimated:YES];
            });
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
