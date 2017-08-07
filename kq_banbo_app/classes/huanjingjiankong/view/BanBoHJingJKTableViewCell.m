//
//  BanBoHJingJKTableViewCell.m
//  kq_banbo_app
//
//  Created by banbo on 2017/5/2.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import "BanBoHJingJKTableViewCell.h"

@implementation BanBoHJingJKTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withIndexPath:(NSIndexPath *)indexpath
{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _indepath = indexpath;
        [self createUI];
    }
    return self;
}
-(void)setDataWithIndexPath:(NSIndexPath *)indexpath withModel:(BanBoHuanJModel *)models
{
    _models =models;
    if (indexpath.row==0) {
        _pm1Label.text = [NSString stringWithFormat:@"PM2.5浓度:%@ug/m³",_models.pm2p5];
        _pm1ZShiBtn = [[UIButton alloc]initWithFrame:CGRectMake(((SCREEN_WIDTH-40)/6/50*[_models.pm2p5 integerValue]+1),CGRectGetMaxY(_pm1Img.frame)+2, 40, 25)];//本来是-10现在+1
        if ([_models.pm2p5 intValue]>=0&&[_models.pm2p5 intValue]<=50) {
            [_pm1ZShiBtn setBackgroundImage:[UIImage imageNamed:@"绿色"] forState:UIControlStateNormal];
            [_pm1ZShiBtn setTitle:_models.pm2p5Msg forState:UIControlStateNormal];
        }
        else if ([_models.pm2p5 intValue]>=51&&[_models.pm2p5 intValue]<=100)
        {
            [_pm1ZShiBtn setBackgroundImage:[UIImage imageNamed:@"黄色"] forState:UIControlStateNormal];
            [_pm1ZShiBtn setTitle:_models.pm2p5Msg forState:UIControlStateNormal];
        }
        else if ([_models.pm2p5 intValue]>=101&&[_models.pm2p5 intValue]<=150)
        {
            [_pm1ZShiBtn setBackgroundImage:[UIImage imageNamed:@"橘色"] forState:UIControlStateNormal];
            [_pm1ZShiBtn setTitle:_models.pm2p5Msg forState:UIControlStateNormal];
        }
        else if ([_models.pm2p5 intValue]>=151&&[_models.pm2p5 intValue]<=200)
        {
            [_pm1ZShiBtn setBackgroundImage:[UIImage imageNamed:@"红色"] forState:UIControlStateNormal];
            [_pm1ZShiBtn setTitle:_models.pm2p5Msg forState:UIControlStateNormal];
        }
        else if ([_models.pm2p5 intValue]>=201&&[_models.pm2p5 intValue]<=300)
        {
            _pm1ZShiBtn = [[UIButton alloc]initWithFrame:CGRectMake(((SCREEN_WIDTH-40)/6/50*[_models.pm2p5 integerValue]-1),CGRectGetMaxY(_pm1Img.frame)+2, 40, 25)];//本来是-10现在+1
            [_pm1ZShiBtn setBackgroundImage:[UIImage imageNamed:@"深紫"] forState:UIControlStateNormal];
            [_pm1ZShiBtn setTitle:_models.pm2p5Msg forState:UIControlStateNormal];
        }
        _pm1ZShiBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_pm1ZShiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.contentView addSubview:_pm1ZShiBtn];
        
    }
    else if (indexpath.row==1)
    {
        _pm10Label.text = [NSString stringWithFormat:@"PM10浓度:%@ug/m³",_models.pm10];
        _pm10ZShiBtn = [[UIButton alloc]initWithFrame:CGRectMake(((SCREEN_WIDTH-40)/6/100*[_models.pm10 integerValue]+1),CGRectGetMaxY(_pm10Image.frame)+2, 40, 25)];//本来是-10现在+1;
        if ([_models.pm10 intValue]>=0&&[_models.pm10 intValue]<=50) {
            [_pm10ZShiBtn setBackgroundImage:[UIImage imageNamed:@"绿色"] forState:UIControlStateNormal];
            [_pm10ZShiBtn setTitle:_models.pm10Msg forState:UIControlStateNormal];
        }
        else if ([_models.pm10 intValue]>=51&&[_models.pm10 intValue]<=150)
        {
            [_pm10ZShiBtn setBackgroundImage:[UIImage imageNamed:@"黄色"] forState:UIControlStateNormal];
            [_pm10ZShiBtn setTitle:_models.pm10Msg forState:UIControlStateNormal];
        }
        else if ([_models.pm10 intValue]>=151&&[_models.pm10 intValue]<=250)
        {
            [_pm10ZShiBtn setBackgroundImage:[UIImage imageNamed:@"橘色"] forState:UIControlStateNormal];
            [_pm10ZShiBtn setTitle:_models.pm10Msg forState:UIControlStateNormal];
        }
        else if ([_models.pm10 intValue]>=251&&[_models.pm10 intValue]<=350)
        {
            [_pm10ZShiBtn setBackgroundImage:[UIImage imageNamed:@"红色"] forState:UIControlStateNormal];
            [_pm10ZShiBtn setTitle:_models.pm10Msg forState:UIControlStateNormal];
        }
        else if ([_models.pm10 intValue]>=351&&[_models.pm10 intValue]<=450)
        {
            
            [_pm10ZShiBtn setBackgroundImage:[UIImage imageNamed:@"淡紫"] forState:UIControlStateNormal];
            [_pm10ZShiBtn setTitle:_models.pm10Msg forState:UIControlStateNormal];
        }
        else if ([_models.pm10 intValue]>=451&&[_models.pm10 intValue]<=600)
        {
            _pm10ZShiBtn = [[UIButton alloc]initWithFrame:CGRectMake(((SCREEN_WIDTH-40)/6/100*[_models.pm10 integerValue]-2),CGRectGetMaxY(_pm10Image.frame)+2, 40, 25)];//本来是-10现在+1
            [_pm10ZShiBtn setBackgroundImage:[UIImage imageNamed:@"深紫"] forState:UIControlStateNormal];
            [_pm10ZShiBtn setTitle:_models.pm10Msg forState:UIControlStateNormal];
        }
        _pm10ZShiBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_pm10ZShiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.contentView addSubview:_pm10ZShiBtn];
    }
    else if (indexpath.row==2)
    {
        _tspLabel.text =[NSString stringWithFormat:@"TSP(总悬浮颗粒物):%@ug/m³",_models.tsp];
    }
    else if (indexpath.row==3)
    {
        _temperLabel.text = [NSString stringWithFormat:@"温度:%@度",_models.temp];
        _humidityLabel.text =[NSString stringWithFormat:@"湿度:%@%%",_models.humi];
    }
    else if (indexpath.row==4)
    {
        _windSpeedLabel.text =[NSString stringWithFormat:@"风速:%@",_models.windScale];
        _windDirectionLabel.text = [NSString stringWithFormat:@"风向:%@",_models.wdir];
        
    }
    else if (indexpath.row==5)
    {
        _atmLabel.text = [NSString stringWithFormat:@"大气压:%@hpa",_models.atm];
    }
    else if (indexpath.row==6)
    {
        _noiseLabel.text =[NSString stringWithFormat:@"噪音:%@dB",_models.nvh];
    }
}

