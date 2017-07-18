//
//  BanBoNewReportView.m
//  kq_banbo_app
//
//  Created by hcy on 2016/12/27.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoNewReportView.h"
#import "BanBoLineHeaderView+BanzhuSelect.h"
#import "IDCardBlueTooth.h"
#import "BanBoBanZhuSelectView.h"
@interface BanBoNewReportView()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(assign,nonatomic)CGFloat maxFloat;
@property(strong,nonatomic)NSArray *titleArr;

@property(strong,nonatomic)BanBoLineHeaderView *banzhuView;
@property(strong,nonatomic)BanBoLineHeaderView *xiaobanzhuView;
@property(strong,nonatomic)BanBoLineHeaderView *nameView;
@property(strong,nonatomic)BanBoLineHeaderView *sexView;
@property(strong,nonatomic)BanBoLineHeaderView *minzuView;
@property(strong,nonatomic)BanBoLineHeaderView *cardView;

@property(strong,nonatomic)UIImage *iconDefaultImage;

@property(strong,nonatomic)UIImagePickerController *imagePicker;

@property(strong,nonatomic)BanBoBanzhuItem *banzhu;
@property(strong,nonatomic)BanBoBanzhuItem *xiaobanzhu;
@end
@implementation BanBoNewReportView

- (instancetype)initWithFrame:(CGRect)frame
{
    frame.size.height=SCREEN_HEIGHT*.35+10;
    self = [super initWithFrame:frame];
    if (self) {
        self.lineLeft=15;
        self.backgroundColor=[UIColor whiteColor];
        [self createSubviews];
    }
    return self;
}

#pragma mark subView
-(void)createSubviews{
    [self calcMaxFloat];
    //15 15
    self.iconDefaultImage=[UIImage imageNamed:@"gongren"];
    UIImageView *iconView=[[UIImageView alloc] initWithImage:self.iconDefaultImage];
    [self addSubview:iconView];
    iconView.userInteractionEnabled=YES;
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconViewTaped:)];
    [iconView addGestureRecognizer:tapGesture];
    _iconView=iconView;
    
    NSArray *valArr=@[@"banzhuView",@"xiaobanzhuView",@"nameView",@"sexView",@"minzuView",@"cardView"];

    for (NSInteger i=0; i<self.titleArr.count; i++) {
        NSString *title=self.titleArr[i];
        BanBoLineHeaderView *lineView=[self makeLineViewWithTitle:title];
        if(i==0){
            lineView.rightLabel.text=@"请选择班组";
        }
        [self addSubview:lineView];
        NSString *keyPath=valArr[i];
        [self setValue:lineView forKeyPath:keyPath];
    }
    self.cardView.bottomSeparView.hidden=YES;
    //卡号加减
    BanBoCardNumberView *numView=[BanBoCardNumberView new];
    numView.height=self.cardView.height;
    
    [self addSubview:numView];
    self.numView=numView;
    
    __weak typeof(self) wself=self;
    self.banzhuView.enableBanzhuSelect=YES;
    self.banzhuView.banzhuSelectCompletion=^(BanBoBanzhuItem *item ,BOOL isCancel){
        if(isCancel){
            return ;
        }
        if (![item isDefaultItem]) {
            if([wself.banzhu isEqual:item]==NO){
                wself.banzhu=item;
                wself.xiaobanzhuView.item=item;
                wself.xiaobanzhu=nil;
            }
        }else{
            wself.xiaobanzhuView.item=nil;
            wself.banzhu=nil;
            wself.xiaobanzhu=nil;
            [wself cleanCache];
        }
        [wself refreshLabel];
    };
    self.xiaobanzhuView.enableBanzhuSelect=YES;
    self.xiaobanzhuView.BanzhuselectPrefixCheck=^(BanBoLineHeaderView *view){
        if (wself.banzhu==nil) {
            [HCYUtil toastMsg:@"请选择班组" inView:wself];
            return NO;
        }
        return YES;
    };
    self.xiaobanzhuView.banzhuSelectCompletion=^(BanBoBanzhuItem *item,BOOL isCancel){
        if (isCancel) {
            return ;
        }
        if ([item isDefaultItem]) {
            wself.xiaobanzhu=nil;
        }else{
            wself.xiaobanzhu=item;
        }
        [wself refreshLabel];
    };
    [self getCacheData];
}
-(void)setContentView:(UIView *)contentView{
    self.banzhuView.contentView=contentView;
    self.xiaobanzhuView.contentView=contentView;
    
}
#pragma mark cache
-(void)getCacheData{
    id banzhu=[[YZCacheManager sharedInstance] cacheForKey:YZCacheKeyBanzhuItemInReport type:YZCacheTypeMemory];
    id xiaobanzhu=[[YZCacheManager sharedInstance] cacheForKey:YZCacheKeyXiaoBanzhuItemInReport type:YZCacheTypeMemory];
    if (banzhu) {
        _banzhu=banzhu;
        self.xiaobanzhuView.item=banzhu;
    }
    if (xiaobanzhu) {
        _xiaobanzhu=xiaobanzhu;
    }
    
    [self refreshLabel];
}
-(void)cacheBanzhu:(id)banzhu{
    [[YZCacheManager sharedInstance] addCache:banzhu forKey:YZCacheKeyBanzhuItemInReport type:YZCacheTypeMemory];
}

