//
//  UIBarButtonItem+HJButton.m
//  HJweibo
//
//  Created by Jermy on 2017/6/15.
//  Copyright © 2017年 Jermy. All rights reserved.
//  自定义UIBarButtonItem

#import "UIBarButtonItem+HJButton.h"

@implementation UIBarButtonItem (HJButton)

-(instancetype)initWithImage:(NSString *) imageName selectedImage:(NSString *)selectedImage  target:(id) target action:(SEL) selector
{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateHighlighted];
    [button sizeToFit];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return [self initWithCustomView:button];
}

//设置导航栏按钮的文字、选择颜色
-(instancetype)initWithTitle:(NSString *)title selectedColor:(UIColor *)color target:(id) target action:(SEL) selector
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    [button sizeToFit];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return [self initWithCustomView:button];
}

@end
