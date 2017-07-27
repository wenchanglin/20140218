//
//  BanBoTaDiaoTableViewCell.m
//  kq_banbo_app
//
//  Created by banbo on 2017/5/27.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "BanBoTaDiaoTableViewCell.h"
#import "YZLabelFactory.h"
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
    }
    else
    {
        _obliqueityLabel.text = [NSString stringWithFormat:@"%@",models.wDip];//倾角数值
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
    }
    else
    {
        _carryLabel.text = [NSString stringWithFormat:@"%@",models.wFRateVCode];//最大载重
        
    }
    if(models.wFCodeVRate ==nil||models.wFCodeVRate==NULL)
    {
        _extentLabel.text = @"0";
    }
    else
    {
        _extentLabel.text = [NSString stringWithFormat:@"%@",models.wFCodeVRate];//最大幅度
        
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
        _TaDiaoStates = [self createLabelwithFrame:CGRectMake(20, 5, 120, 30) withFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        [self.contentView addSubview:_TaDiaoStates];
        _simLabel = [self createLabelwithFrame:CGRectMake(20, CGRectGetMaxY(_TaDiaoStates.frame)+1,60,30) withFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        _simLabel.text = @"SIM卡";
        [self.contentView addSubview:_simLabel];
        _jingduLabel = [self createLabelwithFrame:CGRectMake(20, CGRectGetMaxY(_simLabel.frame)+1, 60, 30) withFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        _jingduLabel.text = @"经度";
        [self.contentView addSubview:_jingduLabel];
        _weiduLabel = [self createLabelwithFrame:CGRectMake(20, CGRectGetMaxY(_jingduLabel.frame)+1, 60, 30) withFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        _weiduLabel.text =@"纬度";
        [self.contentView addSubview:_weiduLabel];
        _qingjiaoLabel = [self createLabelwithFrame:CGRectMake(20, CGRectGetMaxY(_weiduLabel.frame)+1, 60, 30) withFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        _qingjiaoLabel.text = @"倾角";
        [self.contentView addSubview:_qingjiaoLabel];
        _beilvLabel = [self createLabelwithFrame:CGRectMake(20, CGRectGetMaxY(_qingjiaoLabel.frame)+1, 60, 30) withFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        _beilvLabel.text = @"倍率";
        [self.contentView addSubview:_beilvLabel];
        _zuidazaizhongLabel = [self createLabelwithFrame:CGRectMake(20, CGRectGetMaxY(_beilvLabel.frame)+1, SCREEN_WIDTH/2+20, 30) withFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        _zuidazaizhongLabel.text =@"当前幅度允许最大载重";
        [self.contentView addSubview:_zuidazaizhongLabel];
        _zuidafuduLabel = [self createLabelwithFrame:CGRectMake(20, CGRectGetMaxY(_zuidazaizhongLabel.frame)+1, SCREEN_WIDTH/2+20, 30) withFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        _zuidafuduLabel.text =@"当前载重允许最大幅度";
        [self.contentView addSubview:_zuidafuduLabel];
        
        _phoneLabel = [self createLabelwithFrame:CGRectMake(CGRectGetMaxX(_simLabel.frame)+40, CGRectGetMaxY(_TaDiaoStates.frame)+1, SCREEN_WIDTH-CGRectGetMaxX(_simLabel.frame)-120, 30) withFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#fda803"]];
        [self.contentView addSubview:_phoneLabel];
        _longitudeLabel =[self createLabelwithFrame:CGRectMake(CGRectGetMaxX(_jingduLabel.frame)+40, CGRectGetMaxY(_phoneLabel.frame)+1, _phoneLabel.width, 30) withFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#fda803"]];
        [self.contentView addSubview:_longitudeLabel];
        _latitudeLabel =[self createLabelwithFrame:CGRectMake(CGRectGetMaxX(_weiduLabel.frame)+40, CGRectGetMaxY(_longitudeLabel.frame)+1, _phoneLabel.width, 30) withFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#fda803"]];
        [self.contentView addSubview:_latitudeLabel];
        _obliqueityLabel = [self createLabelwithFrame:CGRectMake(CGRectGetMaxX(_qingjiaoLabel.frame)+40, CGRectGetMaxY(_latitudeLabel.frame)+1, 40, 30) withFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#fda803"]];
        [self.contentView addSubview:_obliqueityLabel];
        _qingjiaoLabel = [self createLabelwithFrame:CGRectMake(CGRectGetMaxX(_obliqueityLabel.frame), CGRectGetMaxY(_latitudeLabel.frame)+1, 30, 30) withFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        _qingjiaoLabel.text = @"度";
        [self.contentView addSubview:_qingjiaoLabel];
        _multiplyLabel =[self createLabelwithFrame:CGRectMake(CGRectGetMaxX(_beilvLabel.frame)+40, CGRectGetMaxY(_obliqueityLabel.frame)+1, _phoneLabel.width, 30) withFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#fda803"]];
        [self.contentView addSubview:_multiplyLabel];
        _carryLabel = [self createLabelwithFrame:CGRectMake(CGRectGetMaxX(_zuidazaizhongLabel.frame), CGRectGetMaxY(_multiplyLabel.frame)+1, 50, 30) withFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#fda803"]];
        [self.contentView addSubview:_carryLabel];
        _carrydanweiLabel = [self createLabelwithFrame:CGRectMake(CGRectGetMaxX(_carryLabel.frame), CGRectGetMaxY(_multiplyLabel.frame)+1, 30, 30) withFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        _carrydanweiLabel.text = @"kg";
        [self.contentView addSubview:_carrydanweiLabel];
        _extentLabel = [self createLabelwithFrame:CGRectMake(CGRectGetMaxX(_zuidafuduLabel.frame), CGRectGetMaxY(_carryLabel.frame)+1, 50, 30) withFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#fda803"]];
        [self.contentView addSubview:_extentLabel];
        _extentdanweiLabel = [self createLabelwithFrame:CGRectMake(CGRectGetMaxX(_extentLabel.frame), CGRectGetMaxY(_carryLabel.frame)+1, 30, 30) withFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        _extentdanweiLabel.text = @"m";
        [self.contentView addSubview:_extentdanweiLabel];
    }
    else if (_indexpath.section==1)
    {
        _nameLabel = [self createLabelwithFrame:CGRectMake(20, 5, (SCREEN_WIDTH-20)/2, 30) withFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        [self.contentView addSubview:_nameLabel];
        _timeLabel = [self createLabelwithFrame:CGRectMake(SCREEN_WIDTH-(SCREEN_WIDTH/2)-10, 5, SCREEN_WIDTH/2, 30) withFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#999999"]];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_timeLabel];
        _bigbiLabel = [self createLabelwithFrame:CGRectMake(20, CGRectGetMaxY(_nameLabel.frame)+1, 100, 30) withFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        _bigbiLabel.text = @"大臂长";
        [self.contentView addSubview:_bigbiLabel];
        _pinghengbiLabel =[self createLabelwithFrame:CGRectMake(20, CGRectGetMaxY(_bigbiLabel.frame)+1, 100, 30) withFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        _pinghengbiLabel.text =@"平衡臂长";
        [self.contentView addSubview:_pinghengbiLabel];
        _bigArmLabel = [self createLabelwithFrame:CGRectMake(CGRectGetMaxX(_bigbiLabel.frame)+20, CGRectGetMaxY(_nameLabel.frame)+1, SCREEN_WIDTH-_TaDiaoStates.width, 30) withFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#fda803"]];
        [self.contentView addSubview:_bigArmLabel];
        _balanceArmLabel = [self createLabelwithFrame:CGRectMake(CGRectGetMaxX(_pinghengbiLabel.frame)+20, CGRectGetMaxY(_bigArmLabel.frame)+1, SCREEN_WIDTH-_TaDiaoStates.width, 30) withFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#fda803"]];
        [self.contentView addSubview:_balanceArmLabel];
        _fengeView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_balanceArmLabel.frame)+1, SCREEN_WIDTH, 15)];
        _fengeView.backgroundColor = [UIColor hcy_colorWithString:@"#f7f7f7"];
        [self.contentView addSubview:_fengeView];
        UIView * firstV = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_balanceArmLabel.frame)+1, SCREEN_WIDTH, 1)];
        firstV.backgroundColor = [UIColor hcy_colorWithString:@"#e0e0e0"];
        [self.contentView addSubview:firstV];
        UIView * secondV = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_fengeView.frame)-1, SCREEN_WIDTH, 1)];
        secondV.backgroundColor = [UIColor hcy_colorWithString:@"#e0e0e0"];
        [self.contentView addSubview:secondV];
        
        _lijuLabel = [self createLabelwithFrame:CGRectMake(20, CGRectGetMaxY(_fengeView.frame)+15, 60, 20) withFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        _lijuLabel.text =@"力矩";
        [self.contentView addSubview:_lijuLabel];
        _lijuSubLabel = [self createLabelwithFrame:CGRectMake(20, CGRectGetMaxY(_lijuLabel.frame)+5, 60, 20) withFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#fda803"]];
        [self.contentView addSubview:_lijuSubLabel];
        _lijudanweiBtn = [self createButtonwithFrame:CGRectMake(CGRectGetMaxX(_lijuLabel.frame)+3, CGRectGetMaxY(_fengeView.frame)+10, 25, 25) withImage:[UIImage imageNamed:@"力矩图标"]];
        [self.contentView addSubview:_lijudanweiBtn];
        _lijudanweiLabel =[self createLabelwithFrame:CGRectMake(CGRectGetMaxX(_lijuLabel.frame)+3, CGRectGetMaxY(_lijudanweiBtn.frame)+5, 30, 20) withFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        _lijudanweiLabel.text =@"t.m";
        [self.contentView addSubview:_lijudanweiLabel];
        _lijuProgress = [self createProgressViewwithFrame:CGRectMake(CGRectGetMaxX(_lijudanweiBtn.frame)+10, CGRectGetMaxY(_fengeView.frame)+23, (SCREEN_WIDTH-CGRectGetMaxX(_lijudanweiBtn.frame)-30), 22) withProgress:0];
        [self.contentView addSubview:_lijuProgress];
        _lijuView = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_lijuSubLabel.frame)+10, SCREEN_WIDTH-40, 1)];
        _lijuView.backgroundColor = [UIColor hcy_colorWithString:@"#e0e0e0"];
        [self.contentView addSubview:_lijuView];
        _zaizhongLabel = [self createLabelwithFrame:CGRectMake(20, CGRectGetMaxY(_lijuView.frame)+15, 60, 20) withFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        _zaizhongLabel.text = @"载重";
        [self.contentView addSubview:_zaizhongLabel];
        _zaizhongSubLabel = [self createLabelwithFrame:CGRectMake(20, CGRectGetMaxY(_zaizhongLabel.frame)+5, 60, 20) withFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#fda803"]];
        [self.contentView addSubview:_zaizhongSubLabel];
        _zaizhongdanweiBtn = [self createButtonwithFrame:CGRectMake(CGRectGetMaxX(_zaizhongLabel.frame)+3, CGRectGetMaxY(_lijuView.frame)+10, 25, 25) withImage:[UIImage imageNamed:@"载重图标"]];
        [self.contentView addSubview:_zaizhongdanweiBtn];
        _zaizhongdanweiLabel = [self createLabelwithFrame:CGRectMake(CGRectGetMaxX(_zaizhongLabel.frame)+3, CGRectGetMaxY(_zaizhongdanweiBtn.frame)+5, 25, 20) withFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        _zaizhongdanweiLabel.textAlignment = NSTextAlignmentCenter;
        _zaizhongdanweiLabel.text = @"kg";
        [self.contentView addSubview:_zaizhongdanweiLabel];
        _zaizhongProgress = [self createProgressViewwithFrame:CGRectMake(CGRectGetMaxX(_zaizhongdanweiBtn.frame)+10, CGRectGetMaxY(_lijuView.frame)+23, (SCREEN_WIDTH-CGRectGetMaxX(_lijudanweiBtn.frame)-30), 22) withProgress:0];
        [self.contentView addSubview:_zaizhongProgress];
        _zaizhongView = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_zaizhongSubLabel.frame)+10, SCREEN_WIDTH-40, 1)];
        _zaizhongView.backgroundColor = [UIColor hcy_colorWithString:@"#e0e0e0"];
        [self.contentView addSubview:_zaizhongView];
        _windLabel = [self createLabelwithFrame:CGRectMake(20, CGRectGetMaxY(_zaizhongView.frame)+15, 60, 20) withFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        _windLabel.text = @"风速";
        [self.contentView addSubview:_windLabel];
        _windSubLabel =  [self createLabelwithFrame:CGRectMake(20, CGRectGetMaxY(_windLabel.frame)+5, 60, 20) withFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#fda803"]];
        [self.contentView addSubview:_windSubLabel];
        _winddanweiBtn = [self createButtonwithFrame:CGRectMake(CGRectGetMaxX(_windLabel.frame)+3, CGRectGetMaxY(_zaizhongView.frame)+10, 25, 25) withImage:[UIImage imageNamed:@"风速图标"]];
        [self.contentView addSubview:_winddanweiBtn];
        _winddanweiLabel = [self createLabelwithFrame:CGRectMake(CGRectGetMaxX(_windLabel.frame)+2, CGRectGetMaxY(_winddanweiBtn.frame)+5, 33, 20) withFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        _winddanweiLabel.text = @"m/s";
        [self.contentView addSubview:_winddanweiLabel];
        _windProgress = [self createProgressViewwithFrame:CGRectMake(CGRectGetMaxX(_winddanweiBtn.frame)+10, CGRectGetMaxY(_zaizhongView.frame)+23, (SCREEN_WIDTH-CGRectGetMaxX(_lijudanweiBtn.frame)-30), 22) withProgress:0];
        [self.contentView addSubview:_windProgress];
        _fengsuView = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_windSubLabel.frame)+10, SCREEN_WIDTH-40, 1)];
        _fengsuView.backgroundColor = [UIColor hcy_colorWithString:@"#e0e0e0"];
        [self.contentView addSubview:_fengsuView];
        
        _fuduLabel = [self createLabelwithFrame:CGRectMake(20, CGRectGetMaxY(_fengsuView.frame)+15, 60, 20) withFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        _fuduLabel.text = @"幅度";
        [self.contentView addSubview:_fuduLabel];
        _fuduSubLabel = [self createLabelwithFrame:CGRectMake(20, CGRectGetMaxY(_fuduLabel.frame)+5, 60, 20) withFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#fda803"]];
        //        _fuduSubLabel.text = @"7.9";
        [self.contentView addSubview:_fuduSubLabel];
        _fududanweiBtn = [self createButtonwithFrame:CGRectMake(CGRectGetMaxX(_fuduLabel.frame)+5, CGRectGetMaxY(_fengsuView.frame)+10, 25, 25) withImage:[UIImage imageNamed:@"幅度图标"]];
        [self.contentView addSubview:_fududanweiBtn];
        _fududanweiLabel = [self createLabelwithFrame:CGRectMake(CGRectGetMaxX(_fuduLabel.frame)+3, CGRectGetMaxY(_fududanweiBtn.frame)+5, 25, 20) withFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        _fududanweiLabel.textAlignment = NSTextAlignmentCenter;
        _fududanweiLabel.text = @"m";
        [self.contentView addSubview:_fududanweiLabel];
        _fuduProgress = [self createProgressViewwithFrame:CGRectMake(CGRectGetMaxX(_fududanweiBtn.frame)+10, CGRectGetMaxY(_fengsuView.frame)+23, (SCREEN_WIDTH-CGRectGetMaxX(_lijudanweiBtn.frame)-30), 22) withProgress:0.079];
        [self.contentView addSubview:_fuduProgress];
        _fuduView = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_fuduSubLabel.frame)+10, SCREEN_WIDTH-40, 1)];
        _fuduView.backgroundColor = [UIColor hcy_colorWithString:@"#e0e0e0"];
        [self.contentView addSubview:_fuduView];
        _gaoduLabel = [self createLabelwithFrame:CGRectMake(20, CGRectGetMaxY(_fuduView.frame)+15, 60, 20) withFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        _gaoduLabel.text = @"高度";
        [self.contentView addSubview:_gaoduLabel];
        _gaoduSubLabel = [self createLabelwithFrame:CGRectMake(20, CGRectGetMaxY(_gaoduLabel.frame)+5, 60, 20) withFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#fda803"]];
        //        _gaoduSubLabel.text = @"2.00";
        [self.contentView addSubview:_gaoduSubLabel];
        _gaodudanweiBtn = [self createButtonwithFrame:CGRectMake(CGRectGetMaxX(_gaoduLabel.frame)+5, CGRectGetMaxY(_fuduView.frame)+10, 25, 25) withImage:[UIImage imageNamed:@"高度图标"]];
        [self.contentView addSubview:_gaodudanweiBtn];
        _gaodudanweiLabel = [self createLabelwithFrame:CGRectMake(CGRectGetMaxX(_gaoduLabel.frame)+5, CGRectGetMaxY(_gaodudanweiBtn.frame)+5, 25, 20) withFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        _gaodudanweiLabel.textAlignment = NSTextAlignmentCenter;
        _gaodudanweiLabel.text = @"m";
        [self.contentView addSubview:_gaodudanweiLabel];
        _gaoduProgress = [self createProgressViewwithFrame:CGRectMake(CGRectGetMaxX(_gaodudanweiBtn.frame)+10, CGRectGetMaxY(_fuduView.frame)+23, (SCREEN_WIDTH-CGRectGetMaxX(_lijudanweiBtn.frame)-30), 22) withProgress:0.2];
        [self.contentView addSubview:_gaoduProgress];
        _gaoduView = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_gaoduSubLabel.frame)+10, SCREEN_WIDTH-40, 1)];
        _gaoduView.backgroundColor = [UIColor hcy_colorWithString:@"#e0e0e0"];
        [self.contentView addSubview:_gaoduView];
        _jiaoduLabel = [self createLabelwithFrame:CGRectMake(20, CGRectGetMaxY(_gaoduView.frame)+15, 60, 20) withFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        _jiaoduLabel.text = @"角度";
        [self.contentView addSubview:_jiaoduLabel];
        _jiaoduSubLabel = [self createLabelwithFrame:CGRectMake(20, CGRectGetMaxY(_jiaoduLabel.frame)+5, 60, 20) withFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#fda803"]];
        //        _jiaoduSubLabel.text = @"0.00";
        [self.contentView addSubview:_jiaoduSubLabel];
        _jiaodudanweiBtn = [self createButtonwithFrame:CGRectMake(CGRectGetMaxX(_jiaoduLabel.frame)+5, CGRectGetMaxY(_gaoduView.frame)+10, 25, 25) withImage:[UIImage imageNamed:@"角度图标"]];
        [self.contentView addSubview:_jiaodudanweiBtn];
        _jiaodudanweiLabel = [self createLabelwithFrame:CGRectMake(CGRectGetMaxX(_jiaoduLabel.frame)+5, CGRectGetMaxY(_jiaodudanweiBtn.frame)+5, 25, 20) withFont:[YZLabelFactory bigFont] withTextColor:[UIColor hcy_colorWithString:@"#333333"]];
        _jiaodudanweiLabel.textAlignment = NSTextAlignmentCenter;
        _jiaodudanweiLabel.text = @"o";
        [self.contentView addSubview:_jiaodudanweiLabel];
        _jiaoduProgress = [self createProgressViewwithFrame:CGRectMake(CGRectGetMaxX(_jiaodudanweiBtn.frame)+10, CGRectGetMaxY(_gaoduView.frame)+23, (SCREEN_WIDTH-CGRectGetMaxX(_lijudanweiBtn.frame)-30), 22) withProgress:0];
        [self.contentView addSubview:_jiaoduProgress];
        _jiaoduView = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_jiaoduSubLabel.frame)+5, SCREEN_WIDTH-40, 1)];
        _jiaoduView.backgroundColor = [UIColor hcy_colorWithString:@"#e0e0e0"];
        [self.contentView addSubview:_jiaoduView];
        
    }
}
/**创建进度条*/
-(LDProgressView *)createProgressViewwithFrame:(CGRect)frame withProgress:(CGFloat)progress
{
    LDProgressView * progressView = [[LDProgressView alloc]initWithFrame:frame];
    progressView.color = [UIColor hcy_colorWithString:@"#4ac120"];
    progressView.background = [UIColor hcy_colorWithString:@"#d6f5cc"];
    progressView.flat = @YES;
    progressView.borderRadius = @2;
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
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitleColor:[UIColor blackColor] forState:0];
    [button setImage:image forState:0];
    return button;
}
-(UILabel *)createLabelwithFrame:(CGRect)frame withFont:(UIFont *)font withTextColor:(UIColor *)color
{
    UILabel * label = [[UILabel alloc]initWithFrame:frame];
    label.font = font;
    label.textColor = color;
    return label;
}
@end
