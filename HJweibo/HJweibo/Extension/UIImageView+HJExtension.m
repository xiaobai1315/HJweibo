//
//  UIImageView+HJExtension.m
//  HJweibo
//
//  Created by Jermy on 2017/6/27.
//  Copyright © 2017年 Jermy. All rights reserved.
//

#import "UIImageView+HJExtension.h"

@implementation UIImageView (HJExtension)

-(void)setCircleHeaderWithUrl:(NSString *)url
{
    [self sd_setImageWithURL:[NSURL URLWithString:url]
            placeholderImage:nil
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     
                         if(image == nil) return;
                         
                         self.image = [image circleImage];
                     }];
}

@end
