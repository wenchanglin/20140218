//
//  BanBoLineHeaderView+BanzhuSelect.m
//  kq_banbo_app
//
//  Created by hcy on 2017/1/3.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "BanBoLineHeaderView+BanzhuSelect.h"
#import <objc/runtime.h>
@implementation BanBoLineHeaderView (BanzhuSelect)
static char banzhuSelectKeyEnable;
static char banzhuSelectKeyTapGesture;
static char banzhuSelectKeyContentView;
static char banzhuSelectKeyCompletion;
static char banzhuSelectKeyBanzhuItem;
static char banzhuSelectKeyPrefixCheck;
-(UITapGestureRecognizer *)banzhuSelectTapGesture{
    id val= objc_getAssociatedObject(self, &banzhuSelectKeyTapGesture);
    return val;
}
#pragma mark -
-(BOOL)enableBanzhuSelect{
    id val=objc_getAssociatedObject(self, &banzhuSelectKeyEnable);
    if (val) {
        return [val boolValue];
    }
    return NO;
}
-(void)setEnableBanzhuSelect:(BOOL)enableBanzhuSelect{
    objc_setAssociatedObject(self, &banzhuSelectKeyEnable,@(enableBanzhuSelect), OBJC_ASSOCIATION_ASSIGN);
    if (enableBanzhuSelect) {
        self.rightLabel.userInteractionEnabled=YES;
        if ([self banzhuSelectTapGesture]==nil) {
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBanzhuSelectView)];
            objc_setAssociatedObject(self, &banzhuSelectKeyTapGesture, tap, OBJC_ASSOCIATION_RETAIN);
            [self.rightLabel addGestureRecognizer:tap];
        }
    }else{
        
    }
}
#pragma mark -
-(UIView *)contentView{
    return objc_getAssociatedObject(self, &banzhuSelectKeyContentView);
}

-(void)setContentView:(UIView *)contentView{
   objc_setAssociatedObject(self, &banzhuSelectKeyContentView,contentView, OBJC_ASSOCIATION_RETAIN);
}
#pragma mark -
-(BanBoBanzhuSelectCompletion)banzhuSelectCompletion{
    return objc_getAssociatedObject(self, &banzhuSelectKeyCompletion);
}
-(void)setBanzhuSelectCompletion:(BanBoBanzhuSelectCompletion)completion{
    objc_setAssociatedObject(self, &banzhuSelectKeyCompletion,completion, OBJC_ASSOCIATION_COPY_NONATOMIC);
};

#pragma mark -
-(void)setItem:(BanBoBanzhuItem *)item{
    objc_setAssociatedObject(self, &banzhuSelectKeyBanzhuItem,item, OBJC_ASSOCIATION_RETAIN);
}
-(BanBoBanzhuItem *)item{
    return objc_getAssociatedObject(self, &banzhuSelectKeyBanzhuItem);
}
#pragma mark -
-(void)setBanzhuselectPrefixCheck:(BOOL (^)(BanBoLineHeaderView *))BanzhuselectPrefixCheck{
   objc_setAssociatedObject(self, &banzhuSelectKeyPrefixCheck,BanzhuselectPrefixCheck, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(BOOL (^)(BanBoLineHeaderView *))BanzhuselectPrefixCheck{
    return objc_getAssociatedObject(self, &banzhuSelectKeyPrefixCheck);

}
#pragma mark -
-(void)showBanzhuSelectView{
    if(self.BanzhuselectPrefixCheck){
        BOOL result=self.BanzhuselectPrefixCheck(self);
        if (!result) {
            return;
        }
    }
    
    BanBoBanZhuSelectView *selectView=nil;
    if (self.item) {
        selectView=[BanBoBanZhuSelectView xiaoBanzhuSelectViewWithBanzhuItem:self.item];
    }else{
        selectView=[BanBoBanZhuSelectView banZhuSelectView];
    }
    [selectView showInView:self.contentView];
    __weak typeof (BanBoBanZhuSelectView *)wselect=selectView;
    __weak typeof(self) wself=self;
    selectView.completionBlock=^(BanBoBanzhuItem *item ,BOOL isCancel){
        [wselect dismiss];
        if (wself.banzhuSelectCompletion) {
            wself.banzhuSelectCompletion(item,isCancel);
        }
    };
}

@end
