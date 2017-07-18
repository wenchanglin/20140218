
//
//  UIImage+HCY.m
//  FriendCircle
//
//  Created by hcy on 15/12/21.
//  Copyright © 2015年 hcy. All rights reserved.
//

#import "UIImage+HCY.h"

@implementation UIImage (HCY)
+(instancetype)hcyImageNamed:(NSString *)name{
    UIImage *image=[UIImage imageNamed:[NSString stringWithFormat:@"HCYFC.bundle/hcy_%@",name]];
    if (!image) {
        image=[UIImage imageNamed:name];
    }
    return image;
}
@end
