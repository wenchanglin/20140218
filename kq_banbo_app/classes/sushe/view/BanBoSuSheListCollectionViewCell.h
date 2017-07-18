//
//  BanBoSuSheListCollectionViewCell.h
//  kq_banbo_app
//
//  Created by banbo on 2017/4/18.
//  Copyright © 2017年 yzChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BanBoShiminListItem.h"
@interface BanBoSuSheListCollectionViewCell : UICollectionViewCell
-(void)refreshWithItem:(BanBoShiminListItem *)item;
@end
