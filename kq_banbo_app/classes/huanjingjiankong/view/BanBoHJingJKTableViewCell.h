//
//  BanBoHJingJKTableViewCell.h
//  kq_banbo_app
//
//  Created by banbo on 2017/5/2.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BanBoHuanJModel.h"
@interface BanBoHJingJKTableViewCell : UITableViewCell
/** pm2.5图片*/
@property(nonatomic,strong)UIImageView * pm1Img;
/**pm2.5文本*/
@property(nonatomic,strong)UILabel * pm1Label;
/**pm2.5指示按钮*/
@property(nonatomic,strong)UIButton * pm1ZShiBtn;
/*图片500刻度*/
@property(nonatomic,strong)UIImageView * youBiao500;

/**pm10*/
@property(nonatomic,strong)UIImageView * pm10Image;
/**pm10文本*/
@property(nonatomic,strong)UILabel *pm10Label;
/**图片600刻度*/
@property(nonatomic,strong)UIImageView * youBiao600;
/*pm10 指示按钮*/
@property(nonatomic,strong)UIButton * pm10ZShiBtn;

/**tsp图片*/
@property(nonatomic,strong)UIImageView * tspImage;
/**tsp文本*/
@property(nonatomic,strong)UILabel * tspLabel;

/**温度图片*/
@property(nonatomic,strong)UIImageView *temperImage;
@property(nonatomic,strong)UILabel * temperLabel;

/**湿度图片*/
@property(nonatomic,strong)UIImageView * humidityImage;
/**湿度文本*/
@property(nonatomic,strong)UILabel * humidityLabel;

/**风速图片*/
@property(nonatomic,strong)UIImageView * windSpeedImage;
/**风速文本*/
@property(nonatomic,strong)UILabel * windSpeedLabel;

/**风向图片*/
@property(nonatomic,strong)UIImageView * windDirectionImage;
/**风向文本*/
@property(nonatomic,strong)UILabel * windDirectionLabel;

/**大气压图片*/
@property(nonatomic,strong)UIImageView * atmImage;
/**大气压文本*/
@property(nonatomic,strong)UILabel * atmLabel;
/**噪音图片*/
@property(nonatomic,strong)UIImageView * noiseImage;
/**噪音文本*/
@property(nonatomic,strong)UILabel * noiseLabel;
@property(nonatomic,strong)NSIndexPath * indepath;
@property(nonatomic,strong)BanBoHuanJModel * models;
-(void)setDataWithIndexPath:(NSIndexPath *)indexpath withModel:(BanBoHuanJModel *)models;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withIndexPath:(NSIndexPath *)indexpath;

@end
