//
//  UIBarButtonItem+HJButton.h
//  HJweibo
//
//  Created by Jermy on 2017/6/15.
//  Copyright © 2017年 Jermy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (HJButton)

//设置导航栏按钮的图片、选中图片
-(instancetype)initWithImage:(NSString *) imageName selectedImage:(NSString *)selectedImage  target:(id) target action:(SEL) selector;

//设置导航栏按钮的文字、选择颜色
-(instancetype)initWithTitle:(NSString *)title selectedColor:(UIColor *)color target:(id) target action:(SEL) selector;

@end
