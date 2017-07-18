//
//  BanBoCardInfoCollectViewController.m
//  kq_banbo_app
//
//  Created by hcy on 2016/12/9.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoCardInfoCollectViewController.h"
//#import "HCYMutableBtnView.h"
#import "BanBoHealthFourBtnView.h"
@interface BanBoCardInfoCollectViewController ()<BanBoHealthFourBtnsViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>//HCYMutableBtnViewDelegate,
@property(strong,nonatomic)BanBoHealthImageViewSecond *frontImageView;
@property(strong,nonatomic)BanBoHealthImageViewSecond *backImageView;
@property(strong,nonatomic)UIImageView *ZhengView;
@property(strong,nonatomic)UIImageView * FanView;
@property(strong,nonatomic)UIImage * ZhengImage;
@property(strong,nonatomic)UIImage * FanImage;
@end

@implementation BanBoCardInfoCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self healthSetTitle:@"身份证拍照"];
    [self setupSubviews];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(createImg1) name:@"1获取成功" object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(createImg2) name:@"2获取成功" object:nil];
}
-(void)createImg1{
    _ZhengView.image = self.ZhengImage;
}
-(void)createImg2{
    _FanView.image = self.FanImage;
}

-(void)setupSubviews{
    
    if (!self.isViewMode) {
        CGFloat blueViewWidth=self.view.width*.7;
        
        CGRect frontRect=CGRectMake(0, 23, blueViewWidth, blueViewWidth/1.6);
        
        BanBoHealthImageViewSecond *frontImageView=[self healthImageViewV2:frontRect bgImage:[UIImage imageNamed:@"身份证正面"] centerImage:[UIImage imageNamed:@"身份证正面图标"] centerText:@"点击上传身份证正面"];
        frontImageView.centerX=self.view.width*.5;
        [self.healthContentView addSubview:frontImageView];
        _frontImageView=frontImageView;
        
        CGRect backRect=frontRect;
        backRect.origin.y=CGRectGetMaxY(frontRect)+20;
        
        BanBoHealthImageViewSecond *backImageView=[self healthImageViewV2:backRect bgImage:[UIImage imageNamed:@"身份证反面"] centerImage:[UIImage imageNamed:@"身份证反面图标"] centerText:@"点击上传身份证反面"];
        backImageView.centerX=self.view.width*.5;
        [self.healthContentView addSubview:backImageView];
        _backImageView=backImageView;
        

        UITapGestureRecognizer *tapFront=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getFrontImage)];
        [_frontImageView addGestureRecognizer:tapFront];
        
        UITapGestureRecognizer *tapBack=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getBackImage)];
        [_backImageView addGestureRecognizer:tapBack];
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
        
        btnView.centerY=(backImageView.bottom+(self.healthContentView.height-backImageView.bottom)*.5);
        btnView.centerX=self.view.width*.5;
        
        [self.healthContentView addSubview:btnView];

    }
    else
    {
        CGFloat blueViewWidths=self.view.width*.7;
        
        CGRect frontRect=CGRectMake(0, 23, blueViewWidths, blueViewWidths/1.6);
    
        _ZhengView = [[UIImageView alloc]initWithFrame:frontRect];
        [self.healthContentView addSubview:_ZhengView];
        _ZhengView.centerX = self.view.width*.5;
        _ZhengView.image = [UIImage imageNamed:@"身份证正面图标"];
        CGRect backRect=frontRect;
        backRect.origin.y=CGRectGetMaxY(frontRect)+20;
        
        _FanView = [[UIImageView alloc]initWithFrame:backRect];
        _FanView.centerX = self.view.width*.5;
        [self.healthContentView addSubview:_FanView];
        _FanView.image = [UIImage imageNamed:@"身份证反面图标"];
        
        [HCYUtil showProgressWithStr:@"图片下载中"];
        NSString * type = @"_1";
        [[BanBoHealthManager sharedInstance]getCardPic:Inter_GetCardPic forUser:self.user.CardId  Type:type completion:^(id data, NSError *error) {
            self.ZhengImage = [UIImage imageWithData:data];
            DDLogInfo(@"正面照片:%@",self.ZhengImage);
            [[NSNotificationCenter defaultCenter]postNotificationName:@"1获取成功" object:nil];
        }];
        type = @"_2";
        [[BanBoHealthManager sharedInstance]getCardPic:Inter_GetCardPic forUser:self.user.CardId Type:type completion:^(id data, NSError *error) {
            self.FanImage = [UIImage imageWithData:data];
            DDLogInfo(@"反面照片:%@",self.FanImage);
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"2获取成功" object:nil];
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [HCYUtil dismissProgress];
        });
        
        
        
    }
}
#pragma mark btnViewDelegate

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
            [self save];
        }
            break;
        default:
            break;
    }
}

#pragma mark events
-(void)getFrontImage{
 [super getImageFromCameraWithCompletion:^(UIImage *image, NSError *error, BOOL isCancel) {
     if (image) {
         [self putImage:image toView:self.frontImageView];
     }
     if (error) {
         [HCYUtil showError:error];
     }
 }];
}
-(void)getBackImage{
    [super getImageFromCameraWithCompletion:^(UIImage *image, NSError *error, BOOL isCancel) {
        if (image) {
            [self putImage:image toView:self.backImageView];
        }
        if (error) {
            [HCYUtil showError:error];
        }
    }];
}
-(void)putImage:(UIImage *)image toView:(BanBoHealthImageViewSecond *)imageView{

    imageView.image=image;
    if (image) {
        imageView.bb_centerImage=nil;
        imageView.bb_centerText=@"";
    }
    
}
-(void)back{
    if (self.completion) {
        self.completion(nil,nil,YES);
    }
}
-(void)save{
    UIImage *frontImage=self.frontImageView.image;
    UIImage *backImage=self.backImageView.image;
    if (frontImage==nil) {
        [HCYUtil toastMsg:@"缺少正面图片" inView:self.view];
        return;
    }
    if (backImage==nil) {
        [HCYUtil toastMsg:@"缺少反面图片" inView:self.view];
        return;
    }
    __weak typeof(self) wself=self;
    [HCYUtil showProgressWithStr:@"保存中"];
    [[BanBoHealthManager sharedInstance] uploadCardImages:@[frontImage,backImage] forUser:self.user.CardId inProject:self.project.projectId progres:nil completion:^(id data, NSError *error) {
        if (!wself) {
            return ;
        }
        if (wself.completion==nil) {
            return;
        }
        dispatch_async_main_safe(^{
            [HCYUtil dismissProgress];
            if (error) {
                [HCYUtil showError:error];
                return ;
            }
            [HCYUtil toastMsg:@"保存成功" inView:wself.view];
            wself.completion(@[frontImage,backImage],error,NO);
            [wself.navigationController popViewControllerAnimated:YES];
        });
    }];

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
