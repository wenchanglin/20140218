//
//  HCYImagePickerBrowserself.m
//  HCYImagePickerDemo
//
//  Created by hcy on 16/8/16.
//  Copyright © 2016年 hcy. All rights reserved.
//

#import "HCYImagePickerBrowserBottomView.h"
#import "UIView+DanteImagePicker.h"
#import "HCYImagePickerCollector.h"
@interface HCYImagePickerBrowserBottomView()
@property(strong,nonatomic)UIActivityIndicatorView *indicatorView;

@end
@implementation HCYImagePickerBrowserBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self p_setupSubviews];
       
    }
    return self;
}
-(void)p_setupSubviews{
    UIColor *bgColor=[UIColor colorWithRed:40/255.f green:40/255.f blue:40/255.f alpha:1.f];
    
    self.backgroundColor=bgColor;
    self.left=0;
    self.width=[UIScreen mainScreen].bounds.size.width;
    self.height=44.f;
    self.bottom=[UIScreen mainScreen].bounds.size.height;
    UIButton *sourceBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [sourceBtn setImage:[UIImage imageNamed:@"hcyimagepicker_hdimage_uncheck@2x"] forState:UIControlStateNormal];
    [sourceBtn setImage:[UIImage imageNamed:@"hcyimagepicker_hdimage_checked@2x"] forState:UIControlStateHighlighted];
    [sourceBtn setImage:[UIImage imageNamed:@"hcyimagepicker_hdimage_checked@2x"] forState:UIControlStateSelected];
    [sourceBtn sizeToFit];
    [self addSubview:sourceBtn];
    
    _indicatorView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [_indicatorView sizeToFit];
    [self addSubview:_indicatorView];
    _indicatorView.hidden=YES;
    
    self.sourceBtn=sourceBtn;
    UILabel *lab=[UILabel new];
    lab.text=NSLocalizedString(@"原图", nil);
    lab.textColor=[UIColor grayColor];
    [lab sizeToFit];

    [self addSubview:lab];
    self.sourceLabel=lab;
    UIButton *sendBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    UIColor *sendBgColor=[UIColor colorWithRed:23/255.f green:215/255.f blue:177/255.f alpha:1.f];
    [sendBtn setTitleColor:sendBgColor forState:UIControlStateNormal];
    [self addSubview:sendBtn];
    self.sendBtn=sendBtn;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    _sourceBtn.top=(self.height-_sourceBtn.height)*.5;
    _sourceBtn.left=10;
    
    _sourceLabel.left=_sourceBtn.right+5;
    _sourceLabel.top=_sourceBtn.top;
    
    _indicatorView.top=(self.height-_indicatorView.height)*.5;
    _indicatorView.left=_sourceLabel.right+5;
    
    
    _sendBtn.top=(self.height-_sendBtn.height)*0.5;
    _sendBtn.right=self.width-20;


}
-(void)refreshWithItem:(id<HCYImagePickerContentItem>)item{
    [super refreshWithItem:item];
    NSInteger count=[self.dataCollector itemCount];
    NSString *str=[NSString stringWithFormat:@"发送(%ld)",(long)count];
    if (!count) {
        str=@"发送";
    }
    [_sendBtn setTitle:str forState:UIControlStateNormal];
    [_sendBtn sizeToFit];
    _sendBtn.right=self.width-20;
    
    if([self.dataCollector sourceImage]){
        _indicatorView.hidden=NO;
        [_indicatorView startAnimating];
        __weak typeof(self) wself=self;
        [self.item getSourceLengthWithCompletion:^(id<HCYImagePickerContentItem> data, NSString *sizeLength) {
            if (!wself) {
                return ;
            }
            __block NSString* sizeLen=sizeLength;
            dispatch_async_main_safe((^{
                [wself.indicatorView stopAnimating];
                wself.indicatorView.hidden=YES;
                //因为是异步。所以设置的时候需要再判断一次
                if ([wself.dataCollector sourceImage]) {
                    wself.sourceLabel.text=[NSString stringWithFormat:@"原图(%@)",sizeLen];
                    [wself.sourceLabel sizeToFit];
                }
            }));
            
            
        }];
        _sourceBtn.selected=YES;
    }else{
        _sourceLabel.text=@"原图";
        _sourceBtn.selected=NO;
    }
    [_sourceLabel sizeToFit];
}
//-(void)sourceBtnClick:(UIButton *)btn{

//}


@end
