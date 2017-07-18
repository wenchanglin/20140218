//
//  BanBoCardiogramInfoView.m
//  kq_banbo_app
//
//  Created by hcy on 2016/12/14.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoCardiogramInfoView.h"
@interface BanBoCardiogramInfoView()
@property (weak, nonatomic) IBOutlet UILabel *cardiogramLabel;
@property (weak, nonatomic) IBOutlet UILabel *fLabel;
@property (weak, nonatomic) IBOutlet UILabel *hrLabel;
@property (weak, nonatomic) IBOutlet UILabel *bpmLabel;

@end
@implementation BanBoCardiogramInfoView

static UINib* nib;
- (instancetype)initWithFrame:(CGRect)frame
{
    if (!nib) {
        nib=[UINib nibWithNibName:@"BanBoCardiogramInfoView" bundle:nil];
    }
    NSArray *objs=[nib instantiateWithOwner:nil options:nil];
    if (objs.count) {
        BanBoCardiogramInfoView *view= [objs lastObject];
        view.frame=frame;
        return view;
    }else{
        if (self=[super initWithFrame:frame]) {
            
        }
    }
    return self;
}
-(void)setViewMode:(BOOL)viewMode{
    _viewMode=viewMode;
    if (viewMode) {
        self.fLabel.text=@"您上次的心跳数据为:";
    }else{
        self.fLabel.text=@"你当前的心跳数据为:";
    }
    [self.fLabel sizeToFit];
}
-(void)awakeFromNib{
    [super awakeFromNib];
    UIFont *font=[YZLabelFactory normalFont];
    
    self.fLabel.font=font;
    self.hrLabel.font=font;
    self.bpmLabel.font=font;

}
-(void)setCardiogram:(NSString *)cardiogram{
    if ([cardiogram isEqualToString:_cardiogram]) {
        return;
    }
    _cardiogramLabel.text=cardiogram;
    [_cardiogramLabel sizeToFit];
    _cardiogram=[cardiogram copy];
}
@end
