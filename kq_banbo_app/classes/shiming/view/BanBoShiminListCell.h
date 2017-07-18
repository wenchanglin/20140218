//
//  BanBoShiminListCell.h
//  kq_banbo_app
//
//  Created by hcy on 2016/12/2.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  BanBoShiminListItem;
@interface BanBoShiminListCell : UICollectionViewCell
-(void)refreshWithItem:(BanBoShiminListItem *)item;
@end