-(void)cacheXiaoBanzhu:(id)xiaobanzhu{
    [[YZCacheManager sharedInstance] addCache:xiaobanzhu forKey:YZCacheKeyXiaoBanzhuItemInReport type:YZCacheTypeMemory];
}
-(void)setBanzhu:(BanBoBanzhuItem *)banzhu{
    _banzhu=banzhu;
    [self cacheBanzhu:banzhu];
}
-(void)setXiaobanzhu:(BanBoBanzhuItem *)xiaobanzhu{
    _xiaobanzhu=xiaobanzhu;
    [self cacheXiaoBanzhu:xiaobanzhu];
}
-(void)cleanCache{
    [self cleanBanzhu];
    [self cleanXiaoBanzhu];
}
-(void)cleanBanzhu{
    self.banzhu=nil;
    [[YZCacheManager sharedInstance] removeCacheForKey:YZCacheKeyBanzhuItemInReport type:YZCacheTypeMemory];
}
-(void)cleanXiaoBanzhu{
    self.xiaobanzhu=nil;
    [[YZCacheManager sharedInstance] removeCacheForKey:YZCacheKeyXiaoBanzhuItemInReport type:YZCacheTypeMemory];
}
#pragma mark refresh
-(void)refreshLabel{
    self.banzhuView.rightLabel.text=self.banzhu.groupname?:@"请选择班组";
    self.xiaobanzhuView.rightLabel.text=self.xiaobanzhu.groupname?:@"";
}
#pragma mark public
-(BOOL)haveImage{
    if (self.iconView.image && self.iconView.image!=self.iconDefaultImage) {
        return YES;
    }else{
        return NO;
    }

}
-(NSInteger)groupId{
    if (self.banzhu) {
        return self.banzhu.groupid;
    }else{
        return -1;
    }
}
-(NSInteger)subGroupId{
    if (self.xiaobanzhu) {
        return self.xiaobanzhu.groupid;
    }else{
        return -1;
    }
}
#pragma mark events
-(void)iconViewTaped:(UITapGestureRecognizer *)tapGesture{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]==NO) {
        [HCYUtil toastMsg:@"无法使用相机" inView:self];
        return;
    }
    
    
    UIAlertController *alertVC=[UIAlertController alertControllerWithTitle:NSLocalizedString(@"身份证照片", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSString *doActionTitle=@"重拍";
    if (self.iconView.image==nil || self.iconView.image==self.iconDefaultImage) {
        doActionTitle=@"拍摄";
    }
    UIAlertAction *doAction=[UIAlertAction actionWithTitle:doActionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takeImage];
    }];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertVC addAction:doAction];
    [alertVC addAction:cancelAction];
    if (self.hcy_viewController!=nil) {
        [self.hcy_viewController presentViewController:alertVC animated:YES completion:nil];
    }
    
}
-(void)takeImage{
    UIImagePickerController *imagePicker=[[UIImagePickerController alloc] init];
    imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate=self;
    self.imagePicker=imagePicker;
    if(self.hcy_viewController){
        [self.hcy_viewController presentViewController:imagePicker animated:YES completion:nil];
    }
}
#pragma mark imagePickerDelegate
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.imagePicker=nil;
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
    if (orgImage) {
        self.iconView.image=orgImage;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.imagePicker=nil;
}