-(void)createUI
{
    if (_indepath.row==0) {
        _pm1Img = [self initsdImageViewFrame:CGRectMake(15, 10, 26, 26) withImageName:@"PM2.51"];
        [self.contentView addSubview:_pm1Img];
        _pm1Label = [self initsdLabelFrame:CGRectMake(CGRectGetMaxX(_pm1Img.frame)+1, 10, SCREEN_WIDTH-37, 26) ];
        [self.contentView addSubview:_pm1Label];
        _youBiao500 = [[UIImageView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_pm1Img.frame)+30, SCREEN_WIDTH-40, 30)];
        _youBiao500.image = [UIImage imageNamed:@"500刻度"];
        [self.contentView addSubview:_youBiao500];
        
    }
    else if (_indepath.row==1)
    {
        _pm10Image = [self initsdImageViewFrame:CGRectMake(15, 10, 26, 26) withImageName:@"PM101"];
        [self.contentView addSubview:_pm10Image];
        _pm10Label = [self initsdLabelFrame:CGRectMake(CGRectGetMaxX(_pm10Image.frame)+1, 10, SCREEN_WIDTH-37, 26)];
        [self.contentView addSubview:_pm10Label];
        _youBiao500 = [[UIImageView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_pm10Image.frame)+30, SCREEN_WIDTH-40, 30)];
        _youBiao500.image = [UIImage imageNamed:@"600刻度"];
        [self.contentView addSubview:_youBiao500];
    }
    else if (_indepath.row==2)
    {
        _tspImage = [self initsdImageViewFrame:CGRectMake(15, 10, 26, 26) withImageName:@"TSP1"];
        [self.contentView addSubview:_tspImage];
        _tspLabel =[self initsdLabelFrame:CGRectMake(CGRectGetMaxX(_tspImage.frame)+1, 10, SCREEN_WIDTH-37, 26)];
        [self.contentView addSubview:_tspLabel];
    }
    else if(_indepath.row==3)
    {
        _temperImage = [self initsdImageViewFrame:CGRectMake(15, 10, 26, 26) withImageName:@"温度计1"];
        [self.contentView addSubview:_temperImage];
        _temperLabel = [self initsdLabelFrame:CGRectMake(CGRectGetMaxX(_temperImage.frame)+1, 10, SCREEN_WIDTH/2-37, 26)];
        [self.contentView addSubview:_temperLabel];
        
        _humidityImage = [self initsdImageViewFrame:CGRectMake(SCREEN_WIDTH/2+10, 10, 26, 26) withImageName:@"湿度1"];
        [self.contentView addSubview:_humidityImage];
        _humidityLabel = [self initsdLabelFrame:CGRectMake(CGRectGetMaxX(_humidityImage.frame)+1, 10, SCREEN_WIDTH/2-31, 26)];
        [self.contentView addSubview:_humidityLabel];
    }
    else if (_indepath.row==4)
    {
        _windSpeedImage = [self initsdImageViewFrame:CGRectMake(15, 10, 26, 26) withImageName:@"风速1"];
        [self.contentView addSubview:_windSpeedImage];
        _windSpeedLabel = [self initsdLabelFrame:CGRectMake(CGRectGetMaxX(_windSpeedImage.frame)+1, 10, SCREEN_WIDTH/2-37, 26)];
        [self.contentView addSubview:_windSpeedLabel];
        
        _windDirectionImage = [self initsdImageViewFrame:CGRectMake(SCREEN_WIDTH/2+10, 10, 26, 26) withImageName:@"风向1"];
        [self.contentView addSubview:_windDirectionImage];
        _windDirectionLabel = [self initsdLabelFrame:CGRectMake(CGRectGetMaxX(_windDirectionImage.frame)+1, 10, SCREEN_WIDTH/2-37, 26)];
        [self.contentView addSubview:_windDirectionLabel];
        
    }
    else if (_indepath.row==5)
    {
        _atmImage =[self initsdImageViewFrame:CGRectMake(15, 10, 26, 26) withImageName:@"大气压力1"];
        [self.contentView addSubview:_atmImage];
        
        _atmLabel = [self initsdLabelFrame:CGRectMake(CGRectGetMaxX(_atmImage.frame)+1, 10, SCREEN_WIDTH-20, 26)];
        [self.contentView addSubview:_atmLabel];
    }
    else if (_indepath.row==6)
    {
        _noiseImage =[self initsdImageViewFrame:CGRectMake(15, 10, 26, 26) withImageName:@"噪音1"];;
        [self.contentView addSubview:_noiseImage];
        _noiseLabel = [self initsdLabelFrame:CGRectMake(CGRectGetMaxX(_noiseImage.frame)+1, 10, SCREEN_WIDTH-20, 26)];
        [self.contentView addSubview:_noiseLabel];
        
    }
    
    
}
#pragma mark - 封装图片

-(UIImageView *)initsdImageViewFrame:(CGRect)cgrect withImageName:(NSString *)imageStr
{
    UIImageView * imagView = [[UIImageView alloc]initWithFrame:cgrect];
    imagView.image = [UIImage imageNamed:imageStr];
    imagView.contentMode = UIViewContentModeScaleAspectFill;
    return imagView;
}
#pragma mark - 封装文字
-(UILabel *)initsdLabelFrame:(CGRect)cgrect
{
    UILabel * sLabels = [[UILabel alloc]initWithFrame:cgrect];
    sLabels.font = [UIFont systemFontOfSize:16];
    sLabels.textColor = [UIColor blackColor];
    return sLabels;
}
@end
