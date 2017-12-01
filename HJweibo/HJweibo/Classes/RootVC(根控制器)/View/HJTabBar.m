//
//  HJTabBar.m
//  HJweibo
//
//  Created by Jermy on 2017/6/9.
//  Copyright © 2017年 Jermy. All rights reserved.
//  自定义tabbar,中间添加发布按钮

#import "HJTabBar.h"

@interface HJTabBar()

@property(nonatomic, weak)UIButton *addBtn;

@end

@implementation HJTabBar

//修改tabbar上按钮的布局
-(void)layoutSubviews
{
    [super layoutSubviews];

    NSInteger index = 0;
    
    //按钮的宽度和高度
    CGFloat btnW = self.frame.size.width / 5.0;
    CGFloat btnH = self.frame.size.height;
    if(iPhoneX){
        btnH = btnH - iPhoneXBottomPadding;
    }
    CGFloat btnY = 0;
    
    for(UIView *view in self.subviews){
                
        //如果子控件不是UITabBarButton类型，直接返回
        if(![view isKindOfClass:NSClassFromString(@"UITabBarButton")]){
            
            continue;
        }
        
        //修改UITabBarButton的frame
        CGFloat btnX = index * btnW;
        
        //如果是第2、3个按钮，需要向后移动一个按钮的宽度
        if(index > 1){
            btnX += btnW;
        }
        
        view.frame = CGRectMake(btnX, btnY, btnW, btnH);
        
        index++;
    }
    
    //添加按钮
    self.addBtn.frame = CGRectMake(btnW * 2, 0, btnW, btnH);
}

//懒加载
-(UIButton *)addBtn
{
    if(_addBtn == nil){
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"tabbar_compose_icon_cancel"] forState:UIControlStateHighlighted];
        
        [btn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
        
        [btn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        _addBtn = btn;
        
        [self addSubview:btn];
    }
    
    return _addBtn;
}

-(void)addBtnClick
{    
    if([self.myDelegate respondsToSelector:@selector(HJTabBarAddBtnClick)]){
        [self.myDelegate HJTabBarAddBtnClick];
    }
        
}

@end
