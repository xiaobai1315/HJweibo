//
//  HJButton.m
//  HJweibo
//
//  Created by Jermy on 2017/6/12.
//  Copyright © 2017年 Jermy. All rights reserved.
//

#import "HJButton.h"

@implementation HJButton

//修改按钮的布局
-(void)layoutSubviews
{
    [super layoutSubviews];
        
    //修改imageView的frame
    CGFloat imageViewW = self.imageView.frame.size.width;
    CGFloat imageViewH = self.imageView.frame.size.height;
    CGFloat imageViewX = (80 - imageViewW) * 0.5;
    CGFloat imageViewY = 0;
    
    self.imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
    
    //修改titleLabel的frame
    CGFloat titleLabelW = 80;
    CGFloat titleLabelH = 80 - imageViewH;
    CGFloat titleLabelX = 0;
    CGFloat titleLabelY = imageViewH;
    
    self.titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
}


@end
