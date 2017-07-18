//
//  BanBoHealthInfoCollectViewController.m
//  kq_banbo_app
//
//  Created by hcy on 2016/12/8.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoHealthInfoCollectViewController.h"
#import "YZTitleView+BanBo.h"

@interface BanBoHealthInfoCollectViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(strong,nonatomic)UILabel *healthTitleLabel;

@property(strong,nonatomic)UIImagePickerController *imagePickerController;
@property(strong,nonatomic)void (^imagePickerCompletion)(UIImage *, NSError *, BOOL);
@end

@implementation BanBoHealthInfoCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=BanBoViewBgGrayColor;
    YZTitleView *titleView=[YZTitleView banbo_inst];
    [titleView showInNaviItem:self.navigationItem];
    
    
   
}
-(void)healthSetTitle:(NSString *)title{
    self.healthTitleLabel.text=title;
}

@synthesize healthContentView=_healthContentView;
-(UIView *)healthContentView{
    if (!_healthContentView) {
        CGFloat y=self.healthTitleLabel.bottom;
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, y, self.view.width, self.view.height-y)];
        view.backgroundColor=BanBoViewBgGrayColor;
        [self.view addSubview:view];
        _healthContentView=view;
    }
    return _healthContentView;
}
-(UILabel *)healthTitleLabel{
    if (!_healthTitleLabel) {
        _healthTitleLabel=[YZLabelFactory blackLabel];
        _healthTitleLabel.backgroundColor=[UIColor hcy_colorWithRed:229 green:226 blue:228 alpha:1];
        _healthTitleLabel.font=[UIFont systemFontOfSize:16.f];
        _healthTitleLabel.textAlignment=NSTextAlignmentCenter;
        _healthTitleLabel.frame=CGRectMake(0, 64, self.view.width, 45);
        [self.view addSubview:_healthTitleLabel];
    }
    return _healthTitleLabel;
}
-(BanBoHealthImageView *)healthImageView:(CGRect)frame imageInset:(CGPoint)p{
    BanBoHealthImageView *imageView=[[BanBoHealthImageView alloc] initWithFrame:frame];
    
    imageView.imageViewInset=p;
    imageView.backgroundColor=BanBoHealthBlueColor;
    
    return imageView;
}
-(BanBoHealthImageViewSecond *)healthImageViewV2:(CGRect)frame bgImage:(UIImage *)bgImage centerImage:(UIImage *)centerImage centerText:(NSString *)centerText{
    
    BanBoHealthImageViewSecond *imageView=[[BanBoHealthImageViewSecond alloc] initWithFrame:frame];
    
    imageView.layer.cornerRadius=5;
    imageView.layer.masksToBounds=YES;
    imageView.userInteractionEnabled=YES;
    imageView.image=bgImage;
    imageView.bb_centerImage=centerImage;
    imageView.bb_centerText=centerText;
    
    return imageView;
}

-(UIButton *)blueBtnWithTitle:(NSString *)title{
    UIButton *btn=[UIButton new];
    
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundColor:BanBoBlueColor];
    [btn sizeToFit];
    
    return btn;

}
-(UIButton *)redBtnWithTitle:(NSString *)title{
    UIButton *btn=[UIButton new];
    
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundColor:BanBoHealthRedColor];
    [btn sizeToFit];
    
    return btn;
}
-(CGFloat)btnHeight{
    return 45.f;
}
#pragma mark 拍照
-(void)getImageFromCameraWithCompletion:(void (^)(UIImage *, NSError *, BOOL))completion{
    if(completion==nil){
        return;
    }
    if(self.imagePickerController){
        [self.imagePickerController dismissViewControllerAnimated:NO completion:nil];
        self.imagePickerController=nil;
    }
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *controller=[[UIImagePickerController alloc] init];
        controller.delegate=self;
        controller.sourceType=UIImagePickerControllerSourceTypeCamera;
        
        self.imagePickerCompletion=completion;
        self.imagePickerController=controller;
        
        [self presentViewController:controller animated:YES completion:nil];
    }else{
        completion(nil,[NSError errorWithDomain:@"localDomain" code:2 userInfo:@{NSLocalizedDescriptionKey:@"未找到相机或者权限被禁止"}],NO);
        return;
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    if (info) {
        //        NSString *mediaType = info[UIImagePickerControllerMediaType];
        UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
        if (orgImage) {
            if (self.imagePickerCompletion) {
                self.imagePickerCompletion(orgImage,nil,NO);
            }
        }
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        [self clean];
    }];
    
}
-(void)clean{
    self.imagePickerCompletion=nil;
    self.imagePickerController=nil;
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    if (self.imagePickerCompletion) {
        self.imagePickerCompletion(nil,nil,YES);
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        [self clean];
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
-(void)dealloc{
    DDLogInfo(@"i'm dealloc:%@",self);
}
@end
