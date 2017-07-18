//
//  BanBoBloodPressureView.m
//  kq_banbo_app
//
//  Created by hcy on 2016/12/13.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import "BanBoBloodPressureView.h"
@interface BanBoBloodPressureView()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *gyLabel;
@property (weak, nonatomic) IBOutlet UILabel *mmhgF;
@property (weak, nonatomic) IBOutlet UILabel *mmhgS;
@property (weak, nonatomic) IBOutlet UILabel *dyLabel;
@property (weak, nonatomic) IBOutlet UILabel *fenLabel;
@property (weak, nonatomic) IBOutlet UILabel *maiboLabel;
@property (weak, nonatomic) IBOutlet UILabel *gyValLabel;
@property (weak, nonatomic) IBOutlet UILabel *dyValLabel;
@property (weak, nonatomic) IBOutlet UILabel *maiboValLabel;
@property (weak, nonatomic) IBOutlet UIImageView *heartIcon;

@end
@implementation BanBoBloodPressureView
static UINib* nib;
- (instancetype)initWithFrame:(CGRect)frame
{
    if (!nib) {
        nib=[UINib nibWithNibName:@"BanBoBloodPressureView" bundle:nil];
    }
    NSArray *objs=[nib instantiateWithOwner:nil options:nil];
    if (objs.count) {
        BanBoBloodPressureView *view= [objs lastObject];
        view.frame=frame;
        return view;
    }else{
        if (self=[super initWithFrame:frame]) {
            
        }
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    DDLogDebug(@"BanBoBloodPressureView awakefromNib");
    UIFont *font=[YZLabelFactory normalFont];
    self.nameLabel.font=font;
    self.gyLabel.font=font;
    self.mmhgF.font=font;
    self.mmhgS.font=font;
    self.dyLabel.font=font;
    self.fenLabel.font=font;
    self.maiboLabel.font=font;
    
    self.gyValLabel.text=@"";
    self.dyValLabel.text=@"";
    self.maiboValLabel.text=@"";
    self.signIcon.hidden=YES;
    self.heartIcon.hidden=YES;
}
#pragma mark setMethods
-(void)setUserName:(NSString *)userName{
    if ([userName isEqualToString:_userName]) {
        return;
    }
    self.nameLabel.text=userName;
    _userName=[userName copy];
}
-(void)setHighPressure:(NSInteger)highPressure{
    if (highPressure==_highPressure) {
        return;
    }
    _highPressure=highPressure;
    self.gyValLabel.text=[NSString stringWithFormat:@"%ld",(long)highPressure];
}
-(void)setLowPressure:(NSInteger)lowPressure{
    if (lowPressure==_lowPressure) {
        return;
    }
    _lowPressure=lowPressure;
    self.dyValLabel.text=[NSString stringWithFormat:@"%ld",(long)lowPressure];
}
-(void)setPluseFreq:(NSInteger)pluseFreq{
    if (pluseFreq==_pluseFreq) {
        return;
    }
    _pluseFreq=pluseFreq;
    self.maiboValLabel.text=[NSString stringWithFormat:@"%ld",(long)pluseFreq];
    self.heartIcon.hidden=NO;
}
@end
