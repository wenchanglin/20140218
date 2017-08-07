//
//  BanBoTaDiaoTableViewCell.m
//  kq_banbo_app
//
//  Created by banbo on 2017/5/27.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "BanBoTaDiaoTableViewCell.h"
#import "YZLabelFactory.h"
#import <Masonry.h>
@implementation BanBoTaDiaoTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withIndexPath:(NSIndexPath *)indexpath
{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _indexpath = indexpath;
        [self createUI];
    }
    return self;
}
-(void)setDataWithIndexPath:(NSIndexPath *)indexpath withModel:(BanBoTaDiaoModel *)models withSheBeiModel:(BanBoTaDiaoSheBeiModel *)shebeimodel
{
    if(shebeimodel.status==nil||shebeimodel.status==NULL)
    {
        _TaDiaoStates.text = @"该塔吊不在线";
    }
    else
    {
        _TaDiaoStates.text = [NSString stringWithFormat:@"该塔吊%@",shebeimodel.status];
    }
    if (shebeimodel.cSim ==nil||shebeimodel.status == NULL) {
        _phoneLabel.text = @"未插入SIM卡";
    }
    else
    {
        _phoneLabel.text = [NSString stringWithFormat:@"%@",shebeimodel.cSim];
    }
    
    if(models.longitude ==nil||models.longitude==NULL)
    {
        _longitudeLabel.text = @"0";
    }
    else
    {
        _longitudeLabel.text = models.longitude;
    }
    if(models.latitude ==nil||models.latitude==NULL)
    {
        _latitudeLabel.text = @"0";
    }
    else
    {
        _latitudeLabel.text = models.latitude;
    }
    if(models.wDip ==nil||models.wDip==NULL)
    {
        _obliqueityLabel.text = @"0";
        [_obliqueityLabel sizeToFit];
    }
    else
    {
        _obliqueityLabel.text = [NSString stringWithFormat:@"%@",models.wDip];//倾角数值
        [_obliqueityLabel sizeToFit];
    }
    
    if(models.wRate ==nil||models.wRate==NULL)
    {
        _multiplyLabel.text = @"0";
    }
    else
    {
        _multiplyLabel.text = [NSString stringWithFormat:@"%@",models.wRate];//倍率
        
    }
    
    if(models.wFRateVCode ==nil||models.wFRateVCode==NULL)
    {
        _carryLabel.text = @"0";
        [_carryLabel sizeToFit];
    }
    else
    {
        _carryLabel.text = [NSString stringWithFormat:@"%@",models.wFRateVCode];//最大载重
        [_carryLabel sizeToFit];
        
    }
    if(models.wFCodeVRate ==nil||models.wFCodeVRate==NULL)
    {
        _extentLabel.text = @"0";
        [_extentLabel sizeToFit];
    }
    else
    {
        _extentLabel.text = [NSString stringWithFormat:@"%@",models.wFCodeVRate];//最大幅度
        [_extentLabel sizeToFit];
        
    }
    if(shebeimodel.deviceNumber ==nil||shebeimodel.deviceNumber==NULL)
    {
        _nameLabel.text = @"设备编号为空";
    }
    else
    {
        _nameLabel.text = [NSString stringWithFormat:@"%@",shebeimodel.deviceNumber];//设备编号
    }
    
    _timeLabel.text = models.dateTime;
    if (shebeimodel.forearm ==nil||shebeimodel.forearm==NULL) {
        _bigArmLabel.text = @"0";
    }else
    {
        _bigArmLabel.text = [NSString stringWithFormat:@"%@",shebeimodel.forearm];
    }
    if (shebeimodel.balanceArm == nil||shebeimodel.balanceArm==NULL) {
        _balanceArmLabel.text = @"0";
    }
    else
    {
        _balanceArmLabel.text = shebeimodel.balanceArm;
    }
    if(models.wTorque==nil||models.wTorque==NULL)
    {
        _lijuSubLabel.text =@"0";
    }
    else
    {
        _lijuSubLabel.text = [NSString stringWithFormat:@"%@",models.wTorque];
    }
    if (models.wLoad==nil||models.wLoad==NULL)
    {
        _zaizhongSubLabel.text = @"0";
    }else
    {
        _zaizhongSubLabel.text = [NSString stringWithFormat:@"%@",models.wLoad];
    }
    if (models.wWindvel==nil||models.wWindvel==NULL)
    {
        _windSubLabel.text = @"0";
    }
    else
    {
        _windSubLabel.text = [NSString stringWithFormat:@"%@",models.wWindvel];
    }
    if (models.wMargin==nil||models.wMargin==NULL) {
        _fuduSubLabel.text =@"0";
    }
    else
    {
        _fuduSubLabel.text = [NSString stringWithFormat:@"%@",models.wMargin];
    }
    if (models.wHeight==nil||models.wHeight==NULL) {
        _gaoduSubLabel.text =@"0";
    }
    else
    {
        _gaoduSubLabel.text = [NSString stringWithFormat:@"%@",models.wHeight];
    }
    if (models.dwRotate==nil||models.dwRotate==NULL) {
        _jiaoduSubLabel.text =@"0";
    }
    else
    {
        _jiaoduSubLabel.text = [NSString stringWithFormat:@"%@",models.dwRotate];
    }
    if (models.wTorque==NULL||models.wFRateVCode==NULL||models.wFCodeVRate==NULL) {
        _lijuProgress.progress = 0.0;
    }
    else
    {
        _lijuProgress.progress = [models.wTorque floatValue]/ [models.wFRateVCode floatValue]/[models.wFCodeVRate floatValue]*1000;
    }
    if (models.wLoad==NULL||models.wFRateVCode==NULL) {
        _zaizhongProgress.progress = 0.0;
    }
    _zaizhongProgress.progress = [models.wLoad floatValue]/[models.wFRateVCode floatValue];
    if ([models.wWindvel floatValue]>=20) {
        _windProgress.progress = 1;
    }
    else
    {
        _windProgress.progress = [models.wWindvel floatValue]/20;
    }
    if (models.wMargin==NULL||models.wFCodeVRate ==NULL) {
        _fuduProgress.progress =0.0;
    }
    else
    {
        _fuduProgress.progress = [models.wMargin floatValue]/[models.wFCodeVRate floatValue];
    }
    if ([shebeimodel.wheight intValue]==0||[models.wHeight intValue]==0) {
        _gaoduProgress.progress = 0.0;
    }
    else
    {
        _gaoduProgress.progress = [models.wHeight floatValue]/[shebeimodel.wheight intValue];
    }
    if (models.dwRotate==NULL) {
        _jiaoduProgress.progress=0.0;
    }
    else
    {
        _jiaoduProgress.progress = [models.dwRotate floatValue]/360;
    }
}
-(void)createUI
{
    if(_indexpath.section==0)
    {
        _TaDiaoStates = [[UILabel alloc]init];
        [_TaDiaoStates setTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        _TaDiaoStates.font = [YZLabelFactory bigFont];
        [self.contentView addSubview:_TaDiaoStates];
        [_TaDiaoStates mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.top.equalTo(self).offset(5);
            make.width.mas_equalTo(120);
        }];
        _simLabel = [[UILabel alloc]init];
        [_simLabel setTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        _simLabel.font = [YZLabelFactory bigFont];
        _simLabel.text = @"SIM卡";
        [self.contentView addSubview:_simLabel];
        [_simLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_TaDiaoStates.mas_left);
            make.top.equalTo(_TaDiaoStates.mas_bottom).offset(5);
            make.width.equalTo(_TaDiaoStates.mas_width).multipliedBy(0.5);
        }];
        _jingduLabel = [UILabel new];
        [_jingduLabel setTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        _jingduLabel.font = [YZLabelFactory bigFont];
        _jingduLabel.text = @"经度";
        [self.contentView addSubview:_jingduLabel];
        [_jingduLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_simLabel.mas_left);
            make.width.equalTo(_simLabel);
            make.top.equalTo(_simLabel.mas_bottom).offset(10);
        }];
        _weiduLabel = [UILabel new];
        [_weiduLabel setTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        _weiduLabel.font = [YZLabelFactory bigFont];
        _weiduLabel.text =@"纬度";
        [self.contentView addSubview:_weiduLabel];
        [_weiduLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_jingduLabel.mas_left);
            make.top.equalTo(_jingduLabel.mas_bottom).offset(10);
            make.width.equalTo(_jingduLabel);
        }];
        _qingjiaoLabel = [UILabel new];
        _qingjiaoLabel.text = @"倾角";
        [_qingjiaoLabel setTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        _qingjiaoLabel.font = [YZLabelFactory bigFont];
        [self.contentView addSubview:_qingjiaoLabel];
        [_qingjiaoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_weiduLabel.mas_left);
            make.top.equalTo(_weiduLabel.mas_bottom).offset(10);
            make.width.equalTo(_weiduLabel);
        }];
        _beilvLabel = [UILabel new];
        [_beilvLabel setTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        _beilvLabel.font = [YZLabelFactory bigFont];
        _beilvLabel.text = @"倍率";
        [self.contentView addSubview:_beilvLabel];
        [_beilvLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_qingjiaoLabel);
            make.top.equalTo(_qingjiaoLabel.mas_bottom).offset(10);
            make.width.equalTo(_qingjiaoLabel);
        }];
        
        _zuidazaizhongLabel = [UILabel new];
        [_zuidazaizhongLabel setTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        _zuidazaizhongLabel.font = [YZLabelFactory bigFont];
        _zuidazaizhongLabel.text =@"当前幅度允许最大载重";
        [self.contentView addSubview:_zuidazaizhongLabel];
        [_zuidazaizhongLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_beilvLabel.mas_bottom).offset(10);
            make.left.equalTo(_beilvLabel);
        }];
        
        _zuidafuduLabel = [UILabel new];
        [_zuidafuduLabel setTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        _zuidafuduLabel.font = [YZLabelFactory bigFont];
        _zuidafuduLabel.text =@"当前载重允许最大幅度";
        [self.contentView addSubview:_zuidafuduLabel];
        [_zuidafuduLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_zuidazaizhongLabel.mas_bottom).offset(10);
            make.left.equalTo(_zuidazaizhongLabel);
            make.width.equalTo(_zuidazaizhongLabel);
        }];
        _phoneLabel = [UILabel new];
        [_phoneLabel setTextColor:[UIColor hcy_colorWithString:@"#fda803"]];
        _phoneLabel.font = [YZLabelFactory bigFont];
        [self.contentView addSubview:_phoneLabel];
        [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_TaDiaoStates.mas_bottom).offset(5);
            make.left.equalTo(_simLabel.mas_right).offset(40);
            make.width.equalTo(self).multipliedBy(0.7);
        }];
        
        _longitudeLabel = [UILabel new];
        [_longitudeLabel setTextColor:[UIColor hcy_colorWithString:@"#fda803"]];
        _longitudeLabel.font = [YZLabelFactory bigFont];
        [self.contentView addSubview:_longitudeLabel];
        [_longitudeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_phoneLabel.mas_bottom).offset(10);
            make.left.equalTo(_phoneLabel.mas_left);
        }];
        _latitudeLabel =[UILabel new];
        [_latitudeLabel setTextColor:[UIColor hcy_colorWithString:@"#fda803"]];
        _latitudeLabel.font = [YZLabelFactory bigFont];
        [self.contentView addSubview:_latitudeLabel];
        [_latitudeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_longitudeLabel.mas_bottom).offset(10);
            make.left.equalTo(_phoneLabel.mas_left);
            make.width.equalTo(_phoneLabel.mas_width);
        }];
        _obliqueityLabel = [UILabel new];
        [_obliqueityLabel setTextColor:[UIColor hcy_colorWithString:@"#fda803"]];
        _obliqueityLabel.font = [YZLabelFactory bigFont];
        [self.contentView addSubview:_obliqueityLabel];
        [_obliqueityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_latitudeLabel.mas_bottom).offset(10);
            make.left.equalTo(_latitudeLabel.mas_left);
            
        }];
        _qingjiaoLabel = [UILabel new];
        [_qingjiaoLabel setTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        _qingjiaoLabel.font = [YZLabelFactory bigFont];
        _qingjiaoLabel.text = @"度";
        [self.contentView addSubview:_qingjiaoLabel];
        [_qingjiaoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_latitudeLabel.mas_bottom).offset(10);
            make.left.equalTo(_obliqueityLabel.mas_right).offset(5);
        }];
        _multiplyLabel =[UILabel new];
        [_multiplyLabel setTextColor:[UIColor hcy_colorWithString:@"#fda803"]];
        _multiplyLabel.font = [YZLabelFactory bigFont];
        [self.contentView addSubview:_multiplyLabel];
        [_multiplyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_obliqueityLabel.mas_bottom).offset(10);
            make.left.equalTo(_obliqueityLabel.mas_left);
        }];
        
        _carryLabel = [UILabel new];
        [_carryLabel setTextColor:[UIColor hcy_colorWithString:@"#fda803"]];
        _carryLabel.font = [YZLabelFactory bigFont];
        [self.contentView addSubview:_carryLabel];
        [_carryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_zuidazaizhongLabel);
            make.left.equalTo(_zuidazaizhongLabel.mas_right).offset(30);
        }];
        _carrydanweiLabel = [UILabel new];
        [_carrydanweiLabel setTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        _carrydanweiLabel.font = [YZLabelFactory bigFont];
        _carrydanweiLabel.text = @"kg";
        [self.contentView addSubview:_carrydanweiLabel];
        [_carrydanweiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_carryLabel);
            make.left.equalTo(_carryLabel.mas_right).offset(5);
        }];
        _extentLabel =[UILabel new];
        [_extentLabel setTextColor:[UIColor hcy_colorWithString:@"#fda803"]];
        _extentLabel.font = [YZLabelFactory bigFont];
        [self.contentView addSubview:_extentLabel];
        [_extentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_zuidafuduLabel);
            make.left.equalTo(_zuidafuduLabel.mas_right).offset(30);
        }];
        _extentdanweiLabel = [UILabel new];
        [_extentdanweiLabel setTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        _extentdanweiLabel.font = [YZLabelFactory bigFont];
        _extentdanweiLabel.text = @"m";
        [self.contentView addSubview:_extentdanweiLabel];
        [_extentdanweiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_extentLabel);
            make.left.equalTo(_extentLabel.mas_right).offset(5);
        }];
    }
    else if (_indexpath.section==1)
    {
        _nameLabel = [self createLabelWithFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.left.equalTo(self).offset(20);
            make.width.equalTo(self).multipliedBy(0.5);
            make.height.mas_equalTo(30);
        }];
        _timeLabel = [self createLabelWithFont:[UIFont systemFontOfSize:13] withTextColor:[UIColor hcy_colorWithString:@"#999999"]];
        [self.contentView addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-10);
            make.centerY.equalTo(_nameLabel);
        }];
        _bigbiLabel = [self createLabelWithFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        _bigbiLabel.text = @"大臂长";
        [self.contentView addSubview:_bigbiLabel];
        [_bigbiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nameLabel.mas_bottom).offset(5);
            make.left.equalTo(self).offset(20);
        }];
        _pinghengbiLabel =[self createLabelWithFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        _pinghengbiLabel.text =@"平衡臂长";
        [self.contentView addSubview:_pinghengbiLabel];
        [_pinghengbiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_bigbiLabel.mas_bottom).offset(5);
            make.left.equalTo(self).offset(20);
        }];
        
        _bigArmLabel = [self createLabelWithFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#fda803"]];
        [self.contentView addSubview:_bigArmLabel];
        [_bigArmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_bigbiLabel);
            make.left.equalTo(_bigbiLabel.mas_right).offset(70);
        }];
        _balanceArmLabel = [self createLabelWithFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#fda803"]];
        [self.contentView addSubview:_balanceArmLabel];
        [_balanceArmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_pinghengbiLabel);
            make.top.equalTo(_bigArmLabel.mas_bottom).offset(5);
            make.left.equalTo(_pinghengbiLabel.mas_right).offset(50);
        }];
        _fengeView = [UIView new];
        [self.contentView addSubview:_fengeView];
        _fengeView.backgroundColor = [UIColor hcy_colorWithString:@"#f7f7f7"];
        [_fengeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_pinghengbiLabel.mas_bottom).offset(10);
            make.width.equalTo(self);
            make.height.mas_equalTo(15);
        }];
        
        UIView * firstV = [UIView new];
        [self.contentView addSubview:firstV];
        firstV.backgroundColor = [UIColor hcy_colorWithString:@"#e0e0e0"];
        [firstV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_fengeView);
            make.width.equalTo(self);
            make.height.mas_equalTo(1);
        }];
        UIView * secondV = [UIView new];
        [self.contentView addSubview:secondV];
        secondV.backgroundColor = [UIColor hcy_colorWithString:@"#e0e0e0"];
        [secondV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_fengeView.mas_bottom);
            make.width.equalTo(self);
            make.height.mas_equalTo(1);
        }];
        
        _lijuLabel = [UILabel new];
        _lijuLabel.text =@"力矩";
        _lijuLabel.font = [YZLabelFactory bigFont];
        _lijuLabel.textColor = [UIColor hcy_colorWithString:@"#333333"];
        [self.contentView addSubview:_lijuLabel];
        [_lijuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.top.equalTo(_fengeView.mas_bottom).offset(10);
        }];
        
        _lijuSubLabel = [UILabel new];
        [self.contentView addSubview:_lijuSubLabel];
        _lijuSubLabel.font = [YZLabelFactory bigFont];
        _lijuSubLabel.textAlignment = NSTextAlignmentCenter;
        _lijuSubLabel.textColor = [UIColor hcy_colorWithString:@"#fda803"];
        [_lijuSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.top.equalTo(_lijuLabel.mas_bottom).offset(5);
            
        }];
        _lijudanweiBtn = [UIButton new];
        [self.contentView addSubview:_lijudanweiBtn];
        UIImage * image = [[UIImage imageNamed:@"力矩图标"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_lijudanweiBtn setImage:image forState:UIControlStateNormal];
        [_lijudanweiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_fengeView.mas_bottom).offset(8);
            make.left.equalTo(_lijuLabel.mas_right).offset(20);
        }];
        
        _lijudanweiLabel =[UILabel new];
        _lijudanweiLabel.textColor = [UIColor hcy_colorWithString:@"#333333"];
        _lijudanweiLabel.text =@"t.m";
        [self.contentView addSubview:_lijudanweiLabel];
        [_lijudanweiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_lijudanweiBtn);
            make.top.equalTo(_lijudanweiBtn.mas_bottom).offset(5);
            make.centerX.equalTo(_lijudanweiBtn);
        }];
        _lijuProgress = [self createProgressViewProgress:0];
        [self.contentView addSubview:_lijuProgress];
        
        [_lijuProgress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_lijudanweiBtn.mas_right).offset(20);
            make.top.equalTo(_fengeView.mas_bottom).offset(20);
            make.right.equalTo(self).offset(-20);
            make.height.mas_equalTo(22);
        }];
        _lijuView = [UIView new];
        [self.contentView addSubview:_lijuView];
        _lijuView.backgroundColor = [UIColor hcy_colorWithString:@"#e0e0e0"];
        [_lijuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_lijuSubLabel.mas_bottom).offset(5);
            make.left.equalTo(_lijuLabel);
            make.right.equalTo(self).offset(-20);
            make.height.mas_equalTo(1);
        }];
        _zaizhongLabel = [self createLabelWithFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        _zaizhongLabel.text = @"载重";
        [self.contentView addSubview:_zaizhongLabel];
        [_zaizhongLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.top.equalTo(_lijuView.mas_bottom).offset(10);
        }];
        _zaizhongSubLabel = [self createLabelWithFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#fda803"]];
        [self.contentView addSubview:_zaizhongSubLabel];
        [_zaizhongSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_zaizhongLabel.mas_bottom).offset(5);
            make.left.equalTo(_zaizhongLabel);
        }];
        UIImage * zaizhong = [[UIImage imageNamed:@"载重图标"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _zaizhongdanweiBtn = [UIButton new];
        [self.contentView addSubview:_zaizhongdanweiBtn];
        [_zaizhongdanweiBtn setImage:zaizhong forState:UIControlStateNormal];
        [_zaizhongdanweiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_lijuView.mas_bottom).offset(8);
            make.left.equalTo(_zaizhongLabel.mas_right).offset(20);
        }];
        _zaizhongdanweiLabel = [self createLabelWithFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        _zaizhongdanweiLabel.text = @"kg";
        [self.contentView addSubview:_zaizhongdanweiLabel];
        [_zaizhongdanweiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_zaizhongdanweiBtn.mas_bottom).offset(5);
            make.left.equalTo(_zaizhongdanweiBtn);//.offset(2);
            make.centerX.equalTo(_zaizhongdanweiBtn);
        }];
        _zaizhongProgress = [self createProgressViewProgress:0];
        [self.contentView addSubview:_zaizhongProgress];
        [_zaizhongProgress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_zaizhongdanweiBtn.mas_right).offset(25);
            make.top.equalTo(_lijuView.mas_bottom).offset(20);
            make.right.equalTo(self).offset(-20);
            make.height.mas_equalTo(22);
        }];
        _zaizhongView = [UIView new];
        _zaizhongView.backgroundColor = [UIColor hcy_colorWithString:@"#e0e0e0"];
        [self.contentView addSubview:_zaizhongView];
        [_zaizhongView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_zaizhongSubLabel.mas_bottom).offset(5);
            make.left.equalTo(_zaizhongSubLabel);
            make.right.equalTo(self).offset(-20);
            make.height.mas_equalTo(1);
        }];
        _windLabel = [self createLabelWithFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        _windLabel.text = @"风速";
        [self.contentView addSubview:_windLabel];
        [_windLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_zaizhongView.mas_bottom).offset(10);
            make.left.equalTo(self).offset(20);
        }];
        
        _windSubLabel = [self createLabelWithFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#fda803"]];
        [self.contentView addSubview:_windSubLabel];
        [_windSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_windLabel.mas_bottom).offset(5);
            make.left.equalTo(_windLabel);
        }];
        UIImage * wind = [[UIImage imageNamed:@"风速图标"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _winddanweiBtn = [UIButton new];
        [_winddanweiBtn setImage:wind forState:UIControlStateNormal];
        [self.contentView addSubview:_winddanweiBtn];
        [_winddanweiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_windLabel.mas_right).offset(20);
            make.top.equalTo(_zaizhongView.mas_bottom).offset(8);
        }];
        _winddanweiLabel = [self createLabelWithFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        _winddanweiLabel.text = @"m/s";
        [self.contentView addSubview:_winddanweiLabel];
        [_winddanweiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_winddanweiBtn.mas_bottom).offset(3);
            make.left.equalTo(_winddanweiBtn).offset(-2);
        }];
        _windProgress = [self createProgressViewProgress:0];
        [self.contentView addSubview:_windProgress];
        [_windProgress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_winddanweiBtn.mas_right).offset(25);
            make.top.equalTo(_zaizhongView.mas_bottom).offset(18);
            make.right.equalTo(self).offset(-20);
            make.height.mas_equalTo(22);
        }];
        _fengsuView = [UIView new];
        _fengsuView.backgroundColor = [UIColor hcy_colorWithString:@"#e0e0e0"];
        [self.contentView addSubview:_fengsuView];
        [_fengsuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_windSubLabel.mas_bottom).offset(5);
            make.left.equalTo(_windLabel);
            make.right.equalTo(self).offset(-20);
            make.height.mas_equalTo(1);
        }];
        _fuduLabel = [self createLabelWithFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        _fuduLabel.text = @"幅度";
        [self.contentView addSubview:_fuduLabel];
        [_fuduLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_fengsuView.mas_bottom).offset(10);
            make.left.equalTo(self).offset(20);
        }];
        _fuduSubLabel = [self createLabelWithFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#fda803"]];
        _fuduSubLabel.text = @"7.9";
        [self.contentView addSubview:_fuduSubLabel];
        [_fuduSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_fuduLabel.mas_bottom).offset(5);
            make.left.equalTo(_fuduLabel);
        }];
        UIImage * fuduImg = [[UIImage imageNamed:@"幅度图标"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _fududanweiBtn =[UIButton new];
        [_fududanweiBtn setImage:fuduImg forState:UIControlStateNormal];
        [self.contentView addSubview:_fududanweiBtn];
        [_fududanweiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_fengsuView.mas_bottom).offset(8);
            make.left.equalTo(_fuduLabel.mas_right).offset(20);
        }];
        _fududanweiLabel = [self createLabelWithFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        _fududanweiLabel.text = @"m";
        [self.contentView addSubview:_fududanweiLabel];
        [_fududanweiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_fududanweiBtn.mas_bottom).offset(3);
            make.left.equalTo(_fududanweiBtn).offset(1);
        }];
        _fuduProgress = [self createProgressViewProgress:0];
        [self.contentView addSubview:_fuduProgress];
        [_fuduProgress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_fengsuView.mas_bottom).offset(18);
            make.left.equalTo(_fududanweiBtn.mas_right).offset(25);
            make.height.mas_offset(22);
            make.right.equalTo(self).offset(-20);
        }];
        _fuduView = [[UIView alloc]init];
        _fuduView.backgroundColor = [UIColor hcy_colorWithString:@"#e0e0e0"];
        [self.contentView addSubview:_fuduView];
        [_fuduView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_fuduSubLabel.mas_bottom).offset(5);
            make.left.equalTo(_fuduSubLabel);
            make.right.equalTo(self).offset(-20);
            make.height.mas_equalTo(1);
        }];
        _gaoduLabel = [self createLabelWithFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        _gaoduLabel.text = @"高度";
        [self.contentView addSubview:_gaoduLabel];
        [_gaoduLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_fuduView.mas_bottom).offset(10);
            make.left.equalTo(self).offset(20);
        }];
        
        _gaoduSubLabel = [self createLabelWithFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#fda803"]];
        [self.contentView addSubview:_gaoduSubLabel];
        [_gaoduSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_gaoduLabel.mas_bottom).offset(5);
            make.left.equalTo(_gaoduLabel);
        }];
        UIImage * gaoduImg = [[UIImage imageNamed:@"高度图标"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _gaodudanweiBtn = [UIButton new];
        [_gaodudanweiBtn setImage:gaoduImg forState:UIControlStateNormal];
        [self.contentView addSubview:_gaodudanweiBtn];
        [_gaodudanweiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_fuduView.mas_bottom).offset(8);
            make.left.equalTo(_gaoduLabel.mas_right).offset(20);
        }];
        _gaodudanweiLabel = [self createLabelWithFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        _gaodudanweiLabel.text = @"m";
        [self.contentView addSubview:_gaodudanweiLabel];
        [_gaodudanweiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_gaodudanweiBtn.mas_bottom).offset(3);
            make.centerX.equalTo(_gaodudanweiBtn);
        }];
        _gaoduProgress = [self createProgressViewProgress:0];
        [self.contentView addSubview:_gaoduProgress];
        [_gaoduProgress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_fuduView.mas_bottom).offset(18);
            make.left.equalTo(_gaodudanweiBtn.mas_right).offset(25);
            make.right.equalTo(self).offset(-20);
            make.height.mas_equalTo(22);
        }];
        _gaoduView = [UIView new];
        _gaoduView.backgroundColor = [UIColor hcy_colorWithString:@"#e0e0e0"];
        [self.contentView addSubview:_gaoduView];
        [_gaoduView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_gaoduSubLabel.mas_bottom).offset(5);
            make.left.equalTo(_gaoduSubLabel);
            make.right.equalTo(self).offset(-20);
            make.height.mas_equalTo(1);
        }];
        _jiaoduLabel = [self createLabelWithFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        _jiaoduLabel.text = @"角度";
        [self.contentView addSubview:_jiaoduLabel];
        [_jiaoduLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_gaoduView.mas_bottom).offset(10);
            make.left.equalTo(self).offset(20);
        }];
        _jiaoduSubLabel = [self createLabelWithFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#fda803"]];
        [self.contentView addSubview:_jiaoduSubLabel];
        [_jiaoduSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_jiaoduLabel.mas_bottom).offset(5);
            make.left.equalTo(_jiaoduLabel);
        }];
        UIImage * jiaoduImg = [[UIImage imageNamed:@"角度图标"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _jiaodudanweiBtn = [UIButton new];
        [self.contentView addSubview:_jiaodudanweiBtn];
        [_jiaodudanweiBtn setImage:jiaoduImg forState:UIControlStateNormal];
        [_jiaodudanweiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_gaoduView.mas_bottom).offset(8);
            make.left.equalTo(_jiaoduLabel.mas_right).offset(20);
        }];
        _jiaodudanweiLabel = [self createLabelWithFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        _jiaodudanweiLabel.text = @"o";
        [self.contentView addSubview:_jiaodudanweiLabel];
        [_jiaodudanweiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_jiaodudanweiBtn.mas_bottom).offset(5);
            make.centerX.equalTo(_jiaodudanweiBtn);
        }];
        _jiaoduProgress = [self createProgressViewProgress:0];
        [self.contentView addSubview:_jiaoduProgress];
        [_jiaoduProgress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_gaoduView.mas_bottom).offset(18);
            make.left.equalTo(_jiaodudanweiBtn.mas_right).offset(25);
            make.right.equalTo(self).offset(-20);
            make.height.mas_equalTo(22);
        }];
        _jiaoduView = [UIView new];
        _jiaoduView.backgroundColor = [UIColor hcy_colorWithString:@"#e0e0e0"];
        [self.contentView addSubview:_jiaoduView];
        [_jiaoduView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_jiaoduSubLabel.mas_bottom).offset(5);
            make.width.equalTo(self);
            make.height.mas_equalTo(1);
        }];
        
    }
}
/**创建进度条*/
-(LDProgressView *)createProgressViewProgress:(CGFloat)progress
{
    LDProgressView * progressView = [LDProgressView new];
    progressView.color = [UIColor hcy_colorWithString:@"#4ac120"];
    progressView.background = [UIColor hcy_colorWithString:@"#d6f5cc"];
    progressView.flat = @YES;
    progressView.borderRadius = @1;
    progressView.showBackgroundInnerShadow = @NO;
    progressView.progress = progress;
    progressView.type = LDProgressSolid;
    progressView.animateDirection = LDAnimateDirectionForward;
    //    progressView.animate = @YES;
    return progressView;
}
/**创建按钮*/
-(UIButton *)createButtonwithFrame:(CGRect)frame  withImage:(UIImage *)image
{
    UIButton * button = [[UIButton alloc]initWithFrame:frame];
    button.titleLabel.font = [YZLabelFactory bigFont];
    [button setTitleColor:[UIColor blackColor] forState:0];
    [button setImage:image forState:0];
    return button;
}
-(UILabel *)createLabelWithFont:(UIFont *)font withTextColor:(UIColor *)color
{
    UILabel * label = [UILabel new];
    label.font = font;
    //    label.adjustsFontSizeToFitWidth = YES;
    label.numberOfLines = 0;
    label.textColor = color;
    return label;
}
@end
