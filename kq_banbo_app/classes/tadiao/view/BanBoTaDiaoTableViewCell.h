//
//  BanBoTaDiaoTableViewCell.h
//  kq_banbo_app
//
//  Created by banbo on 2017/5/27.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LDProgressView.h"
#import "BanBoTaDiaoModel.h"
#import "BanBoTaDiaoSheBeiModel.h"
@interface BanBoTaDiaoTableViewCell : UITableViewCell
/**判断塔吊状态*/
@property(nonatomic,strong)UILabel * TaDiaoStates;
/**SIM卡*/
@property(nonatomic,strong)UILabel * simLabel;
/**手机号码*/
@property(nonatomic,strong)UILabel * phoneLabel;
/**经度*/
@property(nonatomic,strong)UILabel *  jingduLabel;
/**经度数值*/
@property(nonatomic,strong)UILabel * longitudeLabel;
/**纬度*/
@property(nonatomic,strong)UILabel * weiduLabel;
/**纬度数值*/
@property(nonatomic,strong)UILabel *  latitudeLabel;
/**倾角*/
@property(nonatomic,strong)UILabel *  qingjiaoLabel;
/**倾角数值*/
@property(nonatomic,strong)UILabel *  obliqueityLabel;
/**
 倾角度
 */
@property(nonatomic,strong)UILabel * qingjiaoduLabel;
/**倍率*/
@property(nonatomic,strong)UILabel * beilvLabel;
/**倍率数值*/
@property(nonatomic,strong)UILabel * multiplyLabel;
/**最大载重*/
@property(nonatomic,strong)UILabel * zuidazaizhongLabel;
/**载重数值*/
@property(nonatomic,strong)UILabel * carryLabel;
/**
 载重数值单位
 */
@property(nonatomic,strong)UILabel * carrydanweiLabel;
/**最大幅度*/
@property(nonatomic,strong)UILabel * zuidafuduLabel;
/**幅度数值*/
@property(nonatomic,strong)UILabel * extentLabel;
/**
 幅度数值单位
 */
@property(nonatomic,strong)UILabel * extentdanweiLabel;
/**塔吊名字*/
@property(nonatomic,strong)UILabel * nameLabel;
/**时间*/
@property(nonatomic,strong)UILabel * timeLabel;
/**大臂*/
@property(nonatomic,strong)UILabel * bigbiLabel;
/**大臂数值*/
@property(nonatomic,strong)UILabel * bigArmLabel;
/**平衡臂*/
@property(nonatomic,strong)UILabel * pinghengbiLabel;
/**平衡臂数值*/
@property(nonatomic,strong)UILabel * balanceArmLabel;
/**分割线*/
@property(nonatomic,strong)UIView * fengeView;
/**力矩*/
@property(nonatomic,strong)UILabel * lijuLabel;
@property(nonatomic,strong)UILabel * lijuSubLabel;
/**力矩单位*/
@property(nonatomic,strong)UIButton * lijudanweiBtn;
@property(nonatomic,strong)UILabel * lijudanweiLabel;
/**力矩进度条*/
@property(nonatomic,strong)LDProgressView * lijuProgress;
@property(nonatomic,strong)UIView * lijuView;
/**载重*/
@property(nonatomic,strong)UILabel * zaizhongLabel;
@property(nonatomic,strong)UILabel * zaizhongSubLabel;
/**载重单位*/
@property(nonatomic,strong)UIButton * zaizhongdanweiBtn;
@property(nonatomic,strong)UILabel * zaizhongdanweiLabel;
/**载重进度条*/
@property(nonatomic,strong)LDProgressView * zaizhongProgress;
@property(nonatomic,strong)UIView * zaizhongView;
/**风速*/
@property(nonatomic,strong)UILabel * windLabel;
@property(nonatomic,strong)UILabel * windSubLabel;
/**风速单位*/
@property(nonatomic,strong)UIButton * winddanweiBtn;
@property(nonatomic,strong)UILabel * winddanweiLabel;
/**风速进度条*/
@property(nonatomic,strong)LDProgressView * windProgress;
@property(nonatomic,strong)UIView * fengsuView;
/**幅度*/
@property(nonatomic,strong)UILabel * fuduLabel;
@property(nonatomic,strong)UILabel * fuduSubLabel;
/**幅度单位*/
@property(nonatomic,strong)UIButton * fududanweiBtn;
@property(nonatomic,strong)UILabel * fududanweiLabel;
/**幅度进度条*/
@property(nonatomic,strong)LDProgressView * fuduProgress;
@property(nonatomic,strong)UIView * fuduView;
/**高度*/
@property(nonatomic,strong)UILabel * gaoduLabel;
@property(nonatomic,strong)UILabel * gaoduSubLabel;
/**高度单位*/
@property(nonatomic,strong)UIButton * gaodudanweiBtn;
@property(nonatomic,strong)UILabel * gaodudanweiLabel;
/**高度进度条*/
@property(nonatomic,strong)LDProgressView * gaoduProgress;
@property(nonatomic,strong)UIView * gaoduView;
/**角度*/
@property(nonatomic,strong)UILabel * jiaoduLabel;
@property(nonatomic,strong)UILabel * jiaoduSubLabel;
/**角度单位*/
@property(nonatomic,strong)UIButton * jiaodudanweiBtn;
@property(nonatomic,strong)UILabel * jiaodudanweiLabel;
/**角度进度条*/
@property(nonatomic,strong)LDProgressView * jiaoduProgress;
@property(nonatomic,strong)UIView * jiaoduView;
@property(nonatomic)NSIndexPath *indexpath;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withIndexPath:(NSIndexPath *)indexpath;
-(void)setDataWithIndexPath:(NSIndexPath *)indexpath withModel:(BanBoTaDiaoModel *)models withSheBeiModel:(BanBoTaDiaoSheBeiModel *)shebeimodel;

@end
