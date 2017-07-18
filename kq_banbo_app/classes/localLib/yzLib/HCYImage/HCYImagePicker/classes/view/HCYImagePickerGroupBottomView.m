//
//  DtImagePickerBottomView.m
//  DanteImagePicker
//
//  Created by hcy on 15/11/5.
//  Copyright © 2015年 hcy. All rights reserved.
//

#import "HCYImagePickerGroupBottomView.h"
#import "UIView+DanteImagePicker.h"
#import "HCYImagePickerCollector.h"
@interface HCYImagePickerGroupBottomView()<HCYImagePickerCollectorDelegate>
@property(strong,nonatomic)UIImageView *bgImageView;
@property(strong,nonatomic)UIButton *sendBtn;
@property(strong,nonatomic)HCYImagePickerCollector *collector;
@end
@implementation HCYImagePickerGroupBottomView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
     [self setSubviews];
        _collector=[HCYImagePickerCollector sharedCollector];
        [_collector addDelegate:self];
        
    }
    return self;
}
-(void)setSubviews{
    _bgImageView=[[UIImageView alloc] init];
    _bgImageView.image=[UIImage imageNamed:@"hcyimagepicker_bg"];
    [self addSubview:_bgImageView];

    UIFont *font=[UIFont systemFontOfSize:13.f];
    _sendBtn=[UIButton new];
    [_sendBtn setTitle:NSLocalizedString(@"发送", nil) forState:UIControlStateNormal];
    [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sendBtn setBackgroundImage:[UIImage imageNamed:@"hcyimagepicker_send_disabled"] forState:UIControlStateDisabled];
    [_sendBtn setBackgroundImage:[UIImage imageNamed:@"hcyimagepicker_send_normal"] forState:UIControlStateNormal];
    [_sendBtn setBackgroundImage:[UIImage imageNamed:@"hcyimagepicker_send_pressed"] forState:UIControlStateHighlighted];
    _sendBtn.titleLabel.font=font;
    [self addSubview:_sendBtn];
    [_sendBtn addTarget:self action:@selector(sendBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _sendBtn.enabled=NO;

}
#pragma mark UI

-(void)layoutSubviews{
    [super layoutSubviews];
    
    _bgImageView.frame=self.bounds;
    
    _sendBtn.right=self.width-10;
    _sendBtn.centerY=self.height*.5;
}
-(void)setselectItemCount:(NSInteger)count{
    _sendBtn.enabled=count;

    NSString *title=NSLocalizedString(@"发送", nil);
    if (count) {
        title=[NSString stringWithFormat:@"%@(%ld)",NSLocalizedString(@"发送", nil),(long)count];
    }
    [_sendBtn setTitle:title forState:UIControlStateNormal];
    [_sendBtn sizeToFit];
    [self setNeedsLayout];
    
}

#pragma mark collectDelegate
-(void)collector:(HCYImagePickerCollector *)collector addItem:(id)item{
    [self setselectItemCount:[collector itemCount]];
}
-(void)collector:(HCYImagePickerCollector *)collector removeItem:(id)item{
    [self setselectItemCount:[collector itemCount]];
}

#pragma mark Event
-(void)sendBtnClicked:(UIButton *)btn{
    [_collector send];
}
-(void)dealloc{
    [[HCYImagePickerCollector sharedCollector] removeDelegate:self];
}
@end
