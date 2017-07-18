//
//  BanBoVRTJCell.m
//  kq_banbo_app
//
//  Created by banbo on 2017/6/23.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "BanBoVRTJCell.h"

@implementation BanBoVRTJCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
        
    }
    return self;
}
-(void)setDataWithModel:(BanBoVRTongJiModel *)model
{
    _banzuLabel.text = model.groupName;
    _banzuPeopleLabel.text = [NSString stringWithFormat:@"%@",model.usercount];
    _passPeopleLabel.text = [NSString stringWithFormat:@"%@",model.vrusercount];
}
-(void)createUI
{
    _banzuLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 1, 85, 40)];
    _banzuLabel.text = @"总计";
    _banzuLabel.textAlignment = NSTextAlignmentCenter;
   // _banzuLabel.backgroundColor = [UIColor magentaColor];
    _banzuLabel.textColor = [UIColor blackColor];
    _banzuLabel.font  =[YZLabelFactory normal14Font];
    [self.contentView addSubview:_banzuLabel];
    _banzuPeopleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-110)/2, 1, 100, 40)];
    _banzuPeopleLabel.text = @"2";
    _banzuPeopleLabel.textAlignment = NSTextAlignmentCenter;
    //_banzuPeopleLabel.backgroundColor = [UIColor cyanColor];
    _banzuPeopleLabel.textColor = [UIColor blackColor];
    _banzuPeopleLabel.font  =[YZLabelFactory normal14Font];
    [self.contentView addSubview:_banzuPeopleLabel];
    _passPeopleLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-110, 1, 100, 40)];
    _passPeopleLabel.text = @"1";
    _passPeopleLabel.textAlignment = NSTextAlignmentCenter;
    //_passPeopleLabel.backgroundColor = [UIColor greenColor];
    _passPeopleLabel.textColor = [UIColor blackColor];
    _passPeopleLabel.font  =[YZLabelFactory normal14Font];
   
    [self.contentView addSubview:_passPeopleLabel];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
