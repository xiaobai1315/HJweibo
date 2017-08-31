//
//  UIImage+HJExtension.m
//  HJweibo
//
//  Created by Jermy on 2017/6/27.
//  Copyright © 2017年 Jermy. All rights reserved.
//

#import "UIImage+HJExtension.h"

@implementation UIImage (HJExtension)

-(instancetype)circleImage
{
    //按照屏幕分辨率处理,解决在Retain屏上模糊问题
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [UIScreen mainScreen].scale);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGContextAddEllipseInRect(ctx, rect);
    
    CGContextClip(ctx);
    
    [self drawInRect:rect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

+(instancetype)circleImageNamed:(NSString *)name
{
    return [[self imageNamed:name] circleImage];
}

@end
