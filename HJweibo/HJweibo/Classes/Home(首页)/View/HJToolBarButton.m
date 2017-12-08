//
//  HJToolBarButton.m
//  HJweibo
//
//  Created by Jermy on 2017/12/7.
//  Copyright © 2017年 Jermy. All rights reserved.
//

#import "HJToolBarButton.h"

@implementation HJToolBarButton

-(void)layoutSubviews
{
    [super layoutSubviews];

    self.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    self.titleLabel.font = [UIFont systemFontOfSize:15];
}

@end