#pragma mark  refresh
-(void)refreshWithData:(IDCardInfo *)data{
    self.nameView.rightLabel.text=data.name;
    self.sexView.rightLabel.text=data.gender;
    self.minzuView.rightLabel.text=data.nation;
    
    [self.nameView.rightLabel sizeToFit];
    [self.sexView.rightLabel sizeToFit];
    [self.minzuView.rightLabel sizeToFit];
}

#pragma mark param
-(BanBoLineHeaderView *)makeLineViewWithTitle:(NSString *)title{
    BanBoLineHeaderView *lineHeaderView=[BanBoLineHeaderView new];
    
    lineHeaderView.leftLabel.width=self.maxFloat;
    lineHeaderView.leftLabel.text=title;
    lineHeaderView.height=(self.height-10)/self.titleArr.count;
    
    return lineHeaderView;
}
-(void)calcMaxFloat{
    CGFloat maxFloat=0;
    for (NSString *title in self.titleArr) {
        CGFloat titleWidth=[title boundingRectWithSize:CGSizeMake(maxFloat, maxFloat) options:(NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[YZLabelFactory normalFont]} context:nil].size.width;
        maxFloat=MAX(maxFloat, titleWidth);
    }
    self.maxFloat=ceil(maxFloat)+1;
}
-(NSArray *)titleArr{
    if (!_titleArr) {
        _titleArr=@[@"大班组",@"小班组",@"姓 名",@"性 别",@"民 族",@"卡 号"];
    }
    return _titleArr;
}
#pragma mark layout
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat iconTop=15;
    CGFloat iconRightMargin=15;
    _iconView.right=self.width-iconRightMargin;
    _iconView.top=iconTop;
    
    CGFloat lineLeft=self.lineLeft;

    CGFloat lineTop=10;
    CGFloat lineViewWidth=_iconView.left-20;
    CGFloat lineMargin=0;
    _banzhuView.left=lineLeft;
    _banzhuView.top=lineTop;
    _banzhuView.width=lineViewWidth;
    
    _xiaobanzhuView.left=lineLeft;
    _xiaobanzhuView.top=_banzhuView.bottom+lineMargin;
    _xiaobanzhuView.width=lineViewWidth;

    _nameView.left=lineLeft;
    _nameView.top=_xiaobanzhuView.bottom+lineMargin;
    _nameView.width=lineViewWidth;
    
    _sexView.left=lineLeft;
    _sexView.top=_nameView.bottom+lineMargin;
    _sexView.width=lineViewWidth;
    
    _minzuView.left=lineLeft;
    _minzuView.top=_sexView.bottom+lineMargin;
    _minzuView.width=lineViewWidth;
    
    _iconView.height=_minzuView.bottom-_iconView.top;
    
    _cardView.left=lineLeft;
    _cardView.top=_minzuView.bottom+lineMargin;
    _cardView.width=lineViewWidth;
    
    _numView.left=_cardView.verSeparView.right+15;
    _numView.top=_cardView.top;
    _numView.width=_iconView.left-_numView.left-5;
}

-(void)dealloc{
    DDLogDebug(@"I'm dealloc:%@",self);
}
@end
