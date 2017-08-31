//
//  HJTabBar.h
//  HJweibo
//
//  Created by Jermy on 2017/6/9.
//  Copyright © 2017年 Jermy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HJTabBarDelegate <NSObject>

-(void)HJTabBarAddBtnClick;

@end

@interface HJTabBar : UITabBar

@property(nonatomic, assign)id<HJTabBarDelegate> myDelegate;

@end
